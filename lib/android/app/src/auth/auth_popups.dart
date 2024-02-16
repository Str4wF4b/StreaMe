import 'package:flutter/material.dart';

class AuthPopups {
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
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 5.0),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, "Try again"),
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
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
    if (isLogin) {
      return "The $input is not correct. Please try again.";
    } else {
      return "The passwords do not match. Please try again.";
    }
  }
}
