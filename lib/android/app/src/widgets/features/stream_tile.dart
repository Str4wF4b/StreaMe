import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../utils/constants_and_values.dart';
import '../../pages/others/stream_details.dart';

class StreamTile extends StatefulWidget {
  final Streams stream;
  final String image;
  final String title;
  final String year;
  final String pg;
  final double rating;
  final List cast;
  final List provider;
  final bool fromHomeButton;

  const StreamTile(
      {super.key,
      required this.stream,
      required this.image,
      required this.title,
      required this.year,
      required this.pg,
      required this.rating,
      required this.cast,
      required this.provider,
      required this.fromHomeButton});

  @override
  State<StreamTile> createState() => _StreamTileState();
}

class _StreamTileState extends State<StreamTile> {
  final ColorPalette color = ColorPalette();
  final ConstantsAndValues cons = ConstantsAndValues();

  final keyRow = GlobalKey();
  bool _addFavourites = true; //true because it's already in the Favourites list
  //Size? size;
  //Offset? position;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: widget.stream),
            )),
        child: Row(
            key: keyRow,
            crossAxisAlignment: CrossAxisAlignment.start,
            //at start so that the title is on left side besides the image
            children: [
              Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                    width: 101,
                    height: 101,
                    placeholder: (context, url) => cons.streamImagePlaceholder,
                    errorWidget: (context, url, error) => cons.imageErrorWidget,
                  ),
                ),
              ]),

              //Second column with 4 lines
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //all widgets below are justified on the top left of the second column
                        children: [
                          //First line: Title
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: color.bodyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(height: 5.0),

                          //Second line: Year, PG and Rating
                          Row(
                            children: [
                              Text(
                                widget.year,
                                style: TextStyle(
                                    color: color.bodyTextColor, fontSize: 13.0),
                              ),
                              const SizedBox(width: 13.0),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        1.5, 0.0, 1.5, 0.0),
                                    height: 16,
                                    width: 25.5,
                                    color: color.bodyTextColor,
                                    child: Text(
                                      widget.pg,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color:
                                              color.backgroundColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                      height: cons.textHeight),
                                    ),
                                  )),
                              const SizedBox(width: 13.0),
                              Icon(Icons.star,
                                  color: color.bodyTextColor, size: 15.0),
                              const SizedBox(width: 0.6),
                              Text("${widget.rating}",
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: color.bodyTextColor)),
                            ],
                          ),
                          const SizedBox(height: 5.0),

                          //Third line: Cast
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 160,
                            //making place for favourite heart icon on the right
                            child: RichText(
                              text: TextSpan(
                                  text: "Starring: ",
                                  style: TextStyle(
                                      color: color.bodyTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: getCast(widget.cast),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400
                                        ))
                                  ]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 5.0),

                          //Fourth line: Streaming Platforms
                          RichText(
                            text: TextSpan(
                                text: widget.provider.isEmpty
                                    ? "Not streamable at the moment."
                                    : "On: ",
                                style: TextStyle(
                                    color: color.bodyTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                      text: widget.provider.isEmpty
                                          ? ""
                                          : getProvider(widget.provider),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                      ))
                                ]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Positioned(
                        left: MediaQuery.of(context).size.width - 168,
                        bottom: 24,
                        child: IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context)
                                ..removeCurrentSnackBar()
                                ..showSnackBar(
                                    removedSnackBar(widget.stream.type));
                              setState(() {
                                _addFavourites = !_addFavourites;
                                //_addFavourites ? favourites.add(currentStream) : favourites.remove(currentStream);
                                //TODO: Save Stream to Firestore favourites for specific user
                              });
                            },
                            icon: Icon(
                              _addFavourites
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: Colors.red,
                            )),
                      )
                    ],
                  ),
                ),
              )
            ]));
  }

  String getCast(List list) {
    String cast = "";

    for (var actor in list) {
      if (actor != list.last) {
        cast += "$actor, ";
      } else {
        cast += actor;
      }
    }
    return cast;
  }

  String getProvider(List list) {
    String provider = "";

    for (var platform in list) {
      if (platform != list.last) {
        provider += "$platform, ";
      } else {
        provider += platform;
      }
    }
    return provider;
  }

  SnackBar removedSnackBar(String title) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          left: 28.0, right: 28.0, bottom: widget.fromHomeButton ? 4.0 : 64.0),
      //was 66
      duration: const Duration(milliseconds: 2500),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$title removed from Favourites.",
            style: TextStyle(color: color.bodyTextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: undoFavRemoved,
            child: const Text("Undo.",
                style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blueAccent)),
          )
        ],
      ));

  void undoFavRemoved() {
    setState(() {
      _addFavourites = true;
    });
  }

  void getRowSizeAndPosition() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          //position = box.localToGlobal(Offset.zero); //coordinate system
          //size = box.size;
        });
      });
}
