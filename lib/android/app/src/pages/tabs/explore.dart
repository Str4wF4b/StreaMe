import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/services/functions/favourites_data.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/functions/watchlist.data.dart';
import 'package:stream_me/android/app/src/services/models/favourites_model.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
import 'package:stream_me/android/app/src/services/models/watchlist_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/styles.dart';
import 'package:stream_me/android/app/src/widgets/features/swipe_card.dart';

class ExplorePage extends StatefulWidget {
  final bool fromHomeButton;

  const ExplorePage({Key? key, required this.fromHomeButton}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  final ColorPalette color = ColorPalette();
  final Styles style = Styles();
  late double screenHeight;
  late double screenWidth;

  late List randomStreamList = [];
  late Streams currentStream;

  //bool _buttonReady = false;

  final AppinioSwiperController _swipeCardController =
      AppinioSwiperController();

/*  late final AnimationController _exploreAnimation; */
  bool _fromHomeButton = false;

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final UserData _userRepo = UserData();
  final FavouritesData _favouritesRepo = FavouritesData();
  final WatchlistData _watchlistRepo = WatchlistData();
  List favourites = [];
  List watchlistStreams = [];
  late FavouritesModel favourite;
  late WatchlistModel watchlist;
  late bool _addFavourites =
      false; // flag to trigger the favourites button option
  late bool _addWatchlist =
      false; // flag to trigger the watchlist button option

  @override
  void initState() {
    /*Future.delayed(const Duration(seconds: 1)).then((_) {
      _shakeCard();
    });*/
    super.initState();
    getFavourites();
    getWatchlistStreams();
    randomStreamList = allStreams..shuffle();
    currentStream = randomStreamList.elementAt(0);
    screenHeight = 0;
    screenWidth = 0;
    _fromHomeButton = widget.fromHomeButton;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    //print(currentStream.title);

    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        color: color.middleBackgroundColor,
        //height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(left: 18.0, right: 15.0, top: 5.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Padding(
                      padding: const EdgeInsets.all(21.5),
                      child: AppinioSwiper(
                        cardBuilder: (context, index) {
                          getFavourites();
                          getWatchlistStreams();
                          int? currentIndex = _swipeCardController.cardIndex;
                          currentIndex ??=
                              0; // if null, index = 0 (first index)
                          currentStream =
                              randomStreamList.elementAt(currentIndex);

                          favourite = FavouritesModel(
                              streamId: currentStream.id.toString(),
                              title: currentStream.title,
                              type: currentStream.type,
                              rating: favourites.isEmpty
                                  ? 1
                                  : 4.5); /*(favourites.isEmpty && !_addFavourites)
                                  ? 1
                                  : (_addFavourites ? favourites
                                      .where((favourite) {
                                        print("---------------------- ${favourite.title} -- ${currentStream.title}");
                                        return favourite.streamId == currentStream.id;
                                      }).single.rating : 4.5));*/ // until await is not finished, return default value 1
                          watchlist = WatchlistModel(
                              streamId: currentStream.id.toString(),
                              title: currentStream.title,
                              type: currentStream.type,
                              rating: watchlistStreams.isEmpty ? 1 : 4.5);
                          return SwipeCard(
                            stream: randomStreamList.elementAt(index),
                          );
                        },
                        cardCount: randomStreamList.length,
                        swipeOptions: const SwipeOptions.only(
                            left: true, right: true, up: true),
                        controller: _swipeCardController,
                        maxAngle: 80,
                        loop: true,
                        //restart again if list is empty
                        onSwipeEnd: _swipe,
                        onUnSwipe: _unswipe,
                        allowUnlimitedUnSwipe: true,
                        //onSwipeCancelled: _swipeCancel,
                        threshold: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: screenHeight * 0.073, left: 38.0, right: 41.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //if (_buttonReady) {
                      _swipeCardController.swipeLeft();
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      //}
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(
                            const CircleBorder()),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(16.0)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade900),
                        elevation: MaterialStateProperty.all<double>(0.0),
                        overlayColor:
                            getColor(Colors.grey.shade900, Colors.redAccent)),
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: color.bodyTextColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      watchlistActions(watchlist, currentStream);
                    },
                    style: style.exploreButtonStyle,
                    child: Icon(
                      _addWatchlist
                          ? Icons.playlist_add_check
                          : Icons.playlist_add,
                      size: 30,
                      color: color.bodyTextColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      favouriteActions(favourite, currentStream);
                    },
                    style: style.exploreButtonStyle,
                    child: Icon(
                      _addFavourites ? Icons.favorite : Icons.favorite_outline,
                      size: 30,
                      color: color.bodyTextColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _swipeCardController.unswipe();
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(
                            const CircleBorder()),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(16.0)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade900),
                        elevation: MaterialStateProperty.all<double>(0.0),
                        overlayColor: getColor(
                            Colors.grey.shade900, Colors.orangeAccent)),
                    child: Icon(
                      Icons.undo_outlined,
                      size: 30,
                      color: color.bodyTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  /// A function that generates a snackbar if clicked on the heart icon.
  /// If the heart is filled, the "added to Favourites" snack bar is shown,
  /// if not, the "removed from Favourites" snack bar is shown
  /// stream:
  SnackBar favSnackBar(String stream) => SnackBar(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          left: 28.0,
          right: 28.0,
          bottom: _fromHomeButton ? 4.0 : 64.0 /* 6.0*/),
      //BottomAppBar has height 60.0
      duration: const Duration(milliseconds: 1500),
      content: Text(
        _addFavourites
            ? "$stream removed from Favourites"
            : "$stream added to Favourites",
        style: TextStyle(color: color.bodyTextColor),
        textAlign: TextAlign.center,
      ));

  /// A function that generates a snackbar if clicked on the plus, respectively check icon.
  /// If the icon changes to a check icon, the "added to Watchlist" snack bar is shown,
  /// if the icon changes to a plus icon, the "removed from Watchlist" snack bar is shown
  /// stream:
  SnackBar watchlistSnackBar(String stream) => SnackBar(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          left: 28.0,
          right: 28.0,
          bottom: _fromHomeButton ? 4.0 : 64.0 /* 6.0*/),
      //BottomAppBar has height 60.0
      duration: const Duration(milliseconds: 1500),
      content: Text(
        _addWatchlist
            ? "$stream removed from Watchlist"
            : "$stream added to Watchlist",
        style: TextStyle(color: color.bodyTextColor),
        textAlign: TextAlign.center,
      ));

  /// A function
  MaterialStateProperty<Color> getColor(Color color, Color pressedColor) {
    getColor(Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return pressedColor;
      } else {
        return color;
      }
    }

    return MaterialStateProperty.resolveWith(getColor);
  }

  ///
  ///
  ///
  void _swipe(int previousIndex, int targetIndex, SwiperActivity activity) {
    double threshold = 100.0;
    if (activity.direction == AxisDirection.right &&
        activity.currentOffset >= Offset(threshold, 0)) {
      //check Offset to avoid _shakeCard() to add it automatically to Favourites and make Offset same as threshold
      print(activity.direction);
      favouriteActions(favourite, currentStream);
    }

    if (activity.direction == AxisDirection.up &&
        activity.currentOffset <= Offset(0, -threshold)) {
      //check Offset to avoid _shakeCard() to add it automatically to Watchlist and make Offset same as threshold
      print(activity.direction);
      watchlistActions(watchlist, currentStream);
    }
  }

  /// A function to unswipe a card
  void _unswipe(SwiperActivity? swiperActivity) {}

  /// A function that fetches the favourite movies and series of a user
  getFavourites() async {
    UserModel user = await getUserProfileData();
    String? id = user.id; // get user's id for Favourites list

    favourites = await _favouritesRepo.getFavourites(id!);

    if (mounted) {
      setState(() {
        _addFavourites = favourites
            .where((favourite) => favourite.title == currentStream.title)
            .isNotEmpty;
      });
    }
  }

  /// A function that fetches the Watchlist movies and series of a user
  getWatchlistStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id; // get user's id for Favourites list

    watchlistStreams = await _watchlistRepo.getWatchlist(id!);

    if (mounted) {
      setState(() {
        _addWatchlist = watchlistStreams
            .where((watchlistStream) =>
                watchlistStream.title == currentStream.title)
            .isNotEmpty;
      });
    }
  }

  /// A function that handles the Favourites actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to its Favourites
  /// favourite: The current stream that will be added or removed from the user's Favourites list
  /// stream: The current stream
  void favouriteActions(FavouritesModel favourite, Streams stream) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(favSnackBar(currentStream
          .type)); // show Snackbar when adding a stream to Favourites list

    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

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
  }

  /// A function that handles the Watchlist actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to his Watchlist
  /// watchlist: The current stream that will be added or removed from the user's Watchlist
  void watchlistActions(WatchlistModel watchlist, Streams stream) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(watchlistSnackBar(currentStream
          .type)); // show Snackbar when adding or removing a stream to Watchlist

    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

    setState(() {
      _addWatchlist = !_addWatchlist;
    });

    _addWatchlist
        ? await _watchlistRepo.addToWatchlist(id!,
            watchlist) // if clicked on unchecked (add) list, i.e. _addWatchlist = true => add to Watchlist
        : await _watchlistRepo.removeFromWatchlist(
            id!,
            stream.id
                .toString()); // if clicked on checked list, i.e. _addWatchlist = false => remove from Watchlist
  }

  /// A function to fetch the current user's data
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

/*Future<void> _shakeCard() async {
    const double distance = 3;

    await shakeDirection(const Offset(0, -distance), 200); //shake card up
    await shakeDirection(const Offset(0, 0), 200); //shake card to center
    await shakeDirection(const Offset(-distance, 0), 200); //shake card left
    await shakeDirection(const Offset(distance, 0), 400); //shake card right
    await shakeDirection(
        const Offset(0, 0), 200); //animate back manually to center

    _buttonReady =
    true; //After the quick animation the card can be cancel swiped
  }

  Future<void> shakeDirection(Offset offset, int ms) async {
    await _swipeCardController.animateTo(
      offset,
      duration: Duration(milliseconds: ms),
      curve: Curves.easeInOut,
    );
  }*/
}
