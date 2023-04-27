import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/controller/login_controller.dart';

class SignInButton extends StatelessWidget {
  final LoginController _loginCon = LoginController();

  SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loginCon.signUserIn,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        // padding inside button
        margin: const EdgeInsets.symmetric(horizontal: 100.0),
        // padding outside button
        decoration: BoxDecoration(
          //border: Border.all(color: Colors.white70),
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(30.0)),
        child: const Center(
            child: Text("Sign In",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0))),
      ),
    );
  }
}
