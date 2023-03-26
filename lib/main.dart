import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
              ),
            ),
            Flexible(
              flex: 1,
              child: Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.checkroom_outlined,
                              color: Colors.lightBlueAccent,),
                            Text('코디네이터',
                            style: TextStyle(
                                color: Colors.lightBlueAccent),),
                          ],
                      ),
                    SizedBox(
                        width: 70,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.checkroom_outlined,
                          color: Colors.lightBlueAccent,),
                          Text('나의 옷장',
                            style: TextStyle(
                                color: Colors.lightBlueAccent),)
                        ],
                      ),
                      SizedBox(
                        width: 70,
                        ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.checkroom_outlined,
                            color: Colors.lightBlueAccent,),
                          Text('마이페이지',
                            style: TextStyle(
                                color: Colors.lightBlueAccent),)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}