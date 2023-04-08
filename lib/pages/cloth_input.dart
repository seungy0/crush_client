import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.blueAccent,
        title: const Text(
          '새 옷 등록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
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
    );
  }

  renderButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
      onPressed: () async {
        if (this.ClothKey.currentState!.validate()) {
          this.ClothKey.currentState!.save();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: const Text('옷이 등록되었습니다.'),
            ),
          );
          final Closet = prefs.getStringList('Closet');
          if (Closet != null) {
            Closet.add(json.encode(Cloth(name: name, color: color, type: type, thickness: thickness).toJson()));
            await prefs.setStringList('Closet', Closet);
          }
        }
      },
      child: const Text(
        '추가',
        style: TextStyle(
          color: Colors.blueAccent,
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

    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        TextFormField(
          onSaved: onSaved,
          validator: validator,
        ),
        Container(
          height: 16.0,
        ),
      ],
    );
  }
}
class Cloth {
  final String name;
  final String color;
  final String type;
  final String thickness;

  Cloth({
    required this.name,
    required this.color,
    required this.type,
    required this.thickness,
  });

  factory Cloth.fromJson(Map<String, dynamic> json) {
    return Cloth(
      name: json['name']??'No Name',
      color: json['color'],
      type: json['type'],
      thickness: json['thickness'],
    );
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color,
    'type': type,
    'thickness': thickness,
  };
}
