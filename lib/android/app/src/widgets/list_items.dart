import 'package:flutter/material.dart';

class ListItems extends StatelessWidget {
  final IconData icon;
  final String label;
  final int selectedIndex;
  final Function()? onTap;

  const ListItems(
      {super.key,
      required this.icon,
      required this.label,
      required this.selectedIndex,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        onTap: onTap
    );
  }
}
