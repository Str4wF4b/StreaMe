import 'package:flutter/material.dart';

class LoginTile extends StatelessWidget {
  final bool isIcon;
  final String imagePath;
  final IconData iconData;
  final Function()? onTap;

  const LoginTile(
      {super.key,
      required this.isIcon,
      required this.imagePath,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.grey.shade300),
        child: checkImageOrIcon(),
      ),
    );
  }

  /// Function to quick-check if an icon or an image is inside the login tile
  Widget checkImageOrIcon() {
    if (isIcon) {
      // if icon in tile
      return Icon(
        iconData,
        size: 40,
      );
    } else {
      // if image in tile
      return Image.asset(
        imagePath,
        height: 40,
      );
    }
  }
}
