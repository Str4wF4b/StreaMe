import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/widgets/global/app_overlay.dart';
import 'package:stream_me/android/app/src/pages/tabs/home.dart';
import 'package:stream_me/android/app/src/auth/login_or_register.dart';

/// Class that checks if the user is signed in or not
/// If not, the LoginPage is shown, otherwise the HomePage is shown

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          // constantly listens to authentication state changes, i.e. if user is logged in or not
          builder: (context, snapshot) {
            // user is logged in:
            if (snapshot.hasData) {
              return AppOverlay(
                fromHomeButton: false,
                  currentPageIndex: 0) /*HomePage()*/;
            } else {
              // user is not logged in:
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}
