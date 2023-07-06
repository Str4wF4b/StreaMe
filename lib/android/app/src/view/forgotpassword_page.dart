import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/components/login_sign-buttons.dart';

import '../components/login_text-field.dart';
import '../controller/forgotpassword_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();

  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);
  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

  final ForgotPasswordController _forgotPwCon = ForgotPasswordController();
  final _emailController = TextEditingController();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  void dispose() {
    widget._emailController.dispose();
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
          widget.backgroundColor,
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
                    Image.asset(
                      //logo
                      "assets/images/icons/streame.png",
                      width: 200,
                    ),
                    const SizedBox(height: 90),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text("Enter your Email here and reset your password",
                          style: TextStyle(
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                          textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 15),
                    LoginTextField(
                      inputController: widget._emailController,
                      obscureText: false,
                      hintText: "Sending password link to this Email",
                      prefixIcon: Icons.mail_outline
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SignButton(onTap: resetPassword, text: "Reset Password"),
                    const SizedBox(
                      height: 20,
                    ),
                    //Back button, a SignButton look-a-like:
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.symmetric(horizontal: 100.0),
                          decoration: BoxDecoration(
                              //border: Border.all(color: Colors.white70),
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
                                      color: Colors.white,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 16.0)),
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

  /**
   * A function sending an email to the entered email address if clicked on the "Reset Password"
   */
  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: widget._emailController.text.trim());
      widget._forgotPwCon.wrongInputPopup(context, true, widget._emailController);
      //widget._emailController.text = ""; //making TextField empty
    } on FirebaseAuthException catch (e) {
      widget._forgotPwCon.wrongInputPopup(context, false, widget._emailController);
    }
  }
}