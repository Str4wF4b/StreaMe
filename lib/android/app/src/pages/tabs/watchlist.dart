import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/features/stream_tile.dart';

import '../../widgets/global/streame_tab.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with TickerProviderStateMixin {
  ColorPalette color = ColorPalette();

  late final TabController _tabController =
      TabController(length: 5, vsync: this);

  List all = allStreams;
  List movies = allStreams
      .where((element) => (element.type.toString() == "Movie"))
      .toList();
  List series = allStreams
      .where((element) => (element.type.toString() == "Series"))
      .toList();
  List alreadyWatched =
      allStreams.where((element) => element.id < 7 && element.id > 2).toList();
  List watch =
      allStreams.where((element) => element.id < 3 || element.id > 6).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: SafeArea(
        child: Container(
          color: color.middleBackgroundColor,
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    //dividerHeight: 0.0,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    physics: const ClampingScrollPhysics(),
                    isScrollable: true,
                    labelColor: color.backgroundColor,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: color.bodyTextColor,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding:
                        const EdgeInsets.fromLTRB(0.0, 10.5, 0.0, 11.0),
                    onTap: (int index) => setState(() {
                      _tabController.index = index;
                    }),
                    //TODO: Try unselectedLabelStyle: , ??
                    controller: _tabController,
                    tabs: [
                      addTab("All", 0),
                      addTab("Movies", 1),
                      addTab("Series", 2),
                      addTab("Not Watched", 3),
                      addTab("Watched", 4),
                    ],
                  )),
              Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                    SizedBox(width: 110, child: addWatchlistTab(all)),
                    addWatchlistTab(movies),
                    addWatchlistTab(series),
                    addWatchlistTab(watch),
                    addWatchlistTab(alreadyWatched)
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  /// todo
  Widget addTab(String tabTitle, int tabIndex) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 3.0),
        child: Tab(
            child: StreaMeTab(
              tabTitle: tabTitle,
              tabIndex: tabIndex,
              tabController: _tabController,
              isWatchlist: true,
            )),
      );

  Padding addWatchlistTab(List list) => Padding(
        padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Streams currentStream = list.elementAt(index);
                  StreamTile currentTile = StreamTile(
                      stream: currentStream,
                      image: currentStream.image,
                      title: currentStream.title,
                      year: currentStream.year,
                      pg: currentStream.pg,
                      rating: 4.7,
                      cast: currentStream.cast,
                      provider: currentStream.provider);

                  if (currentStream == list.last &&
                      currentStream != list.first) {
                    return currentTile;
                  } else {
                    return Column(
                      children: [currentTile, const SizedBox(height: 20)],
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
}
