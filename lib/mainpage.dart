import 'package:flutter/material.dart';
import 'package:crush_client/pages/coodinator_page.dart';
import 'package:crush_client/pages/cloth_page.dart';
import 'package:crush_client/pages/my_page.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> bottomItems=[
    const BottomNavigationBarItem(
      icon: Icon(Icons.checkroom_outlined),
      label: '코디네이터',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.checkroom_outlined),
      label: '나의 옷장',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.checkroom_outlined),
      label: '마이 페이지',
    ),
  ];
  List<Widget> pages =
  [ CoodinatorPage(),  ClosetPage(),  MyPage(),];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.blue,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: bottomItems,
      ),
      body: pages[_selectedIndex],
    );
  }
}
