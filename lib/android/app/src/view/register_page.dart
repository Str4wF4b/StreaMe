import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/services/auth_service.dart';

import '../components/login_divider.dart';
import '../components/login_sign-buttons.dart';
import '../components/login_text-field.dart';
import '../components/login_tile.dart';
import '../controller/login_controller.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

  final LoginController _loginCon = LoginController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                  const SizedBox(height: 30),
                  Image.asset(
                    //logo
                    "assets/images/streame.png",
                    width: 170,
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.only(left: 44.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Let's create an account:",
                          style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0)),
                    ),
                  ),
                  const SizedBox(height: 11),
                  LoginTextField(
                      // username textfield
                      inputController: widget.emailController,
                      obscureText: false,
                      hintText: "Email",
                      prefixIcon: Icons.person /*, const Icon(Icons.abc)*/),
                  const SizedBox(height: 10),
                  LoginTextField(
                      // password textfield
                      inputController: widget.passwordController,
                      obscureText: true,
                      hintText: "Password",
                      prefixIcon: Icons
                          .lock /*, const Icon(Icons.remove_red_eye)*/),
                  const SizedBox(height: 10),
                  LoginTextField(
                      // confirm password textfield
                      inputController: widget.confirmPasswordController,
                      obscureText: true,
                      hintText: "Confirm Password",
                      prefixIcon: Icons
                          .lock_reset_rounded /*, const Icon(Icons.remove_red_eye)*/),
                  const SizedBox(height: 30),
                  SignButton(onTap: registerUser, text: "Register"),
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
                          onTap: () => AuthService().signInAnon()),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text("Sign in here",
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

  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // check if password equals confirmed password
    if (widget.passwordController.text ==
        widget.confirmPasswordController.text) {
      // register try
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: widget.emailController.text,
            password: widget.passwordController.text);
        // pop loading circle
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // pop loading circle
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      widget._loginCon.wrongInputPopup("", context, false);
      //return;
    }
  }
}