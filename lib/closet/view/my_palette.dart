import 'package:flutter/material.dart';

class ColorSelection extends StatefulWidget {
  final ValueChanged<String> onSaved;

  const ColorSelection({Key? key, required this.onSaved}) : super(key: key);

  @override
  ColorSelectionState createState() => ColorSelectionState();
}

class ColorSelectionState extends State<ColorSelection> {
  String selectedColorName = '검정';

  final List<Map<String, dynamic>> colors = [
    {'name': '검정', 'color': Colors.black},
    {'name': '빨강', 'color': Colors.red},
    {'name': '주황', 'color': Colors.orange},
    {'name': '노랑', 'color': Colors.yellow},
    {'name': '초록', 'color': Colors.green},
    {'name': '파랑', 'color': Colors.blue},
    {'name': '남색', 'color': Colors.indigo},
    {'name': '보라', 'color': Colors.purple},
    {'name': '핑크', 'color': Colors.pink},
    {'name': '회색', 'color': Colors.grey},
    {'name': '하양', 'color': Colors.white},
    {'name': '갈색', 'color': Colors.brown},
    {'name': '베이지', 'color': const Color.fromRGBO(243,207,152, 1.0) },
    {'name': '청록', 'color': Colors.cyan},
    {'name': '자주', 'color': Colors.deepPurple},
  ];

  bool showColorPicker = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              showColorPicker = !showColorPicker;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 12.0,
                height: 12.0,
                decoration: BoxDecoration(
                  color: colors
                      .where((color) => color['name'] == selectedColorName)
                      .first['color'],
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(width: 8.0),
              Text(
                selectedColorName,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8.0),
              const Icon(
                Icons.arrow_drop_down,
                size: 24.0,
              ),
            ],
          ),
        ),
        showColorPicker
            ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: colors.map((color) {
                    return SizedBox(
                      width: 65.0,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedColorName = color['name'];
                            widget.onSaved(color['name']);
                            showColorPicker = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 8),
                          backgroundColor: selectedColorName == color['name']
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
                            Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: BoxDecoration(
                                color: color['color'],
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              color['name'],
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
                ),
              )
            : Container(),
      ],
    );
  }
}
