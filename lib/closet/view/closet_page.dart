import 'package:crush_client/closet/model/cloth_model.dart';
import 'package:crush_client/closet/view/recommend_page.dart';
import 'package:crush_client/common/const/colors.dart';
import 'package:crush_client/common/layout/default_layout.dart';
import 'package:crush_client/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClosetPage extends StatefulWidget {
  @override
  State<ClosetPage> createState() => _ClosetPageState();
}

@override
class _ClosetPageState extends State<ClosetPage>
    with SingleTickerProviderStateMixin {
  List<Cloth> clothList = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<List<Cloth>> initCloset() async {
    final clothList = await RepositoryProvider.of<FirestoreRepository>(context)
        .getClothList(
            uid: RepositoryProvider.of<AuthenticationRepository>(context)
                .currentUser);
    return clothList;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '나의 옷장',
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 300,
                  child: TabBar(
                    indicator: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        side: BorderSide(width: 0.5, color: Colors.grey),
                      ),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.fromLTRB(0, -2, 0, 2),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.black,
                    controller: _tabController,
                    tabs: const [
                      Tab(text: '전체'),
                      Tab(text: '상의'),
                      Tab(text: '하의'),
                      Tab(text: '기타'),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildClothesByType('전체'),
                  _buildClothesByType('상의'),
                  _buildClothesByType('하의'),
                  _buildClothesByType('기타'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: PRIMARY_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecommendPage()),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.5, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.paperplane_fill,
                            color: INPUT_BG_COLOR),
                        SizedBox(width: 10),
                        Text(' 옷 추천', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClothDialog(BuildContext context, Cloth cloth) {
    const defaultImage =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrVqTt0O2Wb_AijJ2MgpH162DTExM55h0Wmg&usqp=CAU';
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SafeArea(
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      cloth.name,
                      style: const TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: FutureBuilder<String?>(
                              future:
                                  RepositoryProvider.of<FirestoreRepository>(
                                          context)
                                      .getImageByClothId(
                                uid: RepositoryProvider.of<
                                        AuthenticationRepository>(context)
                                    .currentUser,
                                clothId: cloth.clothId,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  final imageUrl =
                                      snapshot.data ?? defaultImage;
                                  return Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            cloth.type,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            cloth.color,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            cloth.thickness,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              decoration: TextDecoration.none,
                            ),
                          ),
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
                          onPressed: () async {
                            await RepositoryProvider.of<FirestoreRepository>(
                                    context)
                                .removeCloth(
                                    uid: RepositoryProvider.of<
                                            AuthenticationRepository>(context)
                                        .currentUser,
                                    clothId: cloth.clothId);
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                          ),
                          child: const Text(
                            '삭제',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.blue),
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

  /// widget that show Clothes by type
  Widget _buildClothesByType(String type) {
    return Expanded(
      child: StreamBuilder<List<Cloth>>(
        stream: RepositoryProvider.of<FirestoreRepository>(context)
            .getClothStreamByType(
                uid: RepositoryProvider.of<AuthenticationRepository>(context)
                    .currentUser,
                type: type),
        builder: (context, clothList) {
          if (clothList.hasError)
            return Center(child: Text('Error: ${clothList.error}'));
          if (clothList.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          return GridView.builder(
            itemCount: clothList.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) {
              final Cloth cloth = clothList.data![index];
              const defaultImage =
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrVqTt0O2Wb_AijJ2MgpH162DTExM55h0Wmg&usqp=CAU';
              return FutureBuilder<String?>(
                future: RepositoryProvider.of<FirestoreRepository>(context)
                    .getImageByClothId(
                  uid: RepositoryProvider.of<AuthenticationRepository>(context)
                      .currentUser,
                  clothId: cloth.clothId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final imageUrl = snapshot.data ?? '';
                    return GestureDetector(
                      onTap: () {
                        _showClothDialog(context, cloth);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Image.network(
                              imageUrl.isEmpty ? defaultImage : imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(cloth.name),
                                Text(' '),
                                Text(cloth.type),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
