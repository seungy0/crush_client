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

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코디 평가',
      child: FutureBuilder<List<MyOutfit>>(
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
            return ListView.builder(
              itemCount: outfits.length,
              itemBuilder: (context, index) {
                return CoordiEvalCard(
                  photoUri: outfits[index].photoUrl,
                  onRated: (double rating) async {
                    await _coordiRepository.rateOutfit(
                        coordid: outfits[index].coordiId,
                        raterUserId: userId,
                        stars: rating);
                    setState(() {
                      _curIndex = (_curIndex + 1) % outfits.length;
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
