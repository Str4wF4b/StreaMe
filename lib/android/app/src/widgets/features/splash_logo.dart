import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/images.dart';

import '../../auth/auth_main.dart';

class SplashLogo extends StatelessWidget {
  SplashLogo({Key? key}) : super(key: key);

  Images image = Images();

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      backgroundImage: Image.asset(image.iconBackground),
      childWidget: Container(
        padding: const EdgeInsets.only(bottom: 130.0),
        child: SizedBox(
          height: 195,
          width: 195,
          child: Image.asset(image.streameIcon),
        ),
      ),
      defaultNextScreen: const AuthPage(),
      duration: const Duration(milliseconds: 3000),
      animationDuration: const Duration(milliseconds: 2800),
    );
  }
}
