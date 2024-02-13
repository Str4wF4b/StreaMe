import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';

import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../widgets/features/stream_tile.dart';
import '../../widgets/global/streame_tab.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({super.key});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with TickerProviderStateMixin {
  ColorPalette color = ColorPalette();

  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    /*return AppOverlay(title: "Favourites", body: buildBody(),);
  }

  Widget buildBody() {
    */
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: Scaffold(
        backgroundColor: color.middleBackgroundColor,
        body: SafeArea(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    //overlayColor: MaterialStateColor,
                    dividerColor: Colors.transparent,
                    physics: const ClampingScrollPhysics(),
                    labelColor: color.backgroundColor,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: color.bodyTextColor,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding:
                        const EdgeInsets.fromLTRB(25.0, 10.5, 25.0, 11.0),
                    controller: _tabController,
                    tabs: [
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 3.0),
                          child: addTab("Movies", 0)),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 3.0),
                          child: addTab("Series", 1))
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
                      child: moviesFavourites(),
                    ),
                    Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
                        child: seriesFavourites())
                  ],
                ))
              ]),
        ),
      ),
    );
  }

  Column moviesFavourites() {
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

  Column seriesFavourites() {
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

  /// todo
  Widget addTab(String tabTitle, int tabIndex) => Tab(
      child: GestureDetector(
          onTap: () => setState(() {
                _tabController.index = tabIndex;
              }),
          child: StreaMeTab(
            tabTitle: tabTitle,
            tabIndex: tabIndex,
            tabController: _tabController,
            isWatchlist: false,
          )));
}
