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
  // Utils:
  final ColorPalette _color = ColorPalette();

  // Instances:
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();
  final _watchlistRepo = WatchlistData();
  late bool _addWatchlist = true; // true because it's already in the Watchlist

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: SafeArea(
        child: Container(
          color: _color.middleBackgroundColor,
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    physics: const ClampingScrollPhysics(),
                    dividerHeight: 0.0,
                    // remove Divider below Tabs
                    labelColor: _color.backgroundColor,
                    unselectedLabelColor: Colors.grey,
                    tabAlignment: TabAlignment.start,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: _color.bodyTextColor,
                    ),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding:
                        const EdgeInsets.fromLTRB(0.0, 10.5, 0.0, 11.0),
                    onTap: (int index) => _tabController.index = index,
                    controller: _tabController,
                    isScrollable: true,
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
                    watchlistTabColumn("All"),
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
  /// type: The type of the current Tab (All, Movie or Series)
  Padding watchlistTabColumn(String type) {
    List typeList =
        allStreams; // type "All" contains both, Movies and Series, i.e. all Streams
    if (!(type == "All")) {
      typeList = allStreams
          .where((element) => (element.type.toString() == type))
          .toList(); // filter all Streams based on the type (Movies or Series) if "All"-type is already excluded
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getWatchlistStreams(),
              // fetch user's watchlist movies and series
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<WatchlistModel> watchlistStreams = snapshot.data as List<
                        WatchlistModel>; // List of all saved Watchlist Streams

                    // Filter Watchlist depending on the type (Movie or Series), don't filter if type is "All":
                    if (!(type == "All")) {
                      typeList =
                          typeList // check in type list whether the movie or series is also in the user's Watchlist
                              .where((stream) => watchlistStreams.any(
                                  (watchlistStream) =>
                                      stream.type ==
                                          type && // check corresponding type to add Stream from Watchlist to Movies or Series Tab
                                      stream.id.toString() ==
                                          watchlistStream.streamId))
                              .toList();
                    } else {
                      typeList = typeList
                          .where((stream) => watchlistStreams.any(
                              (watchlistStream) => // add any type because the type is "All"
                                  stream.id.toString() ==
                                  watchlistStream.streamId))
                          .toList();
                    }

                    typeList.sort((a, b) => a.title
                        .toString()
                        .toLowerCase()
                        .compareTo(b.title
                            .toString()
                            .toLowerCase())); // sort final type list alphabetically

                    return CustomRefreshIndicator(
                      onRefresh: () {
                        // refresh page
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
                          // Generate watchlisted Stream instance with streamId, title and type:
                          WatchlistModel watchlist = WatchlistModel(
                              streamId: currentStream.id.toString(),
                              title: currentStream.title,
                              type: currentStream.type);
                          StreamTile currentTile = StreamTile(
                              stream: currentStream,
                              image: currentStream.image,
                              title: currentStream.title,
                              year: currentStream.year,
                              pg: currentStream.pg,
                              cast: currentStream.cast,
                              provider: currentStream.provider,
                              fromHomeButton: widget.fromHomeButton,
                              onPressed: () async {
                                watchlistActions(watchlist, currentStream);
                              },
                              icon: Icon(
                                Icons.playlist_add_check,
                                color: Colors.green.shade600,
                              ));

                          if (currentStream == typeList.last &&
                              currentStream != typeList.first) {
                            // if only one element in list, return it without space below
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

  /// A function that fetches the user's Watchlist based on his id
  getWatchlistStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id;
    return _watchlistRepo.getWatchlist(id!);
  }

  /// A function that fetches the current user's data based on the email
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

  /// A function that handles the Watchlist actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to his Watchlist
  /// watchlist: The current stream that will be added or removed from the user's Watchlist
  /// stream: The current stream
  void watchlistActions(WatchlistModel watchlist, Streams stream) async {
    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

    if (mounted) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(actionsSnackBar(stream.type, watchlist,
            id!)); // show Snackbar when adding or removing a stream to or from Watchlist
    }

    setState(() {
      _addWatchlist = !_addWatchlist;
    });

    if (!_addWatchlist) {
      // if clicked on unchecked list, i.e. _addWatchlist = false => remove from Watchlist
      await _watchlistRepo.removeFromWatchlist(id!, stream.id.toString());
    }

    _addWatchlist = true;
  }

  /// A function that shows a Snackbar if the user removes the movie from his Watchlist by clicking on the icon of the Stream tile inside Watchlist-Tab
  /// type: The type of the current stream (Movie or Series)
  /// watchlist: The current stream that has been removed from the user's Watchlist
  /// id: The id of the current user
  actionsSnackBar(String type, WatchlistModel watchlist, String id) {
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
                        decorationColor: Colors.blueAccent)),
              )
            ],
          ));
    }
  }

  /// A function that allows the user to undo the action of removing a movie or series from his Watchlist
  /// watchlist: The current stream that has been removed from the user's Watchlist and should be re-added to it
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
