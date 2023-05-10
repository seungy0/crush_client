import 'package:cloud_firestore/cloud_firestore.dart';

import '../closet/model/cloth_model.dart';

class FirestoreRepository {
  FirestoreRepository({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;
  final FirebaseFirestore _firebaseFirestore;

  /// init Document
  Future<void> initDocument({
    required String document,
    required String name,
    required String email,
  }) async {
    await _firebaseFirestore.collection('Users').doc(document).set({
      'name': name,
      'email': email,
      'age': 26, // TODO: 나이 입력받기
      'sex': 'male', // TODO: 성별 입력받기
    }, SetOptions(merge: true));
  }

  Future<void> addCloth({
    required String uid,
    required Cloth cloth,
  }) async {
    await _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .add({
      'name': cloth.name,
      'color': cloth.color,
      'type': cloth.type,
      'thickness': cloth.thickness,
    });
  }

  /// get Cloth
  Future<Cloth> getCloth({required String uid, required String clothId}) async {
    final cloth = await _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .doc(clothId)
        .get();
    return Cloth.fromJson(cloth.data()!);
  }

  /// getCloth List
  Future<List<Cloth>> getClothList({required String uid}) async {
    final clothList = await _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .get();
    return clothList.docs.map((cloth) => Cloth.fromJson(cloth.data())).toList();
  }

  /// get Cloth Stream
  Stream<List<Cloth>> getClothStream({required String uid}) {
    return _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .snapshots()
        .map((clothList) => clothList.docs
            .map((cloth) => Cloth.fromJson(cloth.data()))
            .toList());
  }

  // get Cloth Stream by type
  Stream<List<Cloth>> getClothStreamByType({
    required String uid,
    required String type,
  }) {
    if (type == '전체') return getClothStream(uid: uid);
    return _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .where('type', isEqualTo: type)
        .snapshots()
        .map((clothList) => clothList.docs
            .map((cloth) => Cloth.fromJson(cloth.data()))
            .toList());
  }
}
