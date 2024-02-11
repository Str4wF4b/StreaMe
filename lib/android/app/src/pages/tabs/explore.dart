import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/styles.dart';
import 'package:stream_me/android/app/src/widgets/features/swipe_card.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

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

    Future.delayed(const Duration(seconds: 1)).then((_) {
      _shakeCard();
    });
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
                    child: Padding(
                      padding: const EdgeInsets.all(21.5),
                      child: AppinioSwiper(
                        cardBuilder: (context, index) {
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
                        onUnSwipe: _unswipe,
                        allowUnlimitedUnSwipe: true,
                        //onSwipeCancelled: _swipeCancel,
                        //threshold: 250,
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
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(listSnackBar(currentStream.type));
                      setState(() {
                        addWatchlist = !addWatchlist;
                        //TODO: Save film to watchlist
                      });
                    },
                    style: style.exploreButtonStyle,
                    child: Icon(
                      addWatchlist ? Icons.check_rounded : Icons.add_rounded,
                      size: 39,
                      color: color.bodyTextColor,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(favSnackBar(currentStream.type));
                      setState(() {
                        addFavourites = !addFavourites;
                        //TODO: Save film to favourites
                      });
                    },
                    style: style.exploreButtonStyle,
                    child: Icon(
                      addFavourites ? Icons.favorite : Icons.favorite_outline,
                      size: 39,
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
                      size: 39,
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

  /**
   * A function that generates a snackbar if clicked on the heart icon.
   * If the heart is filled, the "added to Favourites" snack bar is shown,
   * if not, the "removed from Favourites" snack bar is shown
   */
  SnackBar favSnackBar(String stream) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
          left: 28.0, right: 28.0, bottom: 6.0 /* + 60.0*/),
      //BottomAppBar has height 60.0
      duration: const Duration(milliseconds: 1500),
      content: Text(
        addFavourites
            ? "$stream removed from Favourites"
            : "$stream added to Favourites",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

  /**
   * A function that generates a snackbar if clicked on the plus, respectively check icon.
   * If the icon changes to a check icon, the "added to Watchlist" snack bar is shown,
   * if the icon changes to a plus icon, the "removed from Watchlist" snack bar is shown
   */
  SnackBar listSnackBar(String stream) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
          left: 28.0, right: 28.0, bottom: 6.0 /* + 60.0*/),
      //BottomAppBar has height 60.0
      duration: const Duration(milliseconds: 1500),
      content: Text(
        addWatchlist
            ? "$stream removed from Watchlist"
            : "$stream added to Watchlist",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

  /**
   * A function
   */
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

  void _swipe(int previousIndex, int targetIndex, SwiperActivity activity) {
    if (activity.direction == AxisDirection.right &&
        activity.currentOffset != const Offset(3, 0)) { //check Offset to avoid _shakeCard() to add it automatically to Favourites
      print(activity.direction);
      addToFavourites();
    }
    if (activity.direction == AxisDirection.up&&
        activity.currentOffset != const Offset(0, -3)) { //check Offset to avoid _shakeCard() to add it automatically to Watchlist
      print(activity.direction);
      addToWatchlist();
    }
  }

  void checkSwipeDirection(AppinioSwiperController swipeCardController) {
    //if (swipeCardController.swipe)
    //if left: nothing, card flies out
    //if right: load last card
    //if undo button: same as right
  }

  void _unswipe(SwiperActivity? swiperActivity) {
    //if pressed Undo-Button then unswipe, else do nothing
    //if (unswiped) {
    //  _swipeCardController.unswipe();
    //}
  }

  void _swipeCancel(SwiperActivity? swiperActivity) {
    print("cancel");
  }

  void addToFavourites() {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(favSnackBar(currentStream.type));
    setState(() {}

        //TODO: Save movie/series to favourites
        );
  }

  void addToWatchlist() {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(listSnackBar(currentStream.type));
    setState(() {
      //TODO: Save film to watchlist
    });
  }

  Future<void> _shakeCard() async {
    const double distance = 3;
    // We can animate back and forth by chaining different animations.
    await _swipeCardController.animateTo(
      const Offset(0, -distance), //shake card up
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await _swipeCardController.animateTo(
      const Offset(0, 0), //shake card to center
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await _swipeCardController.animateTo(
      const Offset(-distance, 0), //shake card left
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await _swipeCardController.animateTo(
      const Offset(distance, 0), //shake card right
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    // We need to animate back to the center because `animateTo` does not center
    // the card for us.
    await _swipeCardController.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
