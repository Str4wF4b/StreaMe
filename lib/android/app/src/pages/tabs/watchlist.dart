import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/functions/watchlist.data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
import 'package:stream_me/android/app/src/services/models/watchlist_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/features/stream_tile.dart';

import '../../widgets/global/streame_tab.dart';

class WatchlistPage extends StatefulWidget {
  final bool fromHomeButton;

  const WatchlistPage({super.key, required this.fromHomeButton});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with TickerProviderStateMixin {
  final ColorPalette _color = ColorPalette();

  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();
  final _watchlistRepo = WatchlistData();
  late bool _addWatchlist = true; // true because it's already in the Watchlist

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
      backgroundColor: _color.backgroundColor,
      body: SafeArea(
        child: Container(
          color: _color.middleBackgroundColor,
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
                    labelColor: _color.backgroundColor,
                    unselectedLabelColor: Colors.grey,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: _color.bodyTextColor,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding:
                        const EdgeInsets.fromLTRB(0.0, 10.5, 0.0, 11.0),
                    onTap: (int index) => //setState(() {
                        _tabController.index = index,
                    //}),
                    controller: _tabController,
                    tabs: [
                      watchlistTab("All", 0),
                      watchlistTab("Movies", 1),
                      watchlistTab("Series", 2)
                    ],
                  )),
              Expanded(
                  child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                    SizedBox(width: 110, child: watchlistTabColumn("All")),
                    watchlistTabColumn("Movie"),
                    watchlistTabColumn("Series")
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  /// A function that adds the 3 tabs of the Watchlist TabBar
  /// tabTitle: The title of the tab (All, Movie or Series)
  /// tabIndex: The index of the tab (0, 1 or 2)
  Widget watchlistTab(String tabTitle, int tabIndex) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 3.0),
        child: Tab(
            child: StreaMeTab(
                tabTitle: tabTitle,
                tabIndex: tabIndex,
                tabController: _tabController,
                isWatchlist: true)),
      );


  /// A function that returns the All, Movies and Series columns inside the tabs
  /// type: The type of the current Tab (Movie or Series)
  Padding watchlistTabColumn(String type) {
    List typeList = allStreams;
    if (!(type == "All")) {
      typeList = allStreams
          .where((element) => (element.type.toString() == type))
          .toList();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getWatchlistStreams(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<WatchlistModel> watchlistStreams =
                        snapshot.data as List<WatchlistModel>;

                    if (!(type == "All")) {
                      typeList =
                          typeList // Check full movies or series list if movie or series is in user's Watchlist
                              .where((stream) => watchlistStreams.any(
                                  (watchlistStream) =>
                                      stream.type == type && // check corresponding type to add Stream to Movies or Series Tab
                                      stream.id.toString() ==
                                          watchlistStream.streamId))
                              .toList();
                    } else {
                      typeList = typeList.where((stream) => watchlistStreams.any(
                              (watchlistStream) =>
                                  stream.id.toString() ==
                                  watchlistStream.streamId)).toList();
                    }

                    return CustomRefreshIndicator(
                      onRefresh: () {
                        setState(() {});
                        return Future.delayed(
                            const Duration(milliseconds: 1200));
                      },
                      builder: MaterialIndicatorDelegate(
                          builder: (context, controller) {
                        return Icon(
                          Icons.camera,
                          color: _color.backgroundColor,
                          size: 30,
                        );
                      }),
                      child: ListView.builder(
                        itemCount: typeList.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Streams currentStream = typeList.elementAt(index);
                          WatchlistModel watchlist = WatchlistModel(
                              streamId: currentStream.id.toString(),
                              title: currentStream.title,
                              type: currentStream.type,
                              rating: watchlistStreams.elementAt(index).rating);
                          StreamTile currentTile = StreamTile(
                              stream: currentStream,
                              image: currentStream.image,
                              title: currentStream.title,
                              year: currentStream.year,
                              pg: currentStream.pg,
                              rating: 4.7,
                              cast: currentStream.cast,
                              provider: currentStream.provider,
                              fromHomeButton: widget.fromHomeButton,
                              onPressed: () {watchlistActions(watchlist, currentStream);},
                              icon: Icon(
                                Icons.playlist_add_check,
                                color: Colors.green.shade600,
                              ));

                          if (currentStream == typeList.last &&
                              currentStream != typeList.first) {
                            return currentTile;
                          } else {
                            return Column(
                              children: [
                                currentTile,
                                const SizedBox(height: 20)
                              ],
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    return const Center(
                        child: Text(
                            "Something went wrong! Please try to login again."));
                  }
                } else {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Colors.blueAccent));
                }
              },
            ),
          )
        ],
      ),
    );
  }

  /// A function that fetches the user's Watchlist
  getWatchlistStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id;
    return _watchlistRepo.getWatchlist(id!);
  }

  /// A function to fetch the current user's data
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

  /// A function that handles the Favourites actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to its Favourites
  /// favourite: The current stream that will be added or removed from the user's Favourites list
  /// stream: The current stream
  void watchlistActions(WatchlistModel favourite, Streams stream) async {
    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

    if (mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(removedSnackBar(stream.type, favourite,
            id!)); // show Snackbar when adding or removing a stream to Favourites list
    }

    setState(() {
      _addWatchlist = !_addWatchlist;
    });

    _addWatchlist
        ? await _watchlistRepo.addToWatchlist(id!,
        favourite) // if clicked on empty heart, i.e. _addFavourites = true => add to Favourites
        : await _watchlistRepo.removeFromWatchlist(
        id!,
        stream.id
            .toString()); // if clicked on full heart, i.e. _addFavourites = false => remove from Favourites

    _addWatchlist = true;
  }

  /// A function that shows a Snackbar if the user removes the movie from his Watchlist by clicking on the icon of the Stream tile inside Watchlist-Tab
  /// type: The type of the current stream (Movie or Series)
  /// watchlist: The current stream that will has been removed from the user's Watchlist
  /// id: The id of the current user
  removedSnackBar(String type, WatchlistModel watchlist, String id) {
    if (_addWatchlist) {
      return SnackBar(
          elevation: 0.0,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(
              left: 28.0,
              right: 28.0,
              bottom: widget.fromHomeButton ? 4.0 : 64.0),
          duration: const Duration(milliseconds: 2500),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$type removed from Watchlist.",
                style: TextStyle(color: _color.bodyTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => undoWatchlistRemoved(watchlist, id),
                child: const Text("Undo.",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        //decoration: TextDecoration.underline,
                        decorationColor: Colors.blueAccent)),
              )
            ],
          ));
    }
  }

  /// A function that allows the user to undo the action of removing a movie or series from his Watchlist
  /// watchlist: The current stream that will has been removed from the user's Watchlist
  /// id: The id of the current user
  undoWatchlistRemoved(WatchlistModel watchlist, String id) async {
    // If clicked on "Undo", i.e. _addFavourites = true => add to Favourites again:
    await _watchlistRepo.addToWatchlist(id, watchlist).then((value) =>
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()); // to avoid double clicks, remove Snackbar after clicking "Undo"

    setState(() {
      _addWatchlist = true;
    });
  }
}
