import 'package:crush_client/pages/cloth_input.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:crush_client/pages/objects/cloth_object.dart';

class ClosetPage extends StatefulWidget {
  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

@override
class _ClosetPageState extends State<ClosetPage> {
  late SharedPreferences prefs;
  List<String>? closet;
  List<Cloth> clothList = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    clothList= [];
    initCloset();
  }

  Future<void> initCloset() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      closet = prefs.getStringList('Closet');
      if (closet != null) {
        for (int i = 0; i < closet!.length; i++) {
          final Map<String, dynamic> clothJson =
              jsonDecode(closet![i]) as Map<String, dynamic>;
          clothList.add(Cloth.fromJson(clothJson));
        }
      }
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        foregroundColor: Colors.blueAccent,
        title: const Text(
          '나의 옷장',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoaded
          ? Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: clothList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(clothList[index].name),
                    subtitle: Text(clothList[index].type),
                  );
                },
              ),
            ),
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
                  Text('새 옷 등록',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              onPressed: () async{
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClothInput()),
                );
                setState(() {
                  clothList = [];
                  initCloset();
                });
              },
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}