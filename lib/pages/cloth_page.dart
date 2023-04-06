import 'package:crush_client/pages/cloth_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClosetPage extends StatefulWidget {
  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

@override
class _ClosetPageState extends State<ClosetPage> {
  late SharedPreferences prefs;
  List<String>? Closet;

  Future<void> initCloset() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      Closet = prefs.getStringList('Closet');
    });
  }

  void initState() {
    super.initState();
    initCloset();
  }

  @override
  Widget build(BuildContext context) {
    initCloset();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.blueAccent,
        title: const Text(
          '나의 옷장',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(Closet.toString()),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blueAccent,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add),
                  Text('새 옷 등록', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ClothInput()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
