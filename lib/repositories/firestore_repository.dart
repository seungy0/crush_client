import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../closet/model/cloth_model.dart';

class FirestoreRepository {
  FirestoreRepository({
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseFirestore = firebaseFirestore,
        _firebaseStorage = firebase_storage.FirebaseStorage.instance;

  final FirebaseFirestore _firebaseFirestore;
  final firebase_storage.FirebaseStorage _firebaseStorage;

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
    required File image,
  }) async {
    final autoId = _firebaseFirestore
        .collection('Users')
        .doc(uid)
        .collection('clothes')
        .doc();

    final firebase_storage.Reference storageRef =
    _firebaseStorage.ref().child('clothes').child(uid).child(cloth.name);
    final firebase_storage.UploadTask uploadTask =
    storageRef.putFile(image);
    final firebase_storage.TaskSnapshot storageSnapshot =
    await uploadTask.whenComplete(() => null);
    final String downloadURL = await storageSnapshot.ref.getDownloadURL();

    autoId.set({
      'clothId': autoId.id,
      'name': cloth.name,
      'color': cloth.color,
      'type': cloth.type,
      'thickness': cloth.thickness,
      'image': downloadURL,
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
}
