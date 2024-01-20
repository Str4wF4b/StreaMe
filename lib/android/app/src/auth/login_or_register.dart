import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/auth/login.dart';
import 'package:stream_me/android/app/src/auth/register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  bool _showLoginPage = true;
  @override
  Widget build(BuildContext context) {
    if (_showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }

  /// A function that toggles between the Login and Register page
  void togglePages() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }
}
