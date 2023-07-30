import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';

import '../widgets/features/login_text-field.dart';
import '../widgets/features/login_sign-buttons.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();

  final _emailController = TextEditingController();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  ColorPalette color = ColorPalette();
  Images image = Images();

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
                    Image.asset(
                      //logo
                      image.streameIcon,
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
      wrongInputPopup(context, true, widget._emailController);
      //widget._emailController.text = ""; //making TextField empty
    } on FirebaseAuthException catch (e) {
      wrongInputPopup(context, false, widget._emailController);
    }
  }

  /**
   * A function that returns a popup if a password reset link is sent to the entered email
   */
  void wrongInputPopup(BuildContext context, bool correctMail, TextEditingController emailController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            checkMail(correctMail),
            style: const TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                checkMailContent(correctMail, emailController),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 5.0),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, checkMessage(correctMail, emailController)),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20.0))),
                child: Text(checkMessage(correctMail, emailController)),
              ),
            )
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.blueAccent, width: 2.0)),
        );
      },
    );
  }

  /**
   * A function that simply checks if the entered mail is correct or not and returns the corresponding title in the popup
   */
  String checkMail(bool correctMail) {
    if (correctMail) {
      return "Password resetted.";
    } else {
      return "Wrong Email";
    }
  }

  /**
   * A function that simply checks if the entered mail is correct or not and returns the corresponding content in the popup
   */
  String checkMailContent(bool correctMail, TextEditingController emailController) {
    if (correctMail) {
      return "A Password reset link has been sent to ${emailController.text}.";
    } else {
      return "The Email is not correct. Please try again.";
    }
  }

  /**
   * A function that simply checks if the entered mail is correct or not, resets the input of the TextField and returns the corresponding button in the popup
   */
  String checkMessage(bool correctMail, TextEditingController emailController) {
    if (correctMail) {
      emailController.text = "";
      return "Back";
    } else {
      return "Try again";
    }
  }
}