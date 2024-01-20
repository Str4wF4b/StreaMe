import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/styles.dart';
import 'package:stream_me/android/app/src/widgets/features/swipe_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final ColorPalette color = ColorPalette();
  final Styles style = Styles();
  late double screenHeight;
  late double screenWidth;

  late List randomStreamList = [];
  late Streams currentStream;

  bool addFavourites = false;
  bool addWatchlist = false;

  final AppinioSwiperController _swipeCardController =
      AppinioSwiperController();

  //final bool _unswipe = false;

  @override
  void initState() {
    super.initState();

    randomStreamList = allStreams..shuffle();
    screenHeight = 0;
    screenWidth = 0;
  }

  @override
  Widget build(BuildContext context) {
    /*return AppOverlay(title: "Explore", body: buildBody(),);
  }


  Widget buildBody() {
    */
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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
                    child: AppinioSwiper(
                      cardBuilder: (BuildContext context, int index) {
                        currentStream = randomStreamList.elementAt(index);
                        return SwipeCard(
                          stream: randomStreamList.elementAt(index),
                        );
                      },
                      cardCount: allStreams.length,
                      swipeOptions: const SwipeOptions.only(
                          left: true, right: true, up: true),
                      controller: _swipeCardController,
                      maxAngle: 80,
                      loop: true,
                      //restart again if list is empty
                      onSwipeEnd: _swipe,
                      onSwipeCancelled: _swipecancel,
                      onUnSwipe: _unswipe,
                      allowUnlimitedUnSwipe: true,
                      threshold: 250,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: screenHeight * 0.033, left: 38.0, right: 41.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                  onPressed: () {
                    _swipeCardController.swipeLeft();
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          const CircleBorder()),
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          const EdgeInsets.all(16.0)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.grey.shade900),
                      overlayColor: getColor(
                          Colors.grey.shade900, Colors.deepOrangeAccent)),
                  child: const Icon(
                    Icons.close,
                    size: 29,
                    color: Colors.red,
                  ),
                ),
                  ElevatedButton(
                    onPressed: () {
                      if(!addWatchlist) {
                        _swipeCardController.swipeUp();
                      } else {
                        _watchlistActions();
                      }
                    },
                    style: style.exploreButtonStyle,
                    child: addWatchlist ?
                    Icon(
                      Icons.check_rounded,
                      size: 29,
                      color: color.bodyTextColor,
                    ) :
                    const Icon(
                      Icons.add_rounded,
                      size: 29,
                      color: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if(!addFavourites) {
                        _swipeCardController.swipeRight();
                      } else {
                        _favActions();
                      }
                    },
                    style: style.exploreButtonStyle,
                    child: Icon(
                      addFavourites ? Icons.favorite : Icons.favorite_outline,
                      size: 29,
                      color: color.bodyTextColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _swipeCardController.unswipe();
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all<CircleBorder>(
                            const CircleBorder()),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(16.0)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.grey.shade900),
                        overlayColor: getColor(
                            Colors.grey.shade900, Colors.deepOrangeAccent)),
                    child: Icon(
                      Icons.undo_outlined,
                      size: 19,
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
  SnackBar favSnackBar(String stream) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin:
          const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 7.0 + 100.0),
      //BottomAppBar has height 60.0
      duration: const Duration(milliseconds: 1500),
      content: Text(
        addFavourites
            ? '$stream removed from Favourites'
            : '$stream added to Favourites',
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

  /// A function that generates a snackbar if clicked on the plus, respectively check icon.
  /// If the icon changes to a check icon, the "added to Watchlist" snack bar is shown,
  /// if the icon changes to a plus icon, the "removed from Watchlist" snack bar is shown
  SnackBar listSnackBar(String stream) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin:
          const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 7.0 + 100.0),
      //BottomAppBar has height 60.0
      duration: const Duration(milliseconds: 1500),
      content: Text(
        addWatchlist
            ? "$stream removed from Watchlist"
            : "$stream added to Watchlist",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

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

  void _favActions(){
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(favSnackBar(currentStream.type));
    setState(() {
      addFavourites = !addFavourites;
      //TODO: Save movie/series to favourites
    });
  }

  void _watchlistActions(){
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(listSnackBar(currentStream.type));
    setState(() {
      addWatchlist = !addWatchlist;
      //TODO: Save film to watchlist
    });
  }

  void _swipe(int previousIndex, int targetIndex, SwiperActivity activity) {
    switch (activity) {
      case Swipe():
        print("Swiped: ${activity.direction}");
        if (activity.direction == AxisDirection.right) {
          _favActions();
        }
        if (activity.direction == AxisDirection.up) {
          _watchlistActions();
        }
        break;
      case Unswipe():
      // TODO: Handle this case.
        print("unswipe");
      case CancelSwipe():
      // TODO: Handle this case.
        print("cancel swipe");
        break;
      case DrivenActivity():
      // TODO: Handle this case.
    }
  }


  void _unswipe(SwiperActivity? swiperActivity) {
     // TODO: remove from watchlist and fav when unswipe
    print("unswipe");

  }

  void _swipecancel(SwiperActivity? swiperActivity) {
    print("cancel");

  }
}
