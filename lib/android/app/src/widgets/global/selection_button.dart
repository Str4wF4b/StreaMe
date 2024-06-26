import 'package:flutter/material.dart';

class SelectionButton extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  final String label;

  const SelectionButton(
      {super.key,
      required this.onTap,
      required this.color,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.only(
              top: label == "Reset" ? 14 : 15.0, // Reset Buttons have no background color, but border, i.e. more padding needed
              bottom: label == "Reset" ? 14 : 15.0), // Reset Buttons have no background color, but border, i.e. more padding needed
          width: 120,
          decoration: BoxDecoration(
              color: label == "Reset" ? null : color, // Reset Buttons have no background color
              border:
                  label == "Reset" ? Border.all(color: color, width: 2) : null, // only Reset Buttons have border
              borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  letterSpacing: 0.5,
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
