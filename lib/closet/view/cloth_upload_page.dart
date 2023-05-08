import 'dart:convert';

import 'package:crush_client/closet/model/cloth_model.dart';

import 'package:crush_client/closet/view/image_upload.dart';
import 'package:crush_client/closet/view/my_palette.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClothInput extends StatefulWidget {
  @override
  _ClothInputState createState() => _ClothInputState();
}

class _ClothInputState extends State<ClothInput> {
  final ClothKey = GlobalKey<FormState>();
  String name = '';
  String color = '';
  String type = '';
  String thickness = '';
  late SharedPreferences prefs;
  Color selectedColor = Colors.white;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final Closet = prefs.getStringList('Closet');
    if (Closet != null) {
    } else {
      await prefs.setStringList('Closet', []);
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void _handleColorSelected(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '옷 추가',
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            ImageUploadBox(),
            Container(
              child: Form(
                key: this.ClothKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        renderTextFormField(
                          label: '옷 이름',
                          onSaved: (val) {
                            setState(() {
                              this.name = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '이름은 필수사항입니다.';
                            }
                            if (val.length < 2) {
                              return '이름은 두글자 이상 입력 해주셔야합니다.';
                            }
                            return null;
                          },
                        ),
                        renderTextFormField(
                          label: '색깔',
                          onSaved: (val) {
                            setState(() {
                              this.color = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '색깔은 필수사항입니다.';
                            }
                            return null;
                          },
                        ),
                        renderTextFormField(
                          label: '종류',
                          onSaved: (val) {
                            setState(() {
                              this.type = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '중류는 필수사항입니다.';
                            }
                            return null;
                          },
                        ),
                        renderTextFormField(
                          label: '두께',
                          onSaved: (val) {
                            setState(() {
                              this.thickness = val;
                            });
                          },
                          validator: (val) {
                            if (val.length < 1) {
                              return '두께는 필수사항입니다.';
                            }
                            return null;
                          },
                        ),
                        renderButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  renderButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200]),
      onPressed: () async {
        if (this.ClothKey.currentState!.validate()) {
          this.ClothKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('옷이 등록되었습니다.'),
            ),
          );
          final Closet = prefs.getStringList('Closet');
          if (Closet != null) {
            Closet.add(json.encode(Cloth(
                    name: name, color: color, type: type, thickness: thickness)
                .toJson()));
            await prefs.setStringList('Closet', Closet);
          }
          RepositoryProvider.of<FirestoreRepository>(context).addCloth(
              uid: RepositoryProvider.of<AuthenticationRepository>(context)
                  .currentUser,
              cloth: Cloth(
                name: name,
                color: color,
                type: type,
                thickness: thickness,
              ));
          Navigator.pop(context, true);
        }
      },
      child: const Text(
        '추가',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  renderTextFormField({
    required String label,
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
  }) {
    assert(onSaved != null);
    assert(validator != null);

    if (label == '색깔') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              MyPalette(
                onSaved: onSaved,
                onColorSelected: (Color color) {
                  onSaved(color.toString());
                },
              ),
            ],
          ),
          Container(
            height: 16.0,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  child: TextFormField(
                    onSaved: onSaved,
                    validator: validator,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 16.0,
          ),
        ],
      );
    }
  }
}
