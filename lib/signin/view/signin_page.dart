import 'package:crush_client/repositories/repositories.dart';
import 'package:crush_client/signin/signin.dart';
import 'package:crush_client/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class SignInWithVideo extends StatefulWidget {
  const SignInWithVideo({super.key});

  @override
  _SignInWithVideoState createState() => _SignInWithVideoState();
}

class _SignInWithVideoState extends State<SignInWithVideo> {
  late VideoPlayerController _controller;
  // TODO: web bug fix
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/sample_video.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xffb55e28),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xffffd544)),
      ),
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: _controller.value.size?.width ?? 0,
                    height: _controller.value.size?.height ?? 0,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
              const SignInScreen()
            ],
          ),
        ),
      ),
    );
  }

  // Override the dispose() method to cleanup the video controller.
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(),
        Center(
          child: FutureBuilder(
            future: RepositoryProvider.of<AuthenticationRepository>(context)
                .initializeFirebase(context: context),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error initializing Firebase');
              } else if (snapshot.connectionState == ConnectionState.done) {
                return const GoogleSignInButton();
              }
              return const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  CustomColors.firebaseOrange,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
