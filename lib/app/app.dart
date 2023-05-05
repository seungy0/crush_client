import 'package:crush_client/signin/view/signin_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/authentication_repository.dart';
import '../repositories/photos_repository.dart';
import 'package:crush_client/closet/view/cloth_upload_page.dart';
class App extends StatelessWidget {
  const App({
    required this.authenticationRepository,
    required this.photosRepository,
    super.key,
  });

  final AuthenticationRepository authenticationRepository;
  final PhotosRepository photosRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authenticationRepository),
        RepositoryProvider.value(value: photosRepository),
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
      home: SignInWithVideo(),
    );
  }
}
