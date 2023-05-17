import 'package:crush_client/community/widgets/coordi_evaluation_widget.dart';
import 'package:flutter/material.dart';

class CoordiEvalPage extends StatefulWidget {
  @override
  State<CoordiEvalPage> createState() => _CoordiEvalPageState();
}

@override
class _CoordiEvalPageState extends State<CoordiEvalPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CoordiEvalCard(imageID: 'assets/musinsa.jpg'),
          ],
        ),
      ),
    );
  }
}
