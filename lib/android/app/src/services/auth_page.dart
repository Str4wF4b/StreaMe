import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/view/app_overlay.dart';
import 'package:stream_me/android/app/src/view/home_page.dart';

import '../view/login-or-register_page.dart';

/**
 * Class that checks if the user is signed in or not
 * If not, the LoginPage is shown, otherwise the HomePage is shown
 */

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          // constantly listens to authentication state changes, i.e. if user is logged in or not
          builder: (context, snapshot) {
            // user is logged in:
            if (snapshot.hasData) {
              return AppOverlay(title: "Home", body: const HomePage(), currentPageIndex: 0) /*HomePage()*/;
            } else {
              // user is not logged in:
              return LoginOrRegisterPage();
            }
          }),
    );
  }
}
