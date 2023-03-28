import 'package:flutter/material.dart';

class ClosetPage extends StatefulWidget{
  @override
  State<ClosetPage> createState() => _ClosetPageState();
}


@override
class _ClosetPageState extends State<ClosetPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('나의 옷장'),
      ),
    );
  }
}