import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  final List<String> _widgetItems = [];

  @override
  void initState() {
    super.initState();
    _widgetItems.addAll(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await _showInputDialog();
      },
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.value,
          items: _widgetItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }

  Future<void> _showInputDialog() async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController textController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('원하는 항목을 입력하세요.'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: textController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return '한 글자 이상 입력하세요';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String newValue = textController.text;
                  setState(() {
                    _widgetItems.add(newValue);
                  });
                  widget.onChanged(newValue);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

}
