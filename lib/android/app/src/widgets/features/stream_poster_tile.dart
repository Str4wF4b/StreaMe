import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import '../../utils/constants_and_values.dart';
import '../../utils/color_palette.dart';
import '../../pages/others/stream_details.dart';

class StreamPosterTile extends StatefulWidget {
  final Streams stream;
  final String imageUrl;
  final String title;

  const StreamPosterTile(
      {super.key,
      required this.stream,
      required this.imageUrl,
      required this.title});

  @override
  State<StreamPosterTile> createState() => _StreamPosterTileState();
}

class _StreamPosterTileState extends State<StreamPosterTile> {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: widget.stream))),
      // open corresponding Stream Page
      child: SizedBox(
        width: 140,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 170,
                placeholder: (context, url) => _cav.streamImagePlaceholder,
                // show loading circle while loading image
                errorWidget: (context, url, error) => _cav
                    .imageErrorWidgetLittle, // if no connection, show error icon
              ),
            ),
            const SizedBox(height: 5.0),
            AutoSizeText(
              // Caption of Stream cover:
              widget.stream.title,
              style: TextStyle(
                  color: _color.bodyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: MediaQuery.textScalerOf(context).scale(11.57),
                  height: _cav.textHeight),
              maxLines: 2,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
