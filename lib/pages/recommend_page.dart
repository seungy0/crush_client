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
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemBuilder: (context, index) {
                    var coordi = snapshot.data![index];
                    String clothes = coordi.clothes.join(", ");
                    return Container(
                      child: Column(
                        children: [
                          Text(
                            clothes,
                          ),
                          Text(
                            coordi.explanation,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 20,),
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
