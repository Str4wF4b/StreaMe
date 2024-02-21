import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class LoginTextField extends StatefulWidget {
  final TextEditingController? inputController; // user's input
  final bool obscureText; // obscured text for password in text field
  final String hintText; // hint text in text field
  final IconData prefixIcon;

  const LoginTextField(
      {super.key,
      required this.inputController,
      required this.obscureText,
      required this.hintText,
      required this.prefixIcon});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    final color = ColorPalette();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: widget.inputController, // get user's input
        obscureText: widget.obscureText ? _showPassword : false,
        decoration: InputDecoration(
            prefixIcon: Icon(widget.prefixIcon, size: 26),
            prefixIconColor: Colors.grey,
            suffixIcon: widget.obscureText //show password icon
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _showPassword =
                            !_showPassword; //switch between showing and not showing password
                      });
                    },
                    icon: _showPassword
                        ? const Icon(Icons.visibility,
                            color: Colors.grey, size: 24)
                        : const Icon(Icons.visibility_off,
                            color: Colors.grey, size: 24))
                : null,
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(30.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(30.0)),
            filled: true,
            fillColor: color.bodyTextColor,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
