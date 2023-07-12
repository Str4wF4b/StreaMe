import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';

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

  Widget moviesFavourites() => SingleChildScrollView(
        child: Column(
          children: [
            StreamTile(
              stream: allStreams.elementAt(4),
              image: allStreams.elementAt(4).image,
              title: allStreams.elementAt(4).title,
              year: allStreams.elementAt(4).year,
              pg: allStreams.elementAt(4).pg,
              rating: 4.6,
              cast: allStreams.elementAt(4).cast,
              provider: allStreams.elementAt(4).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(6),
              image: allStreams.elementAt(6).image,
              title: allStreams.elementAt(6).title,
              year: allStreams.elementAt(6).year,
              pg: allStreams.elementAt(6).pg,
              rating: 4.5,
              cast: allStreams.elementAt(6).cast,
              provider: allStreams.elementAt(6).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(7),
              image: allStreams.elementAt(7).image,
              title: allStreams.elementAt(7).title,
              year: allStreams.elementAt(7).year,
              pg: allStreams.elementAt(7).pg,
              rating: 4.6,
              cast: allStreams.elementAt(7).cast,
              provider: allStreams.elementAt(7).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(8),
              image: allStreams.elementAt(8).image,
              title: allStreams.elementAt(8).title,
              year: allStreams.elementAt(8).year,
              pg: allStreams.elementAt(8).pg,
              rating: 4.2,
              cast: allStreams.elementAt(8).cast,
              provider: allStreams.elementAt(8).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(10),
              image: allStreams.elementAt(10).image,
              title: allStreams.elementAt(10).title,
              year: allStreams.elementAt(10).year,
              pg: allStreams.elementAt(10).pg,
              rating: 4.3,
              cast: allStreams.elementAt(10).cast,
              provider: allStreams.elementAt(10).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(11),
              image: allStreams.elementAt(11).image,
              title: allStreams.elementAt(11).title,
              year: allStreams.elementAt(11).year,
              pg: allStreams.elementAt(11).pg,
              rating: 4.6,
              cast: allStreams.elementAt(11).cast,
              provider: allStreams.elementAt(11).provider,
            )
          ],
        ),
      );

  Widget seriesFavourites() => SingleChildScrollView(
        child: Column(
          children: [
            StreamTile(
              stream: allStreams.elementAt(0),
              image: allStreams.elementAt(0).image,
              title: allStreams.elementAt(0).title,
              year: allStreams.elementAt(0).year,
              pg: allStreams.elementAt(0).pg,
              rating: 4.6,
              cast: allStreams.elementAt(0).cast,
              provider: allStreams.elementAt(0).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(1),
              image: allStreams.elementAt(1).image,
              title: allStreams.elementAt(1).title,
              year: allStreams.elementAt(1).year,
              pg: allStreams.elementAt(1).pg,
              rating: 4.5,
              cast: allStreams.elementAt(1).cast,
              provider: allStreams.elementAt(1).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(2),
              image: allStreams.elementAt(2).image,
              title: allStreams.elementAt(2).title,
              year: allStreams.elementAt(2).year,
              pg: allStreams.elementAt(2).pg,
              rating: 4.6,
              cast: allStreams.elementAt(2).cast,
              provider: allStreams.elementAt(2).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(3),
              image: allStreams.elementAt(3).image,
              title: allStreams.elementAt(3).title,
              year: allStreams.elementAt(3).year,
              pg: allStreams.elementAt(3).pg,
              rating: 4.2,
              cast: allStreams.elementAt(3).cast,
              provider: allStreams.elementAt(3).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(5),
              image: allStreams.elementAt(5).image,
              title: allStreams.elementAt(5).title,
              year: allStreams.elementAt(5).year,
              pg: allStreams.elementAt(5).pg,
              rating: 4.3,
              cast: allStreams.elementAt(5).cast,
              provider: allStreams.elementAt(5).provider,
            ),
            const SizedBox(height: 20),
            StreamTile(
              stream: allStreams.elementAt(9),
              image: allStreams.elementAt(9).image,
              title: allStreams.elementAt(9).title,
              year: allStreams.elementAt(9).year,
              pg: allStreams.elementAt(9).pg,
              rating: 4.6,
              cast: allStreams.elementAt(9).cast,
              provider: allStreams.elementAt(9).provider,
            ),
          ],
        ),
      );
}
