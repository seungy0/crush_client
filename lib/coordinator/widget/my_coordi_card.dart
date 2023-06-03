import 'package:crush_client/coordinator/model/my_coordination_model.dart';
import 'package:flutter/material.dart';

class MyCoordiCard extends StatelessWidget {
  final MyOutfit outfit;

  const MyCoordiCard({
    Key? key,
    required this.outfit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 100,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          outfit.photoUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
