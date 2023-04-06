import 'package:crush_client/pages/cloth_page.dart';
import 'package:crush_client/pages/coodinator_page.dart';
import 'package:crush_client/pages/peoples_page.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  @override
  _MainpageState createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  List<Widget> pages = [
    CoodinatorPage(),
    ClosetPage(),
    PeoplesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: TabBarView(children: [
          CoodinatorPage(),
          ClosetPage(),
          PeoplesPage(),
        ]),
        bottomNavigationBar: Container(
          height: 60,
          color: Colors.grey,
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.checkroom_outlined),
                text: '나의 코디',
              ),
              Tab(
                icon: Icon(Icons.checkroom_outlined),
                text: '나의 옷장',
              ),
              Tab(
                icon: Icon(Icons.checkroom_outlined),
                text: '남들의 코디',
              ),
            ],
            padding: EdgeInsets.only(bottom: 1, top: 1),
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.lightBlueAccent,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
