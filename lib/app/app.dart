import 'package:crush_client/repositories/repositories.dart';
import 'package:crush_client/signin/view/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.photosRepository,
    required this.firestoreRepository,
    required this.coordiRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final PhotosRepository photosRepository;
  final FirestoreRepository firestoreRepository;
  final CoordiRepository coordiRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: photosRepository),
        RepositoryProvider.value(value: firestoreRepository),
        RepositoryProvider.value(value: coordiRepository),
      ],
      child: _App(),
    );
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crush',
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => SignInWithVideo(),
      },
    );
  }
}
