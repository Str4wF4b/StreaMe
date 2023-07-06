import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';

import '../services/auth_page.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.scale(
      backgroundImage: Image.asset("assets/images/icons/theatre.png"),
      childWidget: Container(
        padding: const EdgeInsets.only(bottom: 130.0),
        child: SizedBox(
          height: 195,
          width: 195,
          child: Image.asset("assets/images/icons/streame.png"),
        ),
      ),
      defaultNextScreen: const AuthPage(),
      duration: const Duration(milliseconds: 3000),
      animationDuration: const Duration(milliseconds: 2800),
    );
  }
}
