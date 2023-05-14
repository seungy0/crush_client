import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  final AuthenticationRepository authRepo;

  const MyPage({
    Key? key,
    required this.authRepo,
  }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _sexValue = '';
  //bool _isLoading = true; FutureBuilder+setState()로 인해 무한로딩되는거 방지

  Future<void>? _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final name = widget.authRepo.currentUserName;
    final age = await widget.authRepo.currentUserAge;
    final sex = await widget.authRepo.currentUserSex;
    setState(() {
      _nameController.text = name;
      _ageController.text = age.toString();
      _sexValue = sex == 'male' ? '남자' : '여자';
      //_isLoading = false;
    });
  }

  Future<void> _saveUserInfo() async {
    final userUid = widget.authRepo.currentUser;
    await FirebaseFirestore.instance.collection('Users').doc(userUid).update({
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'sex': _sexValue == '남자' ? 'male' : 'female',
    });
  }

  Future<void> _logout() async {
    await widget.authRepo.signOut(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이페이지',
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: FutureBuilder(
            future: _loadFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else {
                return _buildForm();
              }
            }),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: '이름',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력하세요.';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: '나이',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '나이를 입력하세요.';
              }
              final age = int.tryParse(value);
              if (age == null || age <= 2) {
                return '나이를 올바르게 입력하세요.';
              }
              return null;
            },
          ),
          DropdownButtonFormField<String>(
            value: _sexValue,
            decoration: const InputDecoration(
              labelText: '성별',
            ),
            items: const [
              DropdownMenuItem(
                value: '남자',
                child: Text('남자'),
              ),
              DropdownMenuItem(
                value: '여자',
                child: Text('여자'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _sexValue = value!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '성별을 선택하세요.';
              }
              return null;
            },
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _saveUserInfo();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('저장되었습니다.'),
                        ),
                      );
                    }
                  },
                  child: const Text('저장'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  )),
              const SizedBox(width: 16.0),
              ElevatedButton(
                  onPressed: () async {
                    await _logout();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/', (Route<dynamic> route) => false);
                  },
                  child: const Text('로그아웃'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
