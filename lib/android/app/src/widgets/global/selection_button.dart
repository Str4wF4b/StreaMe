import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class SelectionButton extends StatelessWidget {
  final void Function() onTap;
  final Color color;
  final String label;

  SelectionButton(
      {super.key, required this.onTap, required this.color, required this.label});

  ColorPalette colorPalette = ColorPalette();

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
              border: Border.all(color: colorPalette.bodyTextColor, width: 1.5),
              borderRadius: BorderRadius.circular(30.0)),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 16.0,
                  color: colorPalette.bodyTextColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ));
  }
}
