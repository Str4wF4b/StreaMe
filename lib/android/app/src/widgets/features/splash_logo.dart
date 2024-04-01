import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../utils/images.dart';
import '../../auth/auth_main.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  final Images _image = Images();
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _player.setAsset("assets/sounds/intro.mp3");
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: _image.introBasic,
      gifWidth: 390.0,
      gifHeight: 390.0,
      nextScreen: const AuthPage(),
      onInit: playSound,
      duration: const Duration(milliseconds: 2500),
      backgroundColor: Colors.black,
    );
  }

  void playSound() {
    _player.seek(const Duration(seconds: 3));
    _player.setVolume(0.2);
    _player.play();
  }
}
