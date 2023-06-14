import 'package:crush_client/closet/services/api_service.dart';
import 'package:crush_client/closet/widget/custom_dropdown.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import 'cloth_recommend_result.dart';

class ClothRecommendInit extends StatefulWidget {

  const ClothRecommendInit({Key? key}) : super(key: key);

  @override
  State<ClothRecommendInit> createState() => _ClothRecommendInitState();
}

class _ClothRecommendInitState extends State<ClothRecommendInit> {
  late final FirestoreRepository _firestoreRepository;
  late final AuthenticationRepository authRepo;
  late VideoPlayerController _controller;

  Future<void>? future = Future.value(null);
  Future<void>? _loadFuture;

  String userId = '';
  String userName = '';
  int userAge = 25;
  String userSex = '남성';


  String weatherValue = '맑음';
  String occasionValue = '캐주얼';
  String styleValue = '모던한';
  String seasonValue = '봄';

  @override
  void initState() {
    super.initState();
    _firestoreRepository = RepositoryProvider.of<FirestoreRepository>(context);
    userId = context.read<AuthenticationRepository>().currentUser;
    authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
    _loadFuture = _getUserInfo();

    _controller = VideoPlayerController.asset('assets/loading.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _getUserInfo() async {
    userName = await authRepo.currentUserName;
    userAge = await authRepo.currentUserAge;
    userSex = await authRepo.currentUserSex;
    setState(() {
      userSex = userSex == 'male' ? '남성' : '여성';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "AI 옷 추천",
      helpContent: "나의 옷장에 등록된 옷을 기반으로, AI가 옷을 추천해드려요!\n\n"
          "날씨, 상황, 스타일, 계절을 선택하고\n옷 추천 받기를 눌러주세요.\n\n\n"
          "Tip. 각 드롭다운 버튼을 길게 누르면,\n원하는 항목을 직접 입력할 수 있어요.\n\n"
          "Tip. 설정에서 이름, 성별, 나이를 변경할 수 있어요.",
      child: FutureBuilder<void>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Stack(
              children: [
                SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          text: "사용자님의 옷을 확인하고 있어요!\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                offset: Offset(3, 3),
                                color: Colors.black,
                                blurRadius: 50,
                              ),
                            ],
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Stack(
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
                                items: const ['흐림', '맑음', '비', '눈', '무더움', '추움'],
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
                                  '비즈니스',
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
                                  '모던한',
                                  '귀여운',
                                  '온화한',
                                  '경쾌한',
                                  '내츄럴한',
                                  '은은한',
                                  '화려한',
                                  '우아한',
                                  '다이나믹한',
                                  '점잖은',
                                  '고상한',
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
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                "안녕하세요 $userName 님, \n오늘 어울리는 옷을\n추천해드릴게요\n",
                                style: const TextStyle(
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
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 38),
                                Text("$userAge세, $userSex",
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500)),
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
                      onPressed: () {
                        setState(() {
                          future = _fetchAiCoordinationAndNavigate(context);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFB500),
                      ),
                      child: const Text(
                        "옷 추천 받기",
                        style: TextStyle(
                          color: Color(0xFF805A01),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
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
      age: userAge.toString(),
      sex: userSex,
    );

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ClothRecommendResult(recommendations: recommendations),
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
