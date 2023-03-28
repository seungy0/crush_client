import 'package:flutter/material.dart';

class MyPage extends StatefulWidget{
  @override
  State<MyPage> createState() => _MyPageState();
}


@override
class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('마이 페이지'),
      ),
    );
  }
}