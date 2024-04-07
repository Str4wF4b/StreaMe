import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class LoginTile extends StatelessWidget {
  final String imagePath;
  final Function()? onTap;

  const LoginTile({super.key, required this.imagePath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16.0),
            color: ColorPalette().bodyTextColor),
        child: Image.asset(imagePath, height: 40),
      ),
    );
  }
}
