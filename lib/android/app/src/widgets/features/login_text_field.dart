import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController? inputController; // user's input
  final bool obscureText; // obscured text for password in text field
  final String hintText; // hint text in text field
  final IconData prefixIcon;

  //final Icon suffixIcon;

  const LoginTextField({super.key,
    required this.inputController,
    required this.obscureText,
    required this.hintText,
    required this.prefixIcon,
    /*required this.suffixIcon*/
  });


  @override
  Widget build(BuildContext context) {
    final color = ColorPalette();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: inputController, // get user's input
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, size: 28),
            prefixIconColor: Colors.grey,
            //TODO: suffixIcon
            /*suffixIcon:
                checkIconButton(suffixIcon, inputController, obscureText),*/
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(20.0)),
            filled: true,
            fillColor: color.bodyTextColor,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  /*
  Widget checkIconButton(Icon icon, TextEditingController controller,
      bool obscureText) {
    obscureText = this.obscureText;
    if (icon.toString() == const Icon(Icons.remove_red_eye).toString()) {
      // check if suffixIcon is the needed one or not
      print(obscureText);
      return IconButton(onPressed: () {
        obscureText = !obscureText;
      },
          icon: obscureText ? const Icon(
              Icons.visibility) : const Icon(Icons.visibility_off));
    } else {
      return IconButton(
          onPressed: null,
          icon: icon,
          disabledColor:
          Colors.transparent); // disable other not needed suffixIcon
    }
   */
  }
