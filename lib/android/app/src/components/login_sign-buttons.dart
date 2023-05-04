import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/controller/login_controller.dart';

class SignButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const SignButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        // padding inside button
        margin: const EdgeInsets.symmetric(horizontal: 100.0),
        // padding outside button
        decoration: BoxDecoration(
            //border: Border.all(color: Colors.white70),
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(30.0)),
        child: Center(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0))),
      ),
    );
  }
}
