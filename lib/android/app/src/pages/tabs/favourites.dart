import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';

import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../widgets/features/stream_tile.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    /*return AppOverlay(title: "Favourites", body: buildBody(),);
  }

  Widget buildBody() {
    */
    return Container(
        color: color.middleBackgroundColor,
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Scaffold(
              backgroundColor: color.middleBackgroundColor,
              body: SafeArea(
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          //overlayColor: MaterialStateColor,
                          //dividerColor: Colors.redAccent,

                          labelColor: Colors.grey.shade300,
                          unselectedLabelColor: Colors.grey,
                          isScrollable: true,
                          indicatorColor: Colors.deepOrangeAccent,
                          indicatorPadding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          tabs: const [
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 3.0),
                              child: Text(
                                "Movies",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 3.0),
                              child: Text(
                                "Series",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: TabBarView(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 25.0, bottom: 5.0),
                            child: moviesFavourites(),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 25.0, bottom: 5.0),
                              child: seriesFavourites())
                        ],
                      ))
                    ]),
              ),
            ),
          ),
        ));
  }

  Widget moviesFavourites() {
    List movies = allStreams
        .where((element) => (element.type.toString() == "Movie"))
        .toList();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: movies.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Streams currentStream = movies.elementAt(index);
                StreamTile currentTile = StreamTile(
                    stream: currentStream,
                    image: currentStream.image,
                    title: currentStream.title,
                    year: currentStream.year,
                    pg: currentStream.pg,
                    rating: 4.6,
                    //TODO
                    cast: currentStream.cast,
                    provider: currentStream.provider);

                if (currentStream == movies.last &&
                    currentStream != movies.first) {
                  return currentTile;
                } else {
                  return Column(
                    children: [currentTile, const SizedBox(height: 20)],
                  );
                }
              }),
        ),
      ],
    );
  }

  Widget seriesFavourites() {
    List series = allStreams
        .where((element) => (element.type.toString() == "Series"))
        .toList();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: series.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Streams currentStream = series.elementAt(index);
                StreamTile currentTile = StreamTile(
                    stream: currentStream,
                    image: currentStream.image,
                    title: currentStream.title,
                    year: currentStream.year,
                    pg: currentStream.pg,
                    rating: 4.6,
                    //TODO
                    cast: currentStream.cast,
                    provider: currentStream.provider);

                if (currentStream == series.last &&
                    currentStream != series.first) {
                  return currentTile;
                } else {
                  return Column(
                    children: [currentTile, const SizedBox(height: 20)],
                  );
                }
              }),
        ),
      ],
    );
  }
}
