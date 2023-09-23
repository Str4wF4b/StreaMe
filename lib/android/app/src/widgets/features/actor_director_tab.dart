import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/features/actor_director_tile.dart';

class ActorDirectorTab extends StatefulWidget {
  final Actor actorDirector;
  final Map tabContent;

  const ActorDirectorTab(
      {super.key, required this.actorDirector, required this.tabContent});

  @override
  State<ActorDirectorTab> createState() => _ActorDirectorTabState();
}

class _ActorDirectorTabState extends State<ActorDirectorTab> {
  final ColorPalette color = ColorPalette();

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
          const SizedBox(height: 10.0),
          tabContent(movies!, allMovies),
          const SizedBox(height: 20.0),
          tabText("Series", series!),
          const SizedBox(height: 10.0),
          tabContent(series!, allSeries)
        ],
      ),
    );
  }

  Align tabContent(List filtered, List fullList) => Align(
    alignment: Alignment.topLeft,
    child: SizedBox(
      height: filtered.isNotEmpty ? 210 : 0,
      child: ListView.builder(
          itemCount: filtered?.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            String currentTitle = filtered?.elementAt(index);

            if (filtered!.isNotEmpty) {
              Streams currentStream = fullList
                  .where((stream) => stream.title.contains(currentTitle))
                  .single;
              ActorDirectorTile currentTile = ActorDirectorTile(
                stream: currentStream,
                imageUrl: currentStream.image,
                title: currentTitle,
              );

              if (filtered.length > 1) {
                if (filtered.last == currentStream) {
                  return currentTile;
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: currentTile,
                  );
                }
              } else {
                return currentTile;
              }
            } else {
              return Container();
            }
          }),
    ),
  );

  Widget tabText(String tabSubtitle, List filtered) {
    if (filtered.isNotEmpty) {
      return Text(tabSubtitle,
          style: TextStyle(
              color: color.bodyTextColor,
              fontSize: 17.0,
              fontWeight: FontWeight.bold));
    } else {
        return RichText(
          text: TextSpan(
              text: tabSubtitle,
              style: TextStyle(
            color: color.bodyTextColor,
            fontSize: 17.0,
            fontWeight: FontWeight.bold),
              children: const [
                TextSpan(
                    text: "\n    Not included in any.",
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 14, height: 1.8)),
              ]),
        );
    }
  }
}
