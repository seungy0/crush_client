import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/community/widgets/coordi_eval_card.dart';
import 'package:crush_client/coordinator/model/my_coordination_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoordiEvalPage extends StatefulWidget {
  const CoordiEvalPage({Key? key}) : super(key: key);

  @override
  State<CoordiEvalPage> createState() => _CoordiEvalPageState();
}

class _CoordiEvalPageState extends State<CoordiEvalPage> {
  late final CoordiRepository _coordiRepository;
  late Future<List<MyOutfit>> _outfitList;
  int _curIndex = 0;
  bool _finished = false;

  String userId = '';

  @override
  void initState() {
    super.initState();
    _coordiRepository = RepositoryProvider.of<CoordiRepository>(context);
    userId =
        RepositoryProvider.of<AuthenticationRepository>(context).currentUser;
    _outfitList =
        _coordiRepository.getOtherCoordiList(userId: userId, count: 5);
  }

  // image prefetching
  List<Future<void>> prefetchImages(List<MyOutfit> outfits) {
    List<Future<void>> futures = [];
    for (MyOutfit outfit in outfits) {
      futures.add(precacheImage(NetworkImage(outfit.photoUrl), context));
    }
    return futures;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코디 평가',
      child: _finished
          ? Container(
              height: MediaQuery.of(context).size.height * 0.5,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '평가가 완료되었습니다.\n',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '😁🥰',
                    style: TextStyle(fontSize: 45),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : FutureBuilder<List<MyOutfit>>(
              future: _outfitList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator());
                }

                List<MyOutfit>? outfits = snapshot.data;
                if (outfits == null || outfits.isEmpty) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    child: const Text('평가할 코디가 없습니다.'),
                  );
                } else {
                  //Prefetch images
                  Future.wait(prefetchImages(outfits));

                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Image.asset(
                                'assets/logo_circle.png',
                                fit: BoxFit.fitWidth,
                                width: MediaQuery.of(context).size.width * 0.7,
                                height: MediaQuery.of(context).size.height * 0.7,
                                alignment: Alignment.center,
                            ),
                            Text(
                              '${_curIndex + 1} 번째 평가중 / 총 ${outfits.length}개',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...outfits.asMap().entries.map((e) {
                        int index = e.key;
                        MyOutfit outfit = e.value;
                        return Visibility(
                          visible: index == _curIndex,
                          child: CoordiEvalCard(
                            photoUri: outfit.photoUrl,
                            title: outfit.title,
                            onRated: (double rating, bool isUserRated) async {
                              if (isUserRated) {
                                await _coordiRepository.rateOutfit(
                                    coordid: outfit.coordiId,
                                    raterUserId: userId,
                                    stars: rating
                                );
                              }
                              setState(() {
                                _curIndex += 1;
                                if (_curIndex >= outfits.length) {
                                  _finished = true;
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }
              },
            ),
    );
  }
}
