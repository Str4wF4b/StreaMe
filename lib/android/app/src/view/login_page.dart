import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:stream_me/android/app/src/components/login_divider.dart';
import 'package:stream_me/android/app/src/components/login_tile.dart';
import '../components/login_sign-buttons.dart';
import '../components/login_text-field.dart';
import '../controller/login_controller.dart';
import '../services/auth_service.dart';
import 'forgotpassword_page.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/theme.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  LoginPage({super.key, required this.onTap});

  final String title = "Login";
  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  final LoginController _loginCon = LoginController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
// TODO: Move functionality to controller (separate the code into MVC pattern)
// TODO: Connect with Firebase/Firestore DB (https://github.com/NearHuscarl/flutter_login/issues/162#issuecomment-869908814)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrangeAccent,
          widget.backgroundColor,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    //logo
                    "assets/images/streame.png",
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  LoginTextField(
                      // username textfield
                      inputController: widget.emailController,
                      obscureText: false,
                      hintText: "Email",
                      prefixIcon: Icons.person /*, const Icon(Icons.abc)*/),
                  const SizedBox(height: 13),
                  LoginTextField(
                      // password textfield
                      inputController: widget.passwordController,
                      obscureText: true,
                      hintText: "Password",
                      prefixIcon:
                          Icons.lock /*, const Icon(Icons.remove_red_eye)*/),
                  const SizedBox(height: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgotPasswordPage();
                          },
                        ),
                      );
                    },
                    child: const Text("Forgot Password?",
                        style: TextStyle(color: Colors.white60)),
                  ),
                  const SizedBox(height: 30),
                  SignButton(onTap: signUserIn, text: "Sign In"),
                  const SizedBox(height: 55),
                  const LoginDivider(),
                  const SizedBox(height: 55),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginTile(
                          isIcon: false,
                          imagePath: "assets/images/google.png",
                          iconData: Icons.back_hand,
                          onTap: () => AuthService().signInWithGoogle()),
                      const SizedBox(width: 12),
                      LoginTile(
                          isIcon: false,
                          imagePath: "assets/images/apple.png",
                          iconData: Icons.back_hand,
                          onTap: () => AuthService().signInWithApple()),
                      const SizedBox(width: 12),
                      LoginTile(
                          isIcon: false,
                          imagePath: "assets/images/anonymous.png",
                          iconData: Icons.back_hand,
                          //TODO: show restricted anonymous site
                          onTap: () => AuthService().signInAnon()),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member yet?",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Register now",
                            style: TextStyle(color: Colors.lightBlue)),
                      )
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
      //)
    );
  }

  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // sign in try
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.emailController.text,
          password: widget.passwordController.text);
      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);

      // if email is wrong:
      if (e.code == "user-not-found") {
        widget._loginCon.wrongInputPopup("Email", context, true);
        //widget.emailController.text = "Wrong Email.";
        // if password is wrong:
      } else if (e.code == "wrong-password") {
        widget._loginCon.wrongInputPopup("Password", context, true);
      } else if (e.code == "user-not-found" && e.code == "wrong-password") {
        //wrongEmailPopup();
      }
    }

    // Navigator.pop(context);
  }
}
