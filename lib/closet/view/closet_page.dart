import 'dart:convert';

import 'package:crush_client/closet/model/cloth_model.dart';
import 'package:crush_client/closet/view/cloth_upload_page.dart';
import 'package:crush_client/closet/view/recommend_page.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/authentication_repository.dart';
import 'package:crush_client/repositories/firestore_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    clothList = [];
    initCloset();
  }

  Future<void> initCloset() async {
    prefs = await SharedPreferences.getInstance();
    setState(() async {
      closet = prefs.getStringList('Closet');
      if (closet != null) {
        for (int i = 0; i < closet!.length; i++) {
          final Map<String, dynamic> clothJson =
              jsonDecode(closet![i]) as Map<String, dynamic>;
          clothList.add(Cloth.fromJson(clothJson));
        }
      }
      clothList = await RepositoryProvider.of<FirestoreRepository>(context)
          .getClothList(
              uid: RepositoryProvider.of<AuthenticationRepository>(context)
                  .currentUser);
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '나의 옷장',
      // appBar: AppBar(
      //   backgroundColor: Colors.grey,
      //   foregroundColor: Colors.blueAccent,
      //   title: const Text(
      //     '나의 옷장',
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      child: isLoaded
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        children: const [
                          Icon(Icons.add),
                          Text('새 옷 등록',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      onPressed: () async {
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
                  ),
                  //add elevated button which navigates to RecommendPage()
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecommendPage()),
                      );
                    },
                    child: const Text('추천 받기'),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
