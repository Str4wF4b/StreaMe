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
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          //margin: const EdgeInsets.symmetric(horizontal: 100.0),
          width: 120,
          decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
