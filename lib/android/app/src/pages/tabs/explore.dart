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
  // Utils:
  final ColorPalette _color = ColorPalette();
  final Styles _style = Styles();

  // Instances:
  final AppinioSwiperController _swipeCardController =
      AppinioSwiperController();

  // Local Instances:
  late List _randomStreamList = [];
  late Streams _currentStream;
  late double _screenHeight;
  bool _fromHomeButton = false;
  bool _buttonActivity = false;

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final UserData _userRepo = UserData();
  final FavouritesData _favouritesRepo = FavouritesData();
  final WatchlistData _watchlistRepo = WatchlistData();
  late FavouritesModel _favourite;
  late WatchlistModel _watchlist;
  late bool _addFavourites =
      false; // flag to trigger the favourites button option
  late bool _addWatchlist =
      false; // flag to trigger the watchlist button option
  List _favouriteStreams = [];
  List _watchlistStreams = [];

  @override
  void initState() {
    super.initState();
    getFavouriteStreams();
    getWatchlistStreams();
    _randomStreamList = allStreams..shuffle();
    _currentStream = _randomStreamList.elementAt(0);
    _screenHeight = 0;
    _fromHomeButton = widget.fromHomeButton;
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight =
        MediaQuery.of(context).size.height; // get current screen height
    _addFavourites = _favouriteStreams
        .where((favourite) => favourite.title == _currentStream.title)
        .isNotEmpty;

    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        color: _color.middleBackgroundColor,
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
                      // Building stacked cards:
                      child: AppinioSwiper(
                        cardBuilder: (context, index) {
                          getFavouriteStreams();
                          getWatchlistStreams();
                          int? currentIndex = _swipeCardController.cardIndex;
                          currentIndex ??=
                              0; // if null, index = 0 (first index)
                          _currentStream =
                              _randomStreamList.elementAt(currentIndex);

                          // Generate favourited Stream instance with streamId, title and type:
                          _favourite = FavouritesModel(
                            streamId: _currentStream.id.toString(),
                            title: _currentStream.title,
                            type: _currentStream.type,
                          );

                          // Generate watchlisted Stream instance with streamId, title and type:
                          _watchlist = WatchlistModel(
                              streamId: _currentStream.id.toString(),
                              title: _currentStream.title,
                              type: _currentStream.type);
                          return SwipeCard(
                            stream: _randomStreamList.elementAt(index),
                          );
                        },
                        cardCount: _randomStreamList.length,
                        swipeOptions: const SwipeOptions.only(
                            left: true, right: true, up: true),
                        controller: _swipeCardController,
                        maxAngle: 80,
                        // the angle a swipe is possible
                        loop: true,
                        // restart again if list is empty
                        onSwipeEnd: _swipe,
                        onUnSwipe: _unswipe,
                        allowUnlimitedUnSwipe: true,
                        threshold: 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: _screenHeight * 0.073, left: 38.0, right: 41.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // The skip Button that has a left swipe effect:
                  ElevatedButton(
                    onPressed: () {
                      _swipeCardController.swipeLeft();
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
                        overlayColor:
                            getColor(Colors.grey.shade900, Colors.redAccent)),
                    child: Icon(
                      Icons.close,
                      size: 30,
                      color: _color.bodyTextColor,
                    ),
                  ),
                  // The add to Watchlist button that has an up swipe effect:
                  ElevatedButton(
                    onPressed: () {
                      watchlistActions(_watchlist, _currentStream);
                      _buttonActivity = true;
                      _swipeCardController.swipeUp();
                    },
                    style: _style.exploreButtonStyle,
                    child: Icon(
                      _addWatchlist
                          ? Icons.playlist_add_check
                          : Icons.playlist_add,
                      size: 30,
                      color: _color.bodyTextColor,
                    ),
                  ),
                  // The add to Favourites button that has an right swipe effect:
                  ElevatedButton(
                    onPressed: () async {
                      favouriteActions(_favourite, _currentStream);
                      _buttonActivity = true;
                      _swipeCardController.swipeRight();
                    },
                    style: _style.exploreButtonStyle,
                    child: Icon(
                      _addFavourites ? Icons.favorite : Icons.favorite_outline,
                      size: 30,
                      color: _color.bodyTextColor,
                    ),
                  ),
                  // The unswipe button that has an unswipe effect:
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
                      color: _color.bodyTextColor,
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

  /// A function that generates a snackbar if clicked on the heart icon
  /// if the icon changes to a filled heart, the "added to Favourites" Snackbar is shown,
  /// if the icon changes to an empty heart, the "removed from Favourites" snack bar is shown
  /// stream: The current stream whose type is shown in the Snackbar
  SnackBar favouriteSnackBar(String stream) => SnackBar(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          left: 28.0, right: 28.0, bottom: _fromHomeButton ? 4.0 : 64.0),
      duration: const Duration(milliseconds: 1500),
      content: Text(
        _addFavourites
            ? "$stream removed from Favourites"
            : "$stream added to Favourites",
        style: TextStyle(color: _color.bodyTextColor),
        textAlign: TextAlign.center,
      ));

  /// A function that generates a snackbar if clicked on the list icon
  /// if the icon changes to a checked list, the "added to Watchlist" Snackbar is shown,
  /// if the icon changes to an unchecked list, the "removed from Watchlist" Snackbar is shown
  /// stream: The current stream whose type is shown in the Snackbar
  SnackBar watchlistSnackBar(String stream) => SnackBar(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          left: 28.0, right: 28.0, bottom: _fromHomeButton ? 4.0 : 64.0),
      duration: const Duration(milliseconds: 1500),
      content: Text(
        _addWatchlist
            ? "$stream removed from Watchlist"
            : "$stream added to Watchlist",
        style: TextStyle(color: _color.bodyTextColor),
        textAlign: TextAlign.center,
      ));

  /// A function that returns a color of type MaterialStateProperty
  /// color: The color of the buttons below the stacked cards
  /// pressedColor: The color that is shown if a button below the stacked cards is pressed
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

  /// A function that handles the left, up and right swipes
  /// activity: The activity that helps to determine the swipe direction
  void _swipe(
      int previousIndex, int targetIndex, SwiperActivity activity) async {
    double threshold =
        100.0; // the minimum value a user has to move the card to make a swipe possible

    if (!_buttonActivity) {
      // Right swipe, i.e. add Stream to Favourites:
      if (activity.direction == AxisDirection.right &&
          activity.currentOffset >= Offset(threshold, 0)) {
        // offset needs to have at least the same value as threshold to enable swipe
        favouriteActions(_favourite, _currentStream);
      }

      // Up swipe, i.e. add Stream to Watchlist:
      if (activity.direction == AxisDirection.up &&
          activity.currentOffset <= Offset(0, -threshold)) {
        // offset needs to have at least the same value as threshold to enable swipe
        watchlistActions(_watchlist, _currentStream);
      }
    }

    _buttonActivity = false;
  }

  /// A function that unswipes a card to the previous card
  void _unswipe(SwiperActivity? activity) {
    int currentStreamIndex = _randomStreamList.indexWhere((element) =>
        element.title == _currentStream.title &&
        element.type == _currentStream.type); // get index of current Stream
    if (currentStreamIndex == 0) {
      // if the current index is 0, set previous index at last element in list to get the previous Stream
      _currentStream =
          _randomStreamList.elementAt(_randomStreamList.length - 1);
    } else {
      _currentStream = _randomStreamList
          .elementAt(currentStreamIndex - 1); // set index to previous Stream
    }

    _addFavourites =
        _favouriteStreams // change _addFavourites value depending on current Stream
            .where((favourite) => favourite.title == _currentStream.title)
            .isNotEmpty;

    _addWatchlist =
        _watchlistStreams // change _addWatchlist value depending on current Stream
            .where((watchlistStream) =>
                watchlistStream.title == _currentStream.title)
            .isNotEmpty;
  }

  /// A function that fetches the user's Favourite list based on his id
  getFavouriteStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id;

    _favouriteStreams = await _favouritesRepo.getFavourites(id!);

    if (mounted) {
      setState(() {
        _addFavourites = _favouriteStreams
            .where((favourite) => favourite.title == _currentStream.title)
            .isNotEmpty; // if current Stream is in Favourites list, set the Favourites-boolean to true
      });
    }
  }

  /// A function that fetches the user's Watchlist based on his id
  getWatchlistStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id;

    _watchlistStreams = await _watchlistRepo.getWatchlist(id!);

    if (mounted) {
      setState(() {
        _addWatchlist = _watchlistStreams
            .where((watchlistStream) =>
                watchlistStream.title == _currentStream.title)
            .isNotEmpty; // if current Stream is in Watchlist, set the Watchlist-boolean to true
      });
    }
  }

  /// A function that handles the Favourites actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to his Favourites
  /// favourite: The current stream that will be added or removed from the user's Favourites list
  /// stream: The current stream
  void favouriteActions(FavouritesModel favourite, Streams stream) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(favouriteSnackBar(stream
          .type)); // show Snackbar when adding or removing a stream to or from Favourites list

    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

    if (!_buttonActivity) {
      _currentStream = stream; // set to actual current Stream
      _addFavourites = _favouriteStreams
          .where((favourite) => favourite.title == _currentStream.title)
          .isNotEmpty; // if current Stream is in Favourites list, set the Favourites-boolean to true
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
                .toString()); // if clicked on filled heart, i.e. _addFavourites = false => remove from Favourites
  }

  /// A function that handles the Watchlist actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to his Watchlist
  /// watchlist: The current stream that will be added or removed from the user's Watchlist
  void watchlistActions(WatchlistModel watchlist, Streams stream) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(watchlistSnackBar(_currentStream
          .type)); // show Snackbar when adding or removing a stream to or from Watchlist

    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

    if (!_buttonActivity) {
      _currentStream = stream; // set to actual current Stream
      _addWatchlist = _watchlistStreams
          .where((watchlistStream) =>
              watchlistStream.title == _currentStream.title)
          .isNotEmpty; // if current Stream is in Watchlist, set the Watchlist-boolean to true
    }

    _addWatchlist = !_addWatchlist;

    _addWatchlist
        ? await _watchlistRepo.addToWatchlist(id!,
            watchlist) // if clicked on unchecked list, i.e. _addWatchlist = true => add to Watchlist
        : await _watchlistRepo.removeFromWatchlist(
            id!,
            stream.id
                .toString()); // if clicked on checked list, i.e. _addWatchlist = false => remove from Watchlist
  }

  /// A function that fetches the current user's data based on the email
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }
}
