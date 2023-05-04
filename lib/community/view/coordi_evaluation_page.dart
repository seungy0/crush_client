import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CoordiEvalPage extends StatefulWidget {
  @override
  State<CoordiEvalPage> createState() => _CoordiEvalPageState();
}

@override
class _CoordiEvalPageState extends State<CoordiEvalPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.95,
        width: MediaQuery.of(context).size.width * 0.95,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage('assets/saeroy.png'),
              fit: BoxFit.cover,
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8,),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.65,),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Container(
                  decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: RatingBar(
                      initialRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        half: Icon(
                          Icons.star_half,
                          color: Colors.amber,
                        ),
                        empty: Icon(
                          Icons.star,
                          color: Colors.grey,
                        ),
                      ),
                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      itemSize: 80,
                      glow: false,
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
