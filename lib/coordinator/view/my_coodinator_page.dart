import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/my_coordination_model.dart';
import '../widget/my_coordi_card.dart';

class MyCoordiPage extends StatefulWidget {
  const MyCoordiPage({Key? key}) : super(key: key);

  @override
  State<MyCoordiPage> createState() => _MyCoordiPageState();
}

class _MyCoordiPageState extends State<MyCoordiPage> {
  late final CoordiRepository _coordiRepository;
  late Future<List<MyOutfit>> _myOutfitList;

  @override
  void initState() {
    super.initState();
    _coordiRepository = RepositoryProvider.of<CoordiRepository>(context);
    String userId = RepositoryProvider.of<AuthenticationRepository>(context).currentUser;
    _myOutfitList = _coordiRepository.getMyCoordiList(userId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '나의 코디',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              FutureBuilder<List<MyOutfit>>(
                future: _myOutfitList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                        child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SliverFillRemaining(child: Text('아직 등록된 코디가 없습니다.'));
                  }

                  List<MyOutfit> outfits = snapshot.data!;
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 3 / 4,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _showCoordiDialog(context, outfits[index]);
                          },
                          child: MyCoordiCard(
                            outfit: outfits[index],
                          ),
                        );
                      },
                      childCount: outfits.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCoordiDialog(BuildContext context, MyOutfit outfit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SafeArea(
          top: true,
          bottom: false, //아래쪽에는 안전영역 해제

          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFE5E5E5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          '뒤로',
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25.0),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                // Base image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    outfit.photoUrl,
                                    height: 600.0,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      'assets/black_shadow_overlay.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20.0,
                                  left: 20.0,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        outfit.title,
                                        style: const TextStyle(
                                          fontSize: 35.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        '별점 : ${outfit.ratings.isNotEmpty ? outfit.ratings.map((e) => e.stars).reduce((a, b) => a + b) / outfit.ratings.length : '평가없음'} / 5',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try{
                              await _coordiRepository
                                  .removeCoordi(outfit.coordiId, outfit.ownerId, outfit.photoUrl);
                              Navigator.pop(context);

                              setState(() {
                                _myOutfitList = _coordiRepository.getMyCoordiList(outfit.ownerId);
                              });
                            } catch (e) {
                              print(e);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                          child: const Text(
                            '삭제',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 30.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
