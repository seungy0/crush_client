import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadBox extends StatefulWidget {
  @override
  _ImageUploadBoxState createState() => _ImageUploadBoxState();
}

class _ImageUploadBoxState extends State<ImageUploadBox> {
  File? _imageFile;

  final String _defaultImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrVqTt0O2Wb_AijJ2MgpH162DTExM55h0Wmg&usqp=CAU';

  Future _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: _imageFile == null
            ? Image.network(_defaultImageUrl)
            : Image.file(_imageFile!),
      ),
    );
  }
}
