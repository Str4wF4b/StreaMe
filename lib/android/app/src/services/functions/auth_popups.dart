import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/auth/auth_main.dart';
import '../../utils/color_palette.dart';

class AuthPopups {
  // Utils:
  final ColorPalette _color = ColorPalette();

  // For Registration:
  /// A function that returns a popup if a password reset link is sent to the entered email
  /// context: The context of the current widget tree
  /// correctMail: The bool that indicates if the email is known (i.e. correct) or not
  /// emailController: The typed in email of the user
  void handleResetMailPopup(BuildContext context, bool correctMail,
      TextEditingController emailController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            correctMail ? "Password reset" : "Wrong Email",
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
                correctMail
                    ? "A Password reset link has been sent to ${emailController.text}."
                    : "The Email is not correct. Please try again.",
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 5.0),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(
                      context, buttonText(correctMail, emailController));
                },
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20.0))),
                child: Text(buttonText(correctMail, emailController),
                    style: const TextStyle(color: Colors.blueAccent)),
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

  /// A function that resets the input of the TextField if email is correct and returns the fitting Button text inside the popup
  /// correctMail: The bool that indicates if the email is known (i.e. correct) or not
  /// emailController: The typed in email of the user
  String buttonText(bool correctMail, TextEditingController emailController) {
    if (correctMail) {
      emailController.text = "";
      return "Back";
    } else {
      return "Try again";
    }
  }

  /// A function that returns a notification Dialog after a user has been successfully created
  /// context: The context of the current widget tree
  Future signUpDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _color.backgroundColor,
          elevation: 0.0,
          // Notification Text:
          content: Text(
            "Your account has successfully been created!",
            style: TextStyle(fontSize: 16.0, color: _color.bodyTextColor),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.green.shade500, width: 2.0)),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 5.0),
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green.shade500,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Start now Button
                      Text("Start now",
                          style:
                              TextStyle(color: Colors.green, fontSize: 16.0)),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ))
          ],
        );
      },
    );
  }

  // For Registration and Login:
  /// A function that returns a popup if the email or password is wrong when logging in
  /// input: The String that indicates whether it's an Email or Password Error
  /// context: The context of the current widget tree
  /// isLogin: The boolean that indicates if the popup is used in the LoginPage or not (= RegisterPage)
  void wrongInputPopup(String input, BuildContext context, bool isLogin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Headline:
          title: Text(
            isLogin ? "Login not possible." : "Registration not possible.",
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
              // Content:
              child: Text(
                checkLoginOrRegisterContent(isLogin, input),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 12.0),
          actions: [
            Center(
              // Try again Button:
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20.0))),
                child: const Text("Try again",
                    style: TextStyle(color: Colors.blueAccent)),
              ),
            )
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.blueAccent, width: 2.0)),
        );
      },
    );
  }

  /// A function that checks if the user wants to login or register and returns the corresponding content in the popup
  /// isLogin: The boolean that indicates if the popup is used in the LoginPage or not (= RegisterPage)
  /// input: The String that indicates whether it's an Email or Password Error
  String checkLoginOrRegisterContent(bool isLogin, String input) {
    String dialogContent = "";
    if (isLogin) {
      return "The $input is not correct. Please try again.";
    } else {
      switch (input) {
        case "not-matching-passwords":
          dialogContent = "The passwords do not match. Please try again.";
          break;

        case "weak-password":
          dialogContent =
              "The password is too weak. It has to be at least 6 characters long.";
          break;

        case "email-already-in-use":
          dialogContent =
              "The Email is already in use. Please register with another Email.";
      }
    }
    return dialogContent;
  }

  /// A function that returns a popup if a re-authentication is needed when changing the profile after a longer inactivity
  /// context: The context of the current widget tree
  Future reauthenticateDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false, // don't allow user to tap outside
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _color.backgroundColor,
          elevation: 0.0,
          // Re-Login notification text:
          content: Text(
            "Please login again to change your Profile.",
            style: TextStyle(fontSize: 16.0, color: _color.bodyTextColor),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: _color.bodyTextColor, width: 2.0)),
          actions: [
            // (Re-) Login Button:
            GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const AuthPage()),
                          // navigate user back to Login Page
                          (route) => false));
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 5.0),
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _color.bodyTextColor,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login ",
                          style: TextStyle(
                              color: _color.bodyTextColor, fontSize: 16.0)),
                      const SizedBox(width: 5),
                      Icon(
                        Icons.login,
                        color: _color.bodyTextColor,
                      ),
                    ],
                  ),
                ))
          ],
        );
      },
    );
  }

  /// A function that returns a Dialog that is shown if a user changes his email to a duplicate email already used by another user
  /// context: The context of the current widget tree
  Future duplicateEmailDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _color.backgroundColor,
          elevation: 0.0,
          // Duplicate Email notification text:
          content: Text(
            "The Email is already in use.",
            style: TextStyle(fontSize: 16.0, color: _color.bodyTextColor),
            textAlign: TextAlign.center,
          ),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              side: BorderSide(color: Colors.blueAccent, width: 2.0)),
          actions: [
            // Duplicate Email Button:
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 5.0),
                  margin: const EdgeInsets.symmetric(horizontal: 50.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: _color.bodyTextColor),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Change Email",
                          style: TextStyle(
                              color: _color.bodyTextColor, fontSize: 15.0)),
                    ],
                  ),
                ))
          ],
        );
      },
    );
  }
}
