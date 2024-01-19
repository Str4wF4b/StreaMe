import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/services/functions/auth_service.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';

import '../widgets/features/login_divider.dart';
import '../widgets/features/login_sign_buttons.dart';
import '../widgets/features/login_text_field.dart';
import '../widgets/features/login_tile.dart';
import 'auth_popups.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  final AuthPopups popup = AuthPopups();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ColorPalette color = ColorPalette();
  Images image = Images();


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrangeAccent,
          color.backgroundColor,
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
                    image.streameIcon,
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
                          imagePath: image.google,
                          iconData: Icons.back_hand,
                          onTap: () => AuthService().signInWithGoogle()),
                      const SizedBox(width: 12),
                      LoginTile(
                          isIcon: false,
                          imagePath: image.apple,
                          iconData: Icons.back_hand,
                          onTap: () => AuthService().signInWithApple()),
                      const SizedBox(width: 12),
                      LoginTile(
                          isIcon: false,
                          imagePath: image.anon,
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
        if (mounted) Navigator.pop(context);
      } on FirebaseAuthException {
        // pop loading circle
        if (mounted) Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
      widget.popup.wrongInputPopup('', context, false);
      //return;
    }
  }
}