import 'package:crush_client/services/api_service.dart';
import 'package:flutter/material.dart';

import '../models/coordination_model.dart';

class RecommendPage extends StatelessWidget {
  RecommendPage({Key? key}) : super(key: key);

  Future<List<CoordinationModel>> coordis = ApiService.getAiCoordination();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: coordis,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index) {
                      var coordi = snapshot.data![index];
                      String clothes = coordi.clothes.join(", ");
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.black.withOpacity(0.4),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            width: 350,
                            height: 500,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  clothes,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  coordi.explanation,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                      width: 40,
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
