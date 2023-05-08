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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.8,
          width: screenWidth * 0.95,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Container(
                height: screenHeight * 0.75,
                width: screenWidth * 0.95,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/musinsa.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(1),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar(
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
                              color: Colors.grey.shade700,
                            ),
                          ),
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemSize: screenHeight * 0.065,
                          glow: false,
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
