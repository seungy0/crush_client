import 'package:flutter/material.dart';

class MyPalette extends StatefulWidget {
  final ValueChanged<Color> onColorSelected;
  final FormFieldSetter<String>? onSaved;

  MyPalette({required this.onColorSelected, this.onSaved});

  @override
  _MyPaletteState createState() => _MyPaletteState();
}

class _MyPaletteState extends State<MyPalette> {
  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.black,
    Colors.white,
  ];

  final List<String> _colorNames = [
    'Red',
    'Orange',
    'Yellow',
    'Green',
    'Blue',
    'Indigo',
    'Purple',
    'Pink',
    'Brown',
    'Grey',
    'Black',
    'White',
  ];

  Color _selectedColor = Colors.white;

  void _handleColorSelected(Color color) {
    setState(() {
      _selectedColor = color;
    });
    final colorName = _colorNames[_colors.indexOf(color)];
    widget.onColorSelected(color);
    if (widget.onSaved != null) {
      widget.onSaved!(colorName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final color = await showDialog<Color>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('색상 선택'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: EdgeInsets.all(8),
                  children: _colors.map((color) {
                    return GestureDetector(
                      onTap: () {
                        _handleColorSelected(color);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
        if (color != null) {
          _handleColorSelected(color);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.84,
        height: MediaQuery.of(context).size.width * 0.12,
        decoration: BoxDecoration(
          color: _selectedColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String? validator(String? value) {
    if (_selectedColor != null &&
        value == _colorNames[_colors.indexOf(_selectedColor)]) {
      return null;
    } else {
      return '색상을 선택해주세요.';
    }
  }
}
