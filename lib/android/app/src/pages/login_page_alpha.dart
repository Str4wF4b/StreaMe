import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../auth/auth_popups.dart';
import 'tabs/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/theme.dart';

class LoginPageAlpha extends StatefulWidget {
  const LoginPageAlpha({Key? key}) : super(key: key);

  final String title = "Login";
  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  State<LoginPageAlpha> createState() => LoginPageAlphaState();
}

class LoginPageAlphaState extends State<LoginPageAlpha> {

  final AuthPopups _loginCon = AuthPopups();

// TODO: Move functionality to controller (separate the code into MVC pattern)
// TODO: Connect with Firebase/Firestore DB (https://github.com/NearHuscarl/flutter_login/issues/162#issuecomment-869908814)

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage("assets/icons/streame.png"),
      theme: LoginTheme( // the theme of the login window
        primaryColor: widget.backgroundColor,
        pageColorLight: Colors.deepOrangeAccent,
        buttonTheme: LoginButtonTheme(
          backgroundColor: Colors.lightBlueAccent.shade700,
        ),
        cardTheme: const CardTheme(
          color: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,

        ),
        titleStyle: const TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),

      navigateBackAfterRecovery: true,

      loginAfterSignUp: false,

      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        //return _loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (var element in signupData.termsOfService) {
            debugPrint(
                ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
          }
        }
        //return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage())),
      /*onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => const DashboardScreen(),
        ));
      },*/
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        //return _recoverPassword(name);
        // Show new password dialog
      },
      //showDebugButtons: true,
    );
  }
}
