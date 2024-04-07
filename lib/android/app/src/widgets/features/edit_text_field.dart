import 'package:flutter/material.dart';

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
  // Local instances:
  bool _showPassword = true; // flag to trigger the password visibility

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 7.0, 16.0, 33.0),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Colors.grey.shade100,
            decorationThickness: 0.0),
        obscureText: widget.isPassword ? _showPassword : false,
        decoration: InputDecoration(
            suffixIcon: widget.isPassword // "show password" icon
                ? Padding(
                    padding: const EdgeInsets.only(right: 3.0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword =
                              !_showPassword; // switch between showing and not showing password
                        });
                      },
                      icon: _showPassword
                          ? const Icon(Icons.visibility, color: Colors.grey)
                          : const Icon(Icons.visibility_off,
                              color: Colors.grey),
                    ),
                  )
                : null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            // Labels on top of the TextField, plus the user's input:
            labelText: "${widget.labelText} ${widget.userInput}",
            labelStyle: const TextStyle(
                color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(30.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(30.0)),
            filled: true,
            fillColor: Colors.black38,
            hintText: widget.placeholder,
            // hint text as placeholder
            hintStyle: const TextStyle(
                fontSize: 13.5,
                color: Colors.grey,
                fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.fromLTRB(20.0, 18.0, 18.0, 20.0)),
      ),
    );
  }
}
