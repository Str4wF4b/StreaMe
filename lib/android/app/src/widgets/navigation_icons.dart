import 'package:flutter/material.dart';

class NavigationIcons extends StatelessWidget {
  final String iconText;
  final IconData icon;
  final bool selected;
  final Function()? onPressed;

  const NavigationIcons(
      {super.key,
      required this.iconText,
      required this.icon,
      required this.selected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: selected ? Colors.white : Colors.grey.shade500),
        ),
        Text(iconText, style: TextStyle(
          color: selected ? Colors.white : Colors.grey.shade500,
          fontSize: 12,
          height: 0.1,
        ),)
      ],
    );
  }
}
