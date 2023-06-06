import 'package:crush_client/closet/services/api_service.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

import '../../model/recommend_model.dart';

class ClothRecommendResult extends StatelessWidget {
  final List<RecommendModel> recommendations;

  const ClothRecommendResult({Key? key, required this.recommendations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "옷 추천 결과",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recommendations.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                var item = recommendations[index];
                String clothes = item.clothes.join(", ");
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: PRIMARY_COLOR.withOpacity(0.25),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "👕결과👖",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            clothes,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            item.explanation,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 40),
            ),
          ),
        ],
      ),
    );
  }
}
