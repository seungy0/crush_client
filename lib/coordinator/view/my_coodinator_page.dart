import 'package:crush_client/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

import '../widget/my_coordi_card.dart';

class MyCoordiPage extends StatelessWidget {
  const MyCoordiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '나의 코디',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: CustomScrollView(
            slivers: [
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 3 / 4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _showCoordiDialog(context, index);
                      },
                      child: MyCoordiCard(),
                    );
                  },
                  childCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCoordiDialog(BuildContext context, int index) {
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
                                    'https://image.msscdn.net/mfile_s01/_street_images/53373/street_5d0c6ccb06221.jpg',
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
                                    children: const [
                                      Text(
                                        'MUSINSA\'S PICK',
                                        style: TextStyle(
                                          fontSize: 35.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        '별점 : 4.5 / 5',
                                        style: TextStyle(
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
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Do sth
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
