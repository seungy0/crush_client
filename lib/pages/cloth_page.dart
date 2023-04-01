import 'package:flutter/material.dart';
import 'package:crush_client/pages/cloth_input.dart';

class ClosetPage extends StatefulWidget{
  @override
  State<ClosetPage> createState() => _ClosetPageState();
}


@override
class _ClosetPageState extends State<ClosetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.blueAccent,
        title: Text('나의 옷장',style: TextStyle(fontWeight:FontWeight.bold),),
      ),
      body: Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.blueAccent,
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add),
                Text('새 옷 등록',style: TextStyle(fontWeight:FontWeight.bold)),
              ],
            ),
            onPressed: () {
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => ClothInput()));
          },
        ),
      ),
    );
  }
}