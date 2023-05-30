import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../coordinator/model/my_coordination_model.dart';

class CoordiRepository {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  CoordiRepository({
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage,
        _firebaseFirestore = firebaseFirestore;

  /// upload My Coordi to Firebase and Storage
  Future<void> uploadCoordi({
    required String uid,
    required String title,
    required File image,
    required String description,
  }) async {
    try {
      String fileName = image.path.split('/').last;

      // 파일 위치에 대한 참조 생성
      Reference storageRef =
      _firebaseStorage.ref().child('coordi').child(uid).child(fileName);

      UploadTask uploadTask = storageRef.putFile(image); // 업로드 시작

      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();

      DocumentReference<Map<String, dynamic>> docRef = await _firebaseFirestore.collection('MyOutfits').add({
        'title': title,
        'ownerId': uid,
        'photoUrl': url,
        'description': description,
      });

      await _firebaseFirestore.collection('MyOutfits').doc(docRef.id).update({
        'coordiId': docRef.id,
      });

    } catch (e) {
      print(e);
      throw 'Error occurred while uploading to Firebase';
    }
  }

  /// Get all Coordi for a specific user
  Future<List<MyOutfit>> getMyCoordiList(String userId) async {
    try {
      QuerySnapshot coordiSnapshots = await _firebaseFirestore
          .collection('MyOutfits')
          .where('ownerId', isEqualTo: userId)
          .get();
      return coordiSnapshots.docs.map((coordi) =>
          MyOutfit.fromJson(coordi.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print(e);
      throw 'Error occurred while fetching My Coordi List from Firebase';
    }
  }

  /// Remove Coordi
  Future<void> removeCoordi(String coordiId, String ownerId, String imageUrl) async {
    try {
      await _firebaseFirestore.collection('MyOutfits').doc(coordiId).delete();
      // Get reference of the image file
      Reference ref = _firebaseStorage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print(e);
      throw 'Error occurred while deleting Coordi';
    }
  }

}
