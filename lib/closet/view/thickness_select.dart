import 'package:flutter/material.dart';

class ThickSelection extends StatefulWidget {
  final ValueChanged<String> onSaved;

  const ThickSelection({Key? key, required this.onSaved}) : super(key: key);

  @override
  _ThickSelectionState createState() => _ThickSelectionState();
}

class _ThickSelectionState extends State<ThickSelection> {
  String selectedThickName = '두꺼움';

  final List<Map<String, dynamic>> Thicks = [
    {'name': '두꺼움'},
    {'name': '보통'},
    {'name': '얇음'},
  ];

  bool showTypePicker = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: Thicks.map((Thick) {
        return SizedBox(
          width: 110,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedThickName = Thick['name'];
                widget.onSaved(Thick['name']);
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              backgroundColor: selectedThickName == Thick['name']
                  ? Colors.grey[200]
                  : Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  color: Colors.grey[50] as Color,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Thick['name'],
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
