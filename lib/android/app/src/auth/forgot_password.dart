import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/services/functions/auth_popups.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import '../widgets/features/login_text_field.dart';
import '../widgets/features/login_sign_buttons.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Utils:
  ColorPalette color = ColorPalette();
  Images image = Images();

  // Instances:
  final _emailController = TextEditingController();
  final AuthPopups _popup = AuthPopups();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

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
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // Logo on top:
                    Image.asset(
                      image.streameIcon,
                      width: 200,
                    ),
                    const SizedBox(height: 90),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                          "Enter your Email here and reset your password",
                          style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 15),
                    // TextField to enter email to get "Forgot Password" Link
                    LoginTextField(
                        inputController: _emailController,
                        obscureText: false,
                        hintText: "Sending password link to this Email",
                        prefixIcon: Icons.mail_outline),
                    const SizedBox(
                      height: 40,
                    ),
                    SignButton(onTap: resetPassword, text: "Reset Password"),
                    const SizedBox(
                      height: 20,
                    ),
                    // Go Back Button:
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.symmetric(horizontal: 100.0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.blueAccent, width: 2.0),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              Text("Back",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0)),
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// A function sending an email to the entered email address if clicked on the "Reset Password" Button
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      if (mounted) {
        _popup.handleResetMailPopup(context, true,
            _emailController); // if email is correct, show popup reset message
      }
    } on FirebaseAuthException {
      if (mounted) {
        _popup.handleResetMailPopup(context, false,
            _emailController); // if email is wrong, show popup email error message
      }
    }
  }
}
