import 'package:flutter/material.dart';

class PeoplesPage extends StatefulWidget {
  @override
  State<PeoplesPage> createState() => _PeoplesPageState();
}

@override
class _PeoplesPageState extends State<PeoplesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('다른 사람 코디'),
      ),
    );
  }
}
