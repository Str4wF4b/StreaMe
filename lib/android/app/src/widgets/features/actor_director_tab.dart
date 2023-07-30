import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/features/actor_director_tile.dart';

class ActorDirectorTab extends StatefulWidget {
  final Actor actorDirector;
  final Map tabContent;

  ActorDirectorTab(
      {super.key, required this.actorDirector, required this.tabContent});

  @override
  State<ActorDirectorTab> createState() => _ActorDirectorTabState();
}

class _ActorDirectorTabState extends State<ActorDirectorTab> {
  final ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    List allMovies = allStreams.where((stream) => stream.type.contains("Movie")).toList();
    List allSeries = allStreams.where((stream) => stream.type.contains("Series")).toList();
    List? movies = widget.tabContent["Movies"];
    List? series = widget.tabContent["Series"];

    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              dropdownContent("Movies", movies!, allMovies),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: dropdownContent("Series", series!, allSeries),
              )
            ],
          ),
        ),
      ),
    );
  }

  Expandable dropdownContent(String dropdownTitle, List filtered, List fullList) =>  Expandable(
    //backgroundColor: const Color.fromRGBO(30, 28, 28, 1.0),
      backgroundColor: Colors.transparent,
      boxShadow: const [],
      initiallyExpanded: filtered!.isNotEmpty ? true : false,
      arrowWidget: Icon(
        Icons.keyboard_arrow_up,
        color: color.bodyTextColor,
      ),
      firstChild: Padding(
        padding: dropdownTitle.contains("Movies") ? const EdgeInsets.only(right: 258.0) : const EdgeInsets.only(right: 265.0),
        child: Text(dropdownTitle,
            style: TextStyle(
                color: color.bodyTextColor,
                fontSize: 17.0,
                fontWeight: FontWeight.bold)),
      ),
      secondChild: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: SizedBox(
          height: filtered!.isNotEmpty ? 210 * MediaQuery.of(context).textScaleFactor : 0,
          child: ListView.builder(
              itemCount: filtered?.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String currentTitle = filtered?.elementAt(index);

                if (filtered!.isNotEmpty) {
                  Streams currentStream = fullList
                      .where((stream) =>
                      stream.title.contains(currentTitle))
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
      ));
}
