import 'package:flutter/material.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: const [
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.white70,
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Or continue with",
              style: TextStyle(color: Colors.white60),
            ),
          ),
          Expanded(child: Divider(thickness: 0.5, color: Colors.white70))
        ],
      ),
    );
  }
}
