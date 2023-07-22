import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/pages/others/streamDetails.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/constants.dart';

class SwipeCard extends StatefulWidget {
  final Streams stream;

  const SwipeCard({Key? key, required this.stream}) : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  final ColorPalette color = ColorPalette();
  final Constants cons = Constants();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: MediaQuery.of(context).size.height * 0.8,
    width: MediaQuery.of(context).size.width * 0.8,
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StreamDetailsPage(stream: widget.stream),
                )),
            child: CachedNetworkImage(
              imageUrl: widget.stream.image,
              fit: BoxFit.contain,
              placeholder: (context, url) => cons.imagePlaceholderImage,
              errorWidget: (context, url, error) => cons.imageErrorWidget,
            ),
          ),
        ),
      ],
    ),
  );
}
