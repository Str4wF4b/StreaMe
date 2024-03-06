import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/auth/auth_main.dart';
import '../../utils/color_palette.dart';

class AuthPopups {
  final ColorPalette _color = ColorPalette();

  /// A function that returns a popup if the email or password is wrong when logging in
  void wrongInputPopup(String input, BuildContext context, bool isLogin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            checkLoginOrRegisterTitle(isLogin),
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
                checkLoginOrRegisterContent(isLogin, input),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 12.0),
          actions: [
            Center(
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

  /// A function that simply checks if the user wants to login or register and returns the corresponding title in the popup
  String checkLoginOrRegisterTitle(bool isLogin) {
    if (isLogin) {
      return "Login not possible.";
    } else {
      return "Registration not possible.";
    }
  }

  /// A function that simply checks if the user wants to login or register and returns the corresponding content in the popup
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

  ///A function that returns a dialog after a user has been successfully created
  Future signUpDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _color.backgroundColor,
          elevation: 0.0,
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
                          color: Colors.green.shade500, /*width: 2.0*/),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Start now",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0)),
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

  Future reauthenticateDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _color.backgroundColor,
          elevation: 0.0,
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
            GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut().then(
                          (value) => Navigator.of(context)
                          .pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) =>
                              const AuthPage()),
                              (route) => false));
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(3.0, 5.0, 0.0, 5.0),
                  margin: const EdgeInsets.symmetric(horizontal: 65.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: _color.bodyTextColor, /*width: 2.0*/),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login ",
                          style: TextStyle(
                              color: _color.bodyTextColor,
                              fontSize: 16.0)),
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
}
