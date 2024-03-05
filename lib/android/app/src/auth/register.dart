import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/models/user_model.dart';
import '../services/functions/user_data.dart';
import 'package:stream_me/android/app/src/utils/constants_and_values.dart';
import 'package:stream_me/android/app/src/services/functions/auth_service.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';

import '../widgets/features/login_divider.dart';
import '../widgets/features/login_sign_buttons.dart';
import '../widgets/features/login_text_field.dart';
import '../widgets/features/login_tile.dart';

import '../services/functions/auth_popups.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthPopups _popup = AuthPopups();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();
  final Images _image = Images();
  final UserData _userData = UserData();

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
                  const SizedBox(height: 30),
                  Image.asset(
                    // Logo:
                    _image.streameIcon,
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
                              height: _cav.textHeight,
                              fontSize: 18.0)),
                    ),
                  ),
                  const SizedBox(height: 11),
                  LoginTextField(
                      // Email text field:
                      inputController: _emailController,
                      obscureText: false,
                      hintText: "Email",
                      prefixIcon: Icons.person /*, const Icon(Icons.abc)*/),
                  const SizedBox(height: 10),
                  LoginTextField(
                      // Password text field:
                      inputController: _passwordController,
                      obscureText: true,
                      hintText: "Password",
                      prefixIcon:
                          Icons.lock /*, const Icon(Icons.remove_red_eye)*/),
                  const SizedBox(height: 10),
                  LoginTextField(
                      // Confirm password text field:
                      inputController: _confirmPasswordController,
                      obscureText: true,
                      hintText: "Confirm Password",
                      prefixIcon: Icons
                          .lock_reset_rounded /*, const Icon(Icons.remove_red_eye)*/),
                  const SizedBox(height: 30),
                  SignButton(onTap: registerUser, text: "Register"),
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
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: Colors.white, height: _cav.textHeight),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text("Sign in here",
                            style: TextStyle(
                                color: Colors.lightBlue,
                                height: _cav.textHeight)),
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
    //First check if password equals confirmed password:
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        //Register user with email and password:
        await _userData.registerUser(
            _emailController.text, _passwordController.text);

        //Show sign up dialog and save user's register data to the Firestore DB:
        if (mounted) await _popup.signUpDialog(context);
        await handleUserData();

      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          if (mounted) _popup.wrongInputPopup(e.code, context, false);
        } else if (e.code == "email-already-in-use") {
          if (mounted) _popup.wrongInputPopup(e.code, context, false);
        }
      }
    } else {
      if (mounted) {
        _popup.wrongInputPopup("not-matching-passwords", context, false);
      }
    }
  }

  Future<void> handleUserData() async {
    String userEmail = _emailController.text;
    String firstUsername = userEmail.substring(0, userEmail.indexOf("@")); //First username is the mail name till @-character
    String firstFullName = ""; //empty
    final user = UserModel(
        username: firstUsername,
        fullName: firstFullName,
        email: userEmail,
        password: _passwordController.text);
    await _userData.createUserSetup(user);
  }
}
