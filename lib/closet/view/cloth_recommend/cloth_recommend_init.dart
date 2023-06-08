import 'package:crush_client/closet/services/api_service.dart';
import 'package:crush_client/closet/widget/custom_dropdown.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cloth_recommend_result.dart';

class ClothRecommendInit extends StatefulWidget {
  const ClothRecommendInit({Key? key}) : super(key: key);

  @override
  State<ClothRecommendInit> createState() => _ClothRecommendInitState();
}

class _ClothRecommendInitState extends State<ClothRecommendInit> {
  late final FirestoreRepository _firestoreRepository;
  String userId = '';

  String weatherValue = '맑음';
  String occasionValue = '캐주얼';
  String styleValue = '활기찬';
  String seasonValue = '봄';

  @override
  void initState() {
    super.initState();
    _firestoreRepository = RepositoryProvider.of<FirestoreRepository>(context);
    userId = context.read<AuthenticationRepository>().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "AI 옷 추천",
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomDropdown(
                          value: weatherValue,
                          items: const ['흐림', '맑음', '비', '눈', '눈보라', '소나기'],
                          onChanged: (String? newValue) {
                            setState(() {
                              weatherValue = newValue!;
                            });
                          },
                        ),
                        CustomDropdown(
                          value: occasionValue,
                          items: const [
                            '캐주얼',
                            '비즈니스 캐주얼',
                            '세미포멀',
                            '포멀',
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              occasionValue = newValue!;
                            });
                          },
                        ),
                        CustomDropdown(
                          value: styleValue,
                          items: const [
                            '활기찬',
                            '생동감',
                            '어두운',
                            '명랑한',
                            '우아한',
                            '세련된',
                            '편안한'
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              styleValue = newValue!;
                            });
                          },
                        ),
                        CustomDropdown(
                          value: seasonValue,
                          items: const ['봄', '여름', '가을', '겨울'],
                          onChanged: (String? newValue) {
                            setState(() {
                              seasonValue = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "안녕하세요,\n오늘 어울리는 옷을\n추천해드릴게요\n",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 38),
                          Text(weatherValue,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                          renderDot(),
                          Text(occasionValue,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                          renderDot(),
                          Text(styleValue,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                          renderDot(),
                          Text(seasonValue,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/bg_main.png',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.05),
              child: ElevatedButton(
                onPressed: () => _fetchAiCoordinationAndNavigate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                ),
                child: const Text(
                  "옷 추천 받기",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchAiCoordinationAndNavigate(BuildContext context) async {
    final cloths = await _firestoreRepository.getClothList(uid: userId);
    final recommendations = await ApiService.getAiCoordination(
      cloths: cloths,
      weather: weatherValue,
      occasion: occasionValue,
      style: styleValue,
      season: seasonValue,
    );

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClothRecommendResult(
                recommendations: recommendations
            ),
      ),
    );
  }

  Widget renderDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Text(
        '·',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
