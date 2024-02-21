import 'package:flutter/material.dart';
import '../utils/color_palette.dart';

class Styles {
  static ColorPalette color = ColorPalette();

  ButtonStyle exploreButtonStyle = ElevatedButton.styleFrom(
      shape: const CircleBorder(),
      padding: const EdgeInsets.all(16.0),
      elevation: 0.0,
      backgroundColor: Colors.grey.shade900);
}
