import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoordiRepository {
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firebaseFirestore;

  CoordiRepository({
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firebaseFirestore,
  })  : _firebaseStorage = firebaseStorage,
        _firebaseFirestore = firebaseFirestore;

  Future<void> uploadCoordi({
    required String uid,
    required String title,
    required File image,
    required String description,
  }) async {
    try {
      // 파일 위치에 대한 참조 생성, !!수정필요
      Reference ref =
      _firebaseStorage.ref().child('coordi').child(uid).child(title);

      // 참조 위치에 파일 업로드
      UploadTask uploadTask = ref.putFile(image);

      // 이미지 업로드가 완료되면, 다운로드 URL을 가져옴
      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();

      // MyOutfits 컬렉션에 문서 생성
      await _firebaseFirestore.collection('MyOutfits').add({
        'ownerId': uid,
        'photoUrl': url,
        'description': description,
      });
    } catch (e) {
      print(e);
      throw 'Error occurred while uploading to Firebase';
    }
  }
}
