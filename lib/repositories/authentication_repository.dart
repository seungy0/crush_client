import 'package:crush_client/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../common/view/root_tab.dart';

// TODO Refactor Authentication class
class AuthenticationRepository {
  const AuthenticationRepository({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirestoreRepository firestoreRepository,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestoreRepository = firestoreRepository;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  // 여기까지 AuthRepository
  final FirestoreRepository _firestoreRepository;

  Future<void> initializeFirebase({
    required BuildContext context,
  }) async {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Mainpage(
              user: user,
            ),
          ),
        );
      });
    }
    return;
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _firebaseAuth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await _firebaseAuth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            // ...
          } else if (e.code == 'invalid-credential') {
            // ...
          }
        } catch (e) {
          // ...
        }
      }
    }

    return user;
  }

  Future<void> signOut({required BuildContext context}) async {
    try {
      if (!kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        AuthenticationRepository.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  // method that return currentUser uid
  String get currentUser {
    return _firebaseAuth.currentUser!.uid;
  }

  // method that return currentUser user name
  String get currentUserName {
    return _firebaseAuth.currentUser!.displayName!;
  }

  // method that return currentUser user email
  String get currentUserEmail {
    return _firebaseAuth.currentUser!.email!;
  }

  // method that return currentUser age
  Future<int> get currentUserAge async {
    final userUid = _firebaseAuth.currentUser!.uid;
    final userData = await _firestoreRepository.getUserData(uid: userUid);
    final age = userData.get('age');
    return age;
  }

  // method that return currentUser sex
  Future<String> get currentUserSex async {
    final userUid = _firebaseAuth.currentUser!.uid;
    final userData = await _firestoreRepository.getUserData(uid: userUid);
    final sex = userData.get('sex');
    return sex;
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}
