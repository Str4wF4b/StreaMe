import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../pages/others/stream_details.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import '../../utils/constants_and_values.dart';
import '../../utils/color_palette.dart';

// Test:
import '../../pages/others/stream_details_dummy.dart';

class ActorDirectorTile extends StatefulWidget {
  final Streams stream;
  final String imageUrl;
  final String title;

  const ActorDirectorTile(
      {super.key,
      required this.stream,
      required this.imageUrl,
      required this.title});

  @override
  State<ActorDirectorTile> createState() => _ActorDirectorTileState();
}

class _ActorDirectorTileState extends State<ActorDirectorTile> {
  final ColorPalette color = ColorPalette();
  final ConstantsAndValues cons = ConstantsAndValues();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StreamDetailsPageDummy(stream: widget.stream))),
      child: SizedBox(
        width: 140,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 170,
                placeholder: (context, url) => cons.imagePlaceholderRect,
                errorWidget: (context, url, error) =>
                    cons.imageErrorWidgetLittle,
              ),
            ),
            const SizedBox(height: 5.0),
            AutoSizeText(
              widget.stream.title,
              style: TextStyle(
                  color: color.bodyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14 * 1 / MediaQuery.of(context).textScaleFactor),
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
