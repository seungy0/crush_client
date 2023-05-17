import 'package:flutter/material.dart';

class MyCoordiCard extends StatelessWidget {
  const MyCoordiCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: 100,
      height: 180,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          'https://image.msscdn.net/mfile_s01/_street_images/53373/street_5d0c6ccb06221.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
