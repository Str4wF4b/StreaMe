import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import 'package:stream_me/android/app/src/widgets/features/login_divider.dart';
import '../services/functions/auth_popups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/features/login_sign_buttons.dart';
import '../widgets/features/login_text_field.dart';
import '../widgets/features/login_tile.dart';
import '../services/functions/auth_service.dart';
import '../services/functions/user_data.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  final String title = "Login";

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final ColorPalette _color = ColorPalette();
  final Images _image = Images();
  final UserData _userData = UserData();
  final AuthPopups _popup = AuthPopups();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //FirebaseFirestore get firestore => FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrangeAccent,
          _color.backgroundColor,
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
                    _image.streameIcon,
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  LoginTextField(
                      // Email text field:
                      inputController: _emailController,
                      obscureText: false,
                      hintText: "Email",
                      prefixIcon: Icons.person),
                  const SizedBox(height: 13),
                  LoginTextField(
                      // Password text field:
                      inputController: _passwordController,
                      obscureText: true,
                      hintText: "Password",
                      prefixIcon: Icons.lock),
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
                  LoginDivider(),
                  const SizedBox(height: 55),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoginTile(
                          isIcon: false,
                          imagePath: _image.google,
                          iconData: Icons.back_hand,
                          onTap: () => AuthService().signInWithGoogle()),
                      const SizedBox(width: 12),
                      LoginTile(
                          isIcon: false,
                          imagePath: _image.apple,
                          iconData: Icons.back_hand,
                          onTap: () => AuthService().signInWithApple()),
                      const SizedBox(width: 12),
                      LoginTile(
                          isIcon: false,
                          imagePath: _image.anon,
                          iconData: Icons.back_hand,
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
          child: CircularProgressIndicator(color: Colors.blueAccent),
        );
      },
    );

    // sign in try
    try {
      await _userData.loginUser(_emailController.text, _passwordController.text);
      // pop loading circle
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      if (mounted) Navigator.pop(context);

      // if email is wrong:
      if (e.code == "user-not-found") {
        if (mounted) _popup.wrongInputPopup("Email", context, true);
        // if password is wrong:
      } else if (e.code == "wrong-password") {
        if (mounted) _popup.wrongInputPopup("Password", context, true);
      } else if (e.code == "user-not-found" && e.code == "wrong-password") {
        //wrongEmailPopup();
      }
    }

    //if(mounted) Navigator.pop(context);
  }
}