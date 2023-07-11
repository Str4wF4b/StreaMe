import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/auth/login.dart';
import 'package:stream_me/android/app/src/auth/register.dart';

class LoginOrRegisterPage extends StatefulWidget {
  bool showLoginPage = true;

  LoginOrRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  @override
  Widget build(BuildContext context) {
    if (widget.showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }

  /**
   * A function that toggles between the Login and Register page
   */
  void togglePages() {
    setState(() {
      widget.showLoginPage = !widget.showLoginPage;
    });
  }
}
