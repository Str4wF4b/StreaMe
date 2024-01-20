import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../utils/images.dart';
import '../../auth/auth_main.dart';

class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> {
  Images image = Images();
  ColorPalette color = ColorPalette();
  AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player.setAsset("assets/sounds/intro.mp3");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.gif(
      gifPath: image.introBasic,
      gifWidth: 390.0,
      gifHeight: 390.0,
      nextScreen: const AuthPage(),
      onInit: playSound,
      duration: const Duration(milliseconds: 2500),
      backgroundColor: Colors.black,
    );
  }

  void playSound() {
    player.seek(const Duration(seconds: 3));
    player.play();
  }
}
