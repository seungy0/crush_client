import 'package:crush_client/closet/view/closet_page.dart';
import 'package:crush_client/closet/view/cloth_upload/cloth_upload_page.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/community/view/coordi_eval_page.dart';
import 'package:crush_client/repositories/authentication_repository.dart';
import 'package:crush_client/repositories/firestore_repository.dart';
import 'package:crush_client/user/view/my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../coordinator/view/my_coodinator_page.dart';
import '../../coordinator/view/my_coordi_upload.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key, required User user}) : super(key: key);

  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int index = 0;

  @override
  void initState() {
    super.initState();
    initUserDocument(); // FirebaseRepository의 initDocument 메서드 호출

    controller = TabController(length: 5, vsync: this);
    controller.addListener(tabListener);
  }

  Future<void> initUserDocument() async {
    final authRepo = RepositoryProvider.of<AuthenticationRepository>(context);
    final firestoreRepo = RepositoryProvider.of<FirestoreRepository>(context);

    String uid = authRepo.currentUser;
    String defaultName = await authRepo.currentUserName;
    String email = authRepo.currentUserEmail;

    await firestoreRepo.initDocument(
      document: uid,
      defaultName: defaultName,
      email: email,
    );
  }

  @override
  void dispose() {
    // 메모리 누수 방지 로직
    controller.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    //탭이 바뀔때마다 호출되는 함수
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: index,
          onTap: (int index) {
            controller.animateTo(index);
          }),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(), //스크롤 막기
        controller: controller,
        children: [
          //1. 나의 옷장 & 옷추천 2. 나의 코디 +:[옷, 코디] 추가 4. 코디 평가 5. 설정
          ClosetPage(),
          MyCoordiPage(),
          Container(),
          CoordiEvalPage(),
          MyPage(authRepo: context.read<AuthenticationRepository>()),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          selectedItemColor: PRIMARY_COLOR,
          unselectedItemColor: BODY_TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.checkroom_outlined),
              label: '옷장',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outlined),
              label: '코디',
            ),
            BottomNavigationBarItem(
              label: '',
              icon: SizedBox.shrink(), //아이콘 없애기
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.reviews_outlined),
              label: '평가',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              label: '설정',
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: MediaQuery.of(context).size.width / 2 - 32, //32: FAB의 크기
          child: Transform.scale(
            scale: 1.2,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _buildAddOptionsDialog(context),
                );
              },
              backgroundColor: PRIMARY_COLOR,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddOptionsDialog(BuildContext context) {
    return SimpleDialog(
      title: const Text('추가하기'),
      titleTextStyle: const TextStyle(
        color: PRIMARY_COLOR,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClothInput()),
            );
          },
          child: const Text('나의 옷장'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyCoordiUpload()),
            );
          },
          child: const Text('나의 코디 & 패션'),
        ),
      ],
    );
  }
}
