import 'dart:io';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/const/colors.dart';

class MyCoordiUpload extends StatefulWidget {
  @override
  _MyCoordiUploadState createState() => _MyCoordiUploadState();
}

class _MyCoordiUploadState extends State<MyCoordiUpload> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코디 추가',
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    _imageFile =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {});
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.45,
                      color: Colors.grey,
                      child: _imageFile != null
                          ? Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width * 0.7,
                              height: MediaQuery.of(context).size.height * 0.45,
                            )
                          : const Icon(Icons.camera_alt),
                    ),
                  ),
                ),
                Container(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: InputDecoration(labelText: '제목'),
                              onSaved: (val) {
                                setState(() {
                                  this.title = val!;
                                });
                              },
                              validator: (val) {
                                if (val!.length < 1) {
                                  return '제목을 작성해주세요.';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              maxLines: 2,
                              minLines: 2,
                              decoration: InputDecoration(labelText: '코디 설명'),
                              onSaved: (val) {
                                setState(() {
                                  this.description = val!;
                                });
                              },
                              validator: (val) {
                                if (val!.length < 1) {
                                  return '설명을 작성해주세요.';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // 업로드 버튼 위치를 기기 종류에 상관없이 하단에 맞추기 위해 Stack+Align 사용
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.07),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('나의 코디 사진이 성공적으로 업로드 되었습니다.'),
                        //duration: Duration(milliseconds: 700),
                      ),
                    );
                    await RepositoryProvider.of<CoordiRepository>(context).uploadCoordi(
                      uid: RepositoryProvider.of<AuthenticationRepository>(context).currentUser,
                      title: title,
                      description: description,
                      image: File(_imageFile!.path),
                    );
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                child: const Text('업로드'),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
