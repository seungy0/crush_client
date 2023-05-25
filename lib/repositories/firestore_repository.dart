import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../closet/model/cloth_model.dart';

class FirestoreRepository {
  FirestoreRepository({
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = FirebaseStorage.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  /// init Document
  Future<void> initDocument({
    required String document,
    required String defaultName,
    required String email,
  }) async {
    DocumentSnapshot docSnapshot =
        await _firebaseFirestore.collection('Users').doc(document).get();

    if (!docSnapshot.exists) {
      await _firebaseFirestore.collection('Users').doc(document).set({
        'name': defaultName,
        'email': email,
        'age': 26,
        'sex': 'male',
      }, SetOptions(merge: true));
    }
  }

  /// get User Data
  Future<DocumentSnapshot> getUserData({required String uid}) async {
    final userData =
        await _firebaseFirestore.collection('Users').doc(uid).get();
    return userData;
  }

  /// add Cloth
  Future<void> addCloth({
    required String uid,
    required Cloth cloth,
    required File image,
  }) async {
    final autoId = _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .doc();

    String fileName = image.path.split('/').last;

    Reference storageRef =
        _firebaseStorage.ref().child('clothes').child(uid).child(fileName);

    UploadTask uploadTask = storageRef.putFile(image);

    final TaskSnapshot storageSnapshot =
        await uploadTask.whenComplete(() => null);
    final String downloadURL = await storageSnapshot.ref.getDownloadURL();

    autoId.set({
      'clothId': autoId.id,
      'name': cloth.name,
      'color': cloth.color,
      'type': cloth.type,
      'thickness': cloth.thickness,
      'imageURL': downloadURL,
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

  /// get Cloth Stream by type
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

  /// remove Cloth
  Future<void> removeCloth({
    required String uid,
    required String clothId,
  }) async {
    await _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .doc(clothId)
        .delete();
  }

  Future<String?> getImageByClothId({
    required String uid,
    required String clothId,
  }) async {
    final snapshot = await _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .doc(clothId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data();
      return data?['imageURL'];
    }

    return null;
  }
}
