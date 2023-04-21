import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:crush_client/repositories/photos_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app/app.dart';
import 'app/app_bloc_observer.dart';
import 'repositories/authentication_repository.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authenticationRepository = AuthenticationRepository(
    firebaseAuth: FirebaseAuth.instance,
    googleSignIn: GoogleSignIn(),
  );
  final photosRepository = PhotosRepository(
    firebaseStorage: FirebaseStorage.instance,
  );

  runZonedGuarded(
    () => runApp(
      App(
        authenticationRepository: authenticationRepository,
        photosRepository: photosRepository,
      ),
    ),
    (error, stackTrace) {
      print(error);
      print(stackTrace);
    },
  );
}
