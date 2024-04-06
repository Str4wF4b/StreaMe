import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/auth/auth_main.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class Functions {
  // Utils:
  final ColorPalette _color = ColorPalette();

  /// A function that returns a Container with a notification Text for anonymous users to login to use all App functions
  /// context: The context of the current widget tree
  /// isTab: The boolean that indicates if the current widget is a Tab Page or a openable Screen Page to determine the background color of the Widget
  Widget anonLoggedIn(BuildContext context, bool isTab) => Scaffold(
      backgroundColor: _color.backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: isTab ? _color.middleBackgroundColor : _color.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 30.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "You are not logged in. ",
                // inform user that he is not logged in
                style: TextStyle(color: Colors.grey),
              ),
              const Text("Login or register ",
                  style: TextStyle(color: Colors.grey)),
              GestureDetector(
                child: const Text(
                  "here",
                  // clickable link to navigate to Login respectively Register Page
                  style: TextStyle(color: Colors.blueAccent),
                ),
                onTap: () async => await FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const AuthPage()),
                        (route) => false)),
              ),
              const Text(".", style: TextStyle(color: Colors.grey))
            ],
          ),
        ),
      ));
}
