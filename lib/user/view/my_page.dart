import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _sexValue = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();
    final name = userData.get('name');
    final age = userData.get('age');
    final sex = userData.get('sex');
    setState(() {
      _nameController.text = name;
      _ageController.text = age.toString();
      _sexValue = sex == 'male' ? '남자' : '여자';
    });
  }

  Future<void> _saveUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('Users').doc(user!.uid).update({
      'name': _nameController.text,
      'age': int.parse(_ageController.text),
      'sex': _sexValue == '남자' ? 'male' : 'female',
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '마이페이지',
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                  if (age == null || age <= 1) {
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
                    )
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _logout();
                      Navigator.of(context).pop();
                    },
                    child: const Text('로그아웃'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}