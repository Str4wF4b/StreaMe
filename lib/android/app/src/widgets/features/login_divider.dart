import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/constants_and_values.dart';

class LoginDivider extends StatelessWidget {
  LoginDivider({super.key});
  // Utils:
  final ConstantsAndValues _cav = ConstantsAndValues();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          const Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.white70,
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Or continue with",
              style: TextStyle(color: Colors.white60, height: _cav.textHeight),
            ),
          ),
          const Expanded(child: Divider(thickness: 0.5, color: Colors.white70))
        ],
      ),
    );
  }
}
