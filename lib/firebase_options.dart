// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBQBIvO9Uj_YsyNp0fnHdlUZPbrTAinBt4',
    appId: '1:829863316737:web:0c5d50183aa2cdddda1f00',
    messagingSenderId: '829863316737',
    projectId: 'crush-649de',
    authDomain: 'crush-649de.firebaseapp.com',
    storageBucket: 'crush-649de.appspot.com',
    measurementId: 'G-H01ZV36W5D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZfcVlurm5fNU7XQVc2Y9MGWaRmdEe5EM',
    appId: '1:829863316737:android:5c7c9c582bba0517da1f00',
    messagingSenderId: '829863316737',
    projectId: 'crush-649de',
    storageBucket: 'crush-649de.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3LcDrsmKrZ6Ikhtnf-kdbPvlLvhtZIJE',
    appId: '1:829863316737:ios:0e676c85a5cb3f4bda1f00',
    messagingSenderId: '829863316737',
    projectId: 'crush-649de',
    storageBucket: 'crush-649de.appspot.com',
    iosClientId: '829863316737-rhdaro0lapuibqu7j7qf1t3ndguatjsf.apps.googleusercontent.com',
    iosBundleId: 'com.zero.crushClient',
  );
}