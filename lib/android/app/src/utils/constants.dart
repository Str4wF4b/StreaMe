import 'package:flutter/material.dart';

class Constants {
  Widget imagePlaceholder = Transform.scale(scale: 0.5, child: const CircularProgressIndicator()); //only for square widgets
  Widget imagePlaceholderRect = Transform.scale(scaleX: 0.25, scaleY: 0.285, child: const CircularProgressIndicator()); //only for SliverAppBar
  Widget imagePlaceholderImage = Transform.scale(scale: 1, child: const CircularProgressIndicator()); //only for Images of 300x450;

  Widget imageErrorWidget = const Icon(Icons.error_outline, color: Colors.redAccent, size: 40);
  Widget imageErrorWidgetLittle = const Icon(Icons.error_outline, color: Colors.redAccent, size: 30);
}