import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';

class StreameRefresh extends StatefulWidget {
  final Widget child;

  StreameRefresh({super.key, required this.child});

  @override
  State<StreameRefresh> createState() => _StreameRefreshState();
}

class _StreameRefreshState extends State<StreameRefresh> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    //TODO: Actually reload stuff
    return CustomRefreshIndicator(
        builder: MaterialIndicatorDelegate(builder: (context, controller) {
          return Icon(
            Icons.camera,
            color: color.backgroundColor,
            size: 30,
          );
        }),
        onRefresh: () async {
          setState(() {
          });
          return await Future.delayed(const Duration(seconds: 2));
        },
        child: widget.child);
  }
}
