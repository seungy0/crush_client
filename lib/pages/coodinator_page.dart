import 'package:flutter/material.dart';

class CoodinatorPage extends StatefulWidget {
  @override
  State<CoodinatorPage> createState() => _CoodinatorPageState();
}

@override
class _CoodinatorPageState extends State<CoodinatorPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('코디네이터'),
      ),
    );
  }
}
