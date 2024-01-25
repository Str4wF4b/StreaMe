import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String placeholder;
  final bool isPassword;
  final String userInput;

  const EditTextField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.placeholder,
      required this.isPassword,
      required this.userInput});

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  bool showPassword = true;
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 7.0, 16.0, 35.0),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: Colors.grey.shade100,
        ),
        obscureText: widget.isPassword ? showPassword : false,
        decoration: InputDecoration(
            //style of label
            suffixIcon: widget.isPassword //show password icon
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword =
                            !showPassword; //switch between showing and not showing password
                      });
                    },
                    icon: showPassword
                        ? const Icon(Icons.visibility, color: Colors.grey)
                        : const Icon(Icons.visibility_off,
                            color: Colors
                                .grey), /*const Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),*/
                  )
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            //input labels are always open
            labelText: "${widget.labelText} ${widget.userInput}",
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
            //enabledBorder: const UnderlineInputBorder(
            //    borderSide: BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(25.0)),
            filled: true,
            fillColor: Colors.black38,
            hintText: widget.placeholder,
            //style of placeholder
            hintStyle: const TextStyle(
              fontSize: 13.5,
              color: Colors.grey,
            ),
            contentPadding: const EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 18.0)),
      ),
    );
  }
}
