import 'dart:async';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/services/functions/favourites_data.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/favourites_model.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';

import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../widgets/features/stream_tile.dart';
import '../../widgets/global/streame_tab.dart';

class FavouritesPage extends StatefulWidget {
  final bool fromHomeButton;

  const FavouritesPage({super.key, required this.fromHomeButton});

  @override
  State<FavouritesPage> createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage>
    with TickerProviderStateMixin {
  final ColorPalette _color = ColorPalette();

  late final TabController _tabController =
      TabController(length: 2, vsync: this);

  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();
  final _favouritesRepo = FavouritesData();
  late bool _addFavourites =
      true; // true because it's already in the Favourites list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: Scaffold(
        backgroundColor: _color.middleBackgroundColor,
        body: SafeArea(
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                physics: const ClampingScrollPhysics(),
                dividerHeight: 0.0,
                labelColor: _color.backgroundColor,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: _color.bodyTextColor,
                ),
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding:
                    const EdgeInsets.fromLTRB(25.0, 10.5, 25.0, 10.5),
                onTap: (int index) {
                  _tabController.index = index;
                },
                /*setState(() {
                  _tabController.index = index;
                })*/
                controller: _tabController,
                tabs: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 3.0),
                      child: favouritesTab("Movies", 0)),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 3.0),
                      child: favouritesTab("Series", 1))
                ],
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
                  child: favouriteTabColumn("Movie"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 5.0),
                  child: favouriteTabColumn("Series"),
                )
              ],
            ))
          ]),
        ),
      ),
    );
  }

  /// A function that adds the 2 tabs of the Favourites TabBar
  /// tabTitle: The title of the tab (Movie or Series)
  /// tabIndex: The index of the tab (0 or 1)
  Widget favouritesTab(String tabTitle, int tabIndex) => Tab(
        child: StreaMeTab(
            tabTitle: tabTitle,
            tabIndex: tabIndex,
            tabController: _tabController,
            isWatchlist: false),
      );

  /// A function that fetches the user's Favourite list
  getFavouriteStreams() async {
    UserModel user = await getUserProfileData();
    print("------ ${user.id}");
    String? id = user.id;
    print(_favouritesRepo.getFavourites(id!));
    return _favouritesRepo.getFavourites(id);
  }

  /// A function to fetch the current user's data
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

  /// A function that returns the Movies and Series columns inside the tabs
  /// type: The type of the current Tab (Movie or Series)
  Column favouriteTabColumn(String type) {
    List typeList = allStreams
        .where((element) => (element.type.toString() == type))
        .toList();
    return Column(
      children: [
        Expanded(
          child: FutureBuilder(
            future: getFavouriteStreams(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<FavouritesModel> favourites = snapshot.data
                      as List<FavouritesModel>; // List of all saved Favourites

                  typeList =
                      typeList // Check full movies or series list if movie or series is in user's Favourites list
                          .where((stream) => favourites.any((favouriteStream) =>
                              stream.type == type && // check corresponding type to add Stream to Movies or Series Tab
                              stream.id.toString() == favouriteStream.streamId))
                          .toList();

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
                            FavouritesModel favourite = FavouritesModel(
                                streamId: currentStream.id.toString(),
                                title: currentStream.title,
                                type: currentStream.type,
                                rating: favourites.elementAt(index).rating);
                            StreamTile currentTile = StreamTile(
                                stream: currentStream,
                                image: currentStream.image,
                                title: currentStream.title,
                                year: currentStream.year,
                                pg: currentStream.pg,
                                rating: favourites.elementAt(index).rating,
                                //TODO
                                cast: currentStream.cast,
                                provider: currentStream.provider,
                                fromHomeButton: widget.fromHomeButton,
                                onPressed: () async {
                                  favouriteActions(favourite, currentStream);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
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
                          }));
                } else {
                  return const Center(
                      child: Text(
                          "Something went wrong! Please try to login again."));
                }
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent));
              }
            },
          ),
        ),
      ],
    );
  }

  /// A function that handles the Favourites actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to its Favourites
  /// favourite: The current stream that will be added or removed from the user's Favourites list
  /// stream: The current stream
  void favouriteActions(FavouritesModel favourite, Streams stream) async {
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
      _addFavourites = !_addFavourites;
    });

    _addFavourites
        ? await _favouritesRepo.addToFavourites(id!,
            favourite) // if clicked on empty heart, i.e. _addFavourites = true => add to Favourites
        : await _favouritesRepo.removeFromFavourites(
            id!,
            stream.id
                .toString()); // if clicked on full heart, i.e. _addFavourites = false => remove from Favourites

    _addFavourites = true;
  }

  /// A function that shows a Snackbar if the user removes the movie from his Favourites list by clicking on the icon of the Stream tile inside Favourites-Tab
  /// type: The type of the current stream (Movie or Series)
  /// favourite: The current stream that will has been removed from the user's Favourites list
  /// id: The id of the current user
  removedSnackBar(String type, FavouritesModel favourite, String id) {
    if (_addFavourites) {
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
                "$type removed from Favourites.",
                style: TextStyle(color: _color.bodyTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => undoFavRemoved(favourite, id),
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

  /// A function that allows the user to undo the action of removing a movie or series from his Favourites list
  /// favourite: The current stream that will has been removed from the user's Favourites list
  /// id: The id of the current user
  undoFavRemoved(FavouritesModel favourite, String id) async {
    // If clicked on "Undo", i.e. _addFavourites = true => add to Favourites again:
    await _favouritesRepo.addToFavourites(id, favourite).then((value) =>
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()); // to avoid double clicks, remove Snackbar after clicking "Undo"

    setState(() {
      _addFavourites = true;
    });
  }
}
