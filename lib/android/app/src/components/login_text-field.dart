import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final inputController;
  final bool obscureText;
  final String hintText;
  final IconData prefixIcon;

  //final Icon suffixIcon;

  const LoginTextField({Key? key,
    required this.inputController,
    required this.obscureText,
    required this.hintText,
    required this.prefixIcon,
    /*required this.suffixIcon*/
  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: inputController, // get user's input
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, size: 28),
            prefixIconColor: Colors.grey,
            /*suffixIcon:
                checkIconButton(suffixIcon, inputController, obscureText),*/
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(20.0)),
            filled: true,
            fillColor: Colors.grey.shade300,
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
