import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/features/stream_poster_tile.dart';

class ActorDirectorTab extends StatefulWidget {
  final Actor actorDirector;
  final Map tabContent;

  const ActorDirectorTab(
      {super.key, required this.actorDirector, required this.tabContent});

  @override
  State<ActorDirectorTab> createState() => _ActorDirectorTabState();
}

class _ActorDirectorTabState extends State<ActorDirectorTab> {
  // Utils:
  final ColorPalette _color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    List allMovies =
        allStreams.where((stream) => stream.type.contains("Movie")).toList();
    List allSeries =
        allStreams.where((stream) => stream.type.contains("Series")).toList();
    List? movies = widget.tabContent["Movies"];
    List? series = widget.tabContent["Series"];

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 5.0),
          tabText("Movies", movies!),
          // Movies headline (and possible empty content message) for current actor/director
          const SizedBox(height: 10.0),
          tabContent(movies, allMovies),
          // content of Movies row
          const SizedBox(height: 20.0),
          tabText("Series", series!),
          // Series headline (and possible empty content message) for current actor/director
          const SizedBox(height: 10.0),
          tabContent(series, allSeries)
          // content of Series row
        ],
      ),
    );
  }

  /// A function that adds a headline inside a Tab of an actor/director and additionally adds a empty content message if the content is empty
  /// tabSubtitle: The headline of the movies or series row inside a Tab of an actor/director
  /// filtered: The filtered list of movies or series an actor/director is included
  Widget tabText(String tabSubtitle, List filtered) {
    if (filtered.isNotEmpty) {
      // if the filtered list, an actor/director is included, is not empty, add only the headline text
      return Text(tabSubtitle,
          style: TextStyle(
              color: _color.bodyTextColor,
              fontSize: 17.0,
              fontWeight: FontWeight.bold));
    } else {
      // if filtered list is empty, add the headline text plus a empty content message below it
      return RichText(
        text: TextSpan(
            text: tabSubtitle,
            style: TextStyle(
                color: _color.bodyTextColor,
                fontSize: 19.0,
                fontWeight: FontWeight.bold),
            children: const [
              TextSpan(
                  text: "\n    Not included in any.", // empty content message
                  style: TextStyle(
                      fontWeight: FontWeight.w400, fontSize: 14, height: 1.8)),
            ]),
      );
    }
  }

  /// A function that returns the content of the Movies/Series row inside a Tab of an actor/director
  /// filtered: The filtered list of movies or series an actor/director is included
  /// fullList: The list of all movies or series
  Align tabContent(List filtered, List fullList) => Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: filtered.isNotEmpty ? 210 : 0,
          child: ListView.builder(
              itemCount: filtered.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String currentTitle = filtered.elementAt(index);

                if (filtered.isNotEmpty) {
                  // if the filtered list, an actor/director is included, is not empty, generate a Stream Tile of the filtered movies or series
                  Streams currentStream = fullList
                      .where((stream) => stream.title.contains(currentTitle))
                      .single;
                  // Generate a Stream Tile for the current Stream:
                  StreamPosterTile currentTile = StreamPosterTile(
                    stream: currentStream,
                    imageUrl: currentStream.image,
                    title: currentTitle,
                  );

                  if (filtered.length > 1) {
                    if (filtered.last == currentStream) {
                      return currentTile; // if last Stream is reached, no need to add right-padding anymore
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: currentTile,
                      );
                    }
                  } else {
                    // if filtered list has only one element, return only this one
                    return currentTile;
                  }
                } else {
                  return Container(); // if filtered list is empty, return an empty Container (nothing)
                }
              }),
        ),
      );
}
