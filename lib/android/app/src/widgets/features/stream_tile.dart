import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/services/functions/rating_data.dart';
import 'package:stream_me/android/app/src/services/models/rating_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../utils/constants_and_values.dart';
import '../../pages/others/stream_details.dart';

class StreamTile extends StatefulWidget {
  final Streams stream;
  final String image;
  final String title;
  final List year;
  final String pg;
  final List cast;
  final List provider;
  final bool fromHomeButton;
  final void Function()? onPressed;
  final Widget icon;

  const StreamTile(
      {super.key,
      required this.stream,
      required this.image,
      required this.title,
      required this.year,
      required this.pg,
      required this.cast,
      required this.provider,
      required this.fromHomeButton,
      required this.onPressed,
      required this.icon});

  @override
  State<StreamTile> createState() => _StreamTileState();
}

class _StreamTileState extends State<StreamTile> {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  // Local instances:
  final _keyRow = GlobalKey();

  // Database:
  final _ratingRepo = RatingData();
  late double _rating = 0.0; // initial average rating

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    calculateRating(widget.stream);

    return GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: widget.stream),
            )),
        child: Row(
            key: _keyRow,
            crossAxisAlignment: CrossAxisAlignment.start,
            // start from left-hand side
            children: [
              // First column contains Stream cover (on left-hand side):
              Column(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                    width: 101,
                    height: 101,
                    placeholder: (context, url) => _cav.streamImagePlaceholder,
                    // show loading circle while loading image
                    errorWidget: (context, url, error) => _cav
                        .imageErrorWidget, // if no connection, show error icon
                  ),
                ),
              ]),

              // Second column contains Stream title, year and pg and rating, cast and platform providers:
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // all widgets below are set on the top left of the second column
                        children: [
                          // First line: Title
                          FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: _color.bodyTextColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                          const SizedBox(height: 5.0),

                          // Second line: Row with Year, PG and Rating:
                          Row(
                            children: [
                              // Year:
                              Text(
                                streamYears(widget.year),
                                style: TextStyle(
                                    color: _color.bodyTextColor,
                                    fontSize: 13.0),
                              ),
                              const SizedBox(width: 13.0),
                              // PG:
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        1.5, 0.0, 1.5, 0.0),
                                    height: 16,
                                    width: 25.5,
                                    color: _color.bodyTextColor,
                                    child: Text(
                                      widget.pg,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: _color.backgroundColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          height: _cav.textHeight),
                                    ),
                                  )),
                              const SizedBox(width: 13.0),
                              // Rating:
                              Icon(Icons.star,
                                  color: _color.bodyTextColor, size: 15.0),
                              const SizedBox(width: 0.6),
                              Text(_rating.toStringAsFixed(1),
                                  style: TextStyle(
                                      fontSize: 13.0,
                                      color: _color.bodyTextColor)),
                            ],
                          ),
                          const SizedBox(height: 5.0),

                          // Third line: Cast
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 160,
                            child: RichText(
                              text: TextSpan(
                                  text: "Starring: ",
                                  style: TextStyle(
                                      color: _color.bodyTextColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: getCast(widget.cast),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400))
                                  ]),
                              maxLines: 2, // take only space of two lines
                              overflow: TextOverflow
                                  .ellipsis, // if two lines not sufficient, add "..."
                            ),
                          ),
                          const SizedBox(height: 5.0),

                          // Fourth line: Streaming Platform Providers
                          RichText(
                            text: TextSpan(
                                text: widget.provider.isEmpty
                                    ? "Not streamable at the moment."
                                    : "On: ",
                                style: TextStyle(
                                    color: _color.bodyTextColor,
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
                            overflow: TextOverflow
                                .ellipsis, // if one line not sufficient, add "..."
                          ),
                        ],
                      ),
                      // Favourite icon on the right-hand side:
                      Positioned(
                        left: MediaQuery.of(context).size.width - 168,
                        bottom: 24,
                        child: IconButton(
                            onPressed: widget.onPressed, icon: widget.icon),
                      )
                    ],
                  ),
                ),
              )
            ]));
  }

  /// A function that calculates the average rating of the current stream in real time
  /// currentStream: The current stream whose average rating should be calculated
  calculateRating(Streams currentStream) async {
    List<RatingModel> ratedStreams = await _ratingRepo.getAllStreamRatings(
        currentStream.id.toString()); // get all Rating instances
    List<double> streamRatings = [];

    for (var stream in ratedStreams) {
      streamRatings
          .add(stream.rating); // fill the ratings list with all ratings
    }

    int numberOfRatings = streamRatings.length;
    double sum = streamRatings.fold(
        0.0,
        (previousValue, element) =>
            previousValue! + element); // sum up all ratings
    if (numberOfRatings != 0) {
      if (mounted) {
        setState(() {
          _rating = (sum /
              numberOfRatings); // set the average rating if at least one rating is submitted
        });
      }
    } else {
      _rating = 0.0;
    }
  }

  /// A function that returns the year of a movie or the year period of a series
  /// years: The list of years a movie has been produced or a series is running
  String streamYears(List years) {
    String streamYears = "";
    for (String year in years) {
      // If movie or series was produced in one year only:
      if (years.length == 1) {
        streamYears = year;
      } else {
        String currentYear = DateTime.timestamp().year.toString();
        if (year.contains(currentYear)) {
          // if movie or series is still in production
          streamYears = "${years.first} - curr.";
        } else {
          // if series is longer than one year
          streamYears = "${years.first} - ${years.last}";
        }
      }
    }
    return streamYears;
  }

  /// A function that splits the list of actors into a String of actors
  /// actors: The list of the whole cast
  String getCast(List actors) {
    String cast = "";

    for (var actor in actors) {
      if (actor != actors.last) {
        cast += "$actor, "; // add comma and space between actors
      } else {
        cast +=
            actor; // the last actor of the list is returned without comma and space
      }
    }
    return cast;
  }

  /// A function that splits the list of platform providers into a String of platform providers
  /// platformProvider: The list of all platform providers
  String getProvider(List platformProvider) {
    String provider = "";

    for (var platform in platformProvider) {
      if (platform != platformProvider.last) {
        provider += "$platform, "; // add comma and space between platforms
      } else {
        provider +=
            platform; // the last platform of the list is returned without comma and space
      }
    }
    return provider;
  }
}
