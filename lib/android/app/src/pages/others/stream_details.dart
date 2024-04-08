import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_me/android/app/src/data/actor_data.dart';
import 'package:stream_me/android/app/src/data/sd_data.dart';
import 'package:stream_me/android/app/src/data/hd_data.dart';
import 'package:stream_me/android/app/src/data/uhd_data.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/model/sd_model.dart';
import 'package:stream_me/android/app/src/model/hd_model.dart';
import 'package:stream_me/android/app/src/model/uhd_model.dart';
import 'package:stream_me/android/app/src/services/functions/favourites_data.dart';
import 'package:stream_me/android/app/src/services/functions/rating_data.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/functions/watchlist.data.dart';
import 'package:stream_me/android/app/src/services/models/favourites_model.dart';
import 'package:stream_me/android/app/src/services/models/rating_model.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
import 'package:stream_me/android/app/src/services/models/watchlist_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/constants_and_values.dart';
import '../others/actor_director_details.dart';

class StreamDetailsPage extends StatefulWidget {
  final Streams stream;

  const StreamDetailsPage({super.key, required this.stream});

  @override
  State<StreamDetailsPage> createState() => _StreamDetailsPageState();
}

class _StreamDetailsPageState extends State<StreamDetailsPage>
    with TickerProviderStateMixin {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  // Instances:
  final _screenshotController =
      ScreenshotController(); // controller to manage screenshots
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  // Local instances:
  final keyRating =
      GlobalKey(); // GlobalKey to determine the size and position of the rating icon

  // Local instances:
  late bool _isAnon;
  Offset? _positionRating; // the position of the rating icon

  // Database:
  final FavouritesData _favouritesRepo = FavouritesData();
  final WatchlistData _watchlistRepo = WatchlistData();
  final RatingData _ratingRepo = RatingData();
  late bool _addFavourites =
      false; // flag to trigger the favourites button option
  late bool _addWatchlist =
      false; // flag to trigger the watchlist button option
  List _favouriteStreams = [];
  List _watchlistStreams = [];
  List _ratedStreams = [];
  double _rating = 1; // initial average rating
  double _userRating = 1; // initial user rating

  @override
  void initState() {
    _isAnon = FirebaseAuth.instance.currentUser!.isAnonymous;
    if (!_isAnon) {
      // only fetch data if user is not anonymous
      getFavouriteStreams();
      getWatchlistStreams();
      getRatings();
    }
    calculateRating(); // calculate average rating
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getRatingIconPosition();
    calculateRating();

    final Sd sdProvider =
        allSd[widget.stream.id]; // get current stream's sd platform provider
    final Hd hdProvider =
        allHd[widget.stream.id]; // get current stream's hd platform provider
    final Uhd uhdProvider =
        allUhd[widget.stream.id]; // get current stream's uhd platform provider

    // Generate favourited Stream instance with streamId, title and type:
    FavouritesModel favourite = FavouritesModel(
        streamId: widget.stream.id.toString(),
        title: widget.stream.title,
        type: widget.stream.type);

    // Generate watchlist Stream instance with streamId, title and type:
    WatchlistModel watchlist = WatchlistModel(
        streamId: widget.stream.id.toString(),
        title: widget.stream.title,
        type: widget.stream.type);

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
          backgroundColor: _color.backgroundColor,
          body: CustomRefreshIndicator(
            // refresh page
            onRefresh: () {
              setState(() {});
              return Future.delayed(const Duration(milliseconds: 1200));
            },
            builder: MaterialIndicatorDelegate(builder: (context, controller) {
              return Icon(
                Icons.camera,
                color: _color.backgroundColor,
                size: 30,
              );
            }),
            child: CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: _color.backgroundColor,
                title: FittedBox(
                    child: Text(widget.stream.title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500))),
                centerTitle: true,
                elevation: 0.0,
                scrolledUnderElevation: 0.0,
                leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: loadCoverImage(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  color: _color.backgroundColor,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      // First row with Share, Rating, add to Watchlist and add to Favourites Buttons:
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              // Share Button:
                              onPressed: () async {
                                final imgBytes =
                                    await _screenshotController.capture();
                                share(imgBytes!);
                              },
                              icon: Icon(Icons.share_rounded,
                                  color: _color.bodyTextColor, size: 28.0),
                            ),
                            Stack(children: [
                              // Rating Button + overall average Rating:
                              IconButton(
                                  onPressed: () async {
                                    if (!_isAnon) {
                                      // only handle data if user is not anonymous
                                      await makeRating(); // function for star icon
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.star,
                                    color: _color.bodyTextColor,
                                    size: 28.0,
                                    key: keyRating,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 40.0, top: 10.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (!_isAnon) {
                                      // only handle data if user is not anonymous
                                      await makeRating(); // function for rating text
                                      setState(() {});
                                    }
                                  },
                                  child: Text(_rating.toStringAsFixed(1),
                                      // show only decimal rounded number
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: _color.bodyTextColor)),
                                ),
                              )
                            ]),
                            IconButton(
                                // Add to Watchlist Button:
                                onPressed: () async {
                                  if (!_isAnon) {
                                    // only handle data if user is not anonymous
                                    watchlistActions(watchlist);
                                  }
                                },
                                icon: _isAnon
                                    ? Icon(Icons.playlist_add,
                                        color: Colors.grey.shade800, size: 34.0)
                                    : Icon(
                                        _addWatchlist
                                            ? Icons.playlist_add_check
                                            : Icons.playlist_add,
                                        color: _color.bodyTextColor,
                                        size: 34.0)),
                            IconButton(
                                // Add to Favourites Button:
                                onPressed: () async {
                                  if (!_isAnon) {
                                    // only handle data if user is not anonymous
                                    favouriteActions(favourite);
                                  }
                                },
                                icon: _isAnon
                                    ? Icon(Icons.favorite_border_outlined,
                                        color: Colors.grey.shade800, size: 32.0)
                                    : Icon(
                                        _addFavourites
                                            ? Icons.favorite
                                            : Icons.favorite_border_outlined,
                                        color: Colors.red,
                                        size: 32.0,
                                      )),
                          ],
                        ),
                      ),

                      // Second row with year, pg and seasons/duration:
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 8.0, top: 25.0),
                        child: Row(
                          children: [
                            // Year:
                            Text(
                              streamYears(widget.stream.year),
                              style: TextStyle(
                                  color: _color.bodyTextColor, fontSize: 18),
                            ),
                            const SizedBox(width: 25.0),
                            // PG:
                            ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.2, 0.0, 2.2, 0.0),
                                  height: 23,
                                  width: 35.5,
                                  color: Colors.grey.shade400,
                                  child: Text(
                                    widget.stream.pg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _color.backgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        height: _cav.textHeight),
                                  ),
                                )),
                            const SizedBox(width: 25.0),
                            // Seasons / Duration:
                            Text(
                              widget.stream.seasonOrDuration,
                              style: TextStyle(
                                  color: _color.bodyTextColor, fontSize: 18),
                            )
                          ],
                        ),
                      ),

                      // Third row with genres:
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            // Genres:
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  divideGenres(),
                                  style: TextStyle(
                                      color: _color.bodyTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Fourth row with plot:
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 18.0),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return ExpandText(widget.stream.plot,
                                style: TextStyle(
                                    color: _color.bodyTextColor,
                                    fontSize: MediaQuery.textScalerOf(context)
                                        .scale(16),
                                    height: _cav.textHeight),
                                indicatorIcon: Icons.keyboard_arrow_down,
                                indicatorIconColor: Colors.grey.shade400,
                                indicatorPadding:
                                    const EdgeInsets.only(bottom: 1.0),
                                maxLines: 6,
                                expandIndicatorStyle:
                                    ExpandIndicatorStyle.icon);
                          })),

                      // Fifth row with cast:
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 15.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  "Cast:",
                                  style: TextStyle(
                                      color: _color.bodyTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  height: 50,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: widget.stream.cast.length,
                                      itemBuilder: (context, index) {
                                        final actor = widget.stream.cast[index];
                                        return castAndDirectorButton(actor);
                                      }),
                                ),
                              ),
                            ],
                          )),

                      // Sixth row with directors:
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Text(
                                "Directed by:",
                                style: TextStyle(
                                    color: _color.bodyTextColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                color: Colors.transparent,
                                height: 50,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: widget.stream.direction.length,
                                    itemBuilder: (context, index) {
                                      final director =
                                          widget.stream.direction[index];
                                      return castAndDirectorButton(director);
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Last row with streaming providers:
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 30.0, right: 15.0),
                        // Streaming providers:
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Available on:",
                                  style: TextStyle(
                                      color: _color.bodyTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  // Container that includes the 3 Tabs SD, HD and 4k and its streaming providers
                                  decoration: BoxDecoration(
                                    color: _color.middleBackgroundColor,
                                    border: Border.all(
                                        width: 1.0,
                                        color: _color.bodyTextColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Column(
                                      children: [
                                        // 3 Tabs on top:
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: SizedBox(
                                            height: 40,
                                            child: TabBar(
                                              controller: _tabController,
                                              indicator:
                                                  const UnderlineTabIndicator(
                                                borderSide: BorderSide(
                                                    width: 3.0,
                                                    color: Colors.blueAccent),
                                                insets: EdgeInsets.symmetric(
                                                    horizontal: 49),
                                              ),
                                              indicatorPadding:
                                                  const EdgeInsets.only(
                                                      left: 7.0,
                                                      right: 7.0,
                                                      bottom: 4.0),
                                              labelColor: Colors.white,
                                              unselectedLabelColor: Colors.grey,
                                              dividerHeight: 0.0,
                                              tabs: const [
                                                Tab(
                                                  text: "SD",
                                                ),
                                                Tab(text: "HD"),
                                                Tab(
                                                  text: "4k",
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Content of the 3 Tabs:
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              7.0, 7.0, 7.0, 20.0),
                                          child: Container(
                                            color: Colors.transparent,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.54,
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                // First Tab (SD Streams):
                                                Column(
                                                  children: [
                                                    providerRow(
                                                        "Stream on:",
                                                        sdProvider
                                                            .streamOn["Logo"],
                                                        sdProvider.streamOn[
                                                            "Platform"],
                                                        sdProvider
                                                            .streamOn["Link"]),
                                                    const SizedBox(height: 30),
                                                    providerRow(
                                                        "Rent:",
                                                        sdProvider.rent["Logo"],
                                                        sdProvider
                                                            .rent["Platform"],
                                                        sdProvider
                                                            .rent["Link"]),
                                                    const SizedBox(height: 30),
                                                    providerRow(
                                                        "Buy:",
                                                        sdProvider.buy["Logo"],
                                                        sdProvider
                                                            .buy["Platform"],
                                                        sdProvider.buy["Link"])
                                                  ],
                                                ),
                                                // Second Tab (HD Streams):
                                                Column(
                                                  children: [
                                                    providerRow(
                                                        "Stream on:",
                                                        hdProvider
                                                            .streamOn["Logo"],
                                                        hdProvider.streamOn[
                                                            "Platform"],
                                                        hdProvider
                                                            .streamOn["Link"]),
                                                    const SizedBox(height: 30),
                                                    providerRow(
                                                        "Rent:",
                                                        hdProvider.rent["Logo"],
                                                        hdProvider
                                                            .rent["Platform"],
                                                        hdProvider
                                                            .rent["Link"]),
                                                    const SizedBox(height: 30),
                                                    providerRow(
                                                        "Buy:",
                                                        hdProvider.buy["Logo"],
                                                        hdProvider
                                                            .buy["Platform"],
                                                        hdProvider
                                                            .buy["Platform"])
                                                  ],
                                                ),
                                                // Third Tab (4k Streams):
                                                Column(
                                                  children: [
                                                    providerRow(
                                                        "Stream on:",
                                                        uhdProvider
                                                            .streamOn["Logo"],
                                                        uhdProvider.streamOn[
                                                            "Platform"],
                                                        uhdProvider
                                                            .streamOn["Link"]),
                                                    const SizedBox(height: 30),
                                                    providerRow(
                                                        "Rent:",
                                                        uhdProvider
                                                            .rent["Logo"],
                                                        uhdProvider
                                                            .rent["Platform"],
                                                        uhdProvider
                                                            .rent["Link"]),
                                                    const SizedBox(height: 30),
                                                    providerRow(
                                                        "Buy:",
                                                        uhdProvider.buy["Logo"],
                                                        uhdProvider
                                                            .buy["Platform"],
                                                        uhdProvider.buy["Link"])
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ]),
          )),
    );
  }

  /// A function that calculates the average rating of the current stream in real time
  calculateRating() async {
    List<RatingModel> ratedStreams = await _ratingRepo.getAllStreamRatings(
        widget.stream.id.toString()); // get all Rating instances
    List<double> streamRatings = [];

    for (var stream in ratedStreams) {
      streamRatings
          .add(stream.rating); // fill the ratings list with all ratings
    }

    int numberOfRatings = streamRatings.length;
    double sum = streamRatings.fold(
        0.0,
        (previousValue, element) =>
            previousValue! + element); // sum up all ratings

    if (numberOfRatings != 0) {
      _rating = (sum /
          numberOfRatings); // set the average rating if at least one rating is submitted
    } else {
      _rating = 0.0;
    }
  }

  /// A function that enables the user to submit a rating and after, calculates the new average rating
  Future makeRating() {
    calculateRating(); // calculate current ratings
    _userRating = getUserRating(); // get current user rating

    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => Stack(
                children: [
                  // Custom user rating:
                  Positioned(
                    top: _positionRating?.dy,
                    child: SizedBox(
                        width: 370.0,
                        // Enable user rating input inside a new Dialog:
                        child: Dialog(
                          backgroundColor: _color.backgroundColor,
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: _color.bodyTextColor)),
                          insetPadding:
                              const EdgeInsets.only(left: 125.0, top: 10.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        10.0, 8.0, 6.0, 5.0),
                                    child: RatingBar.builder(
                                      minRating: 1,
                                      maxRating: 5,
                                      initialRating: getUserRating(),
                                      allowHalfRating: true,
                                      itemSize: 32.0,
                                      itemPadding: const EdgeInsets.all(2.0),
                                      glowColor: Colors.blueAccent,
                                      glowRadius: 3.0,
                                      updateOnDrag: true,
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          _userRating =
                                              rating; // save the new user rating
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 5.0),
                                      child: Text("$_userRating",
                                          // show new rating of user
                                          style: TextStyle(
                                              color: Colors.grey.shade300,
                                              fontSize: 19,
                                              fontWeight: FontWeight.w600)))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // The Button to submit the user's rating for new average rating calculation:
                                  IconButton(
                                    onPressed: () {
                                      // Generate rating Stream instance with streamId, title, type and rating:
                                      RatingModel ratedStream = RatingModel(
                                          streamId: widget.stream.id.toString(),
                                          title: widget.stream.title,
                                          type: widget.stream.type,
                                          rating: _userRating);
                                      saveUserRating(ratedStream,
                                          _ratedStreams); // add or update user's rating for current stream
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.check_circle_rounded,
                                        size: 30, color: Colors.green.shade700),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ));
  }

  /// A function that checks and fetches the user's rating for the current stream
  getUserRating() {
    bool noRating = _ratedStreams
        .where((ratedStream) =>
            ratedStream.streamId == widget.stream.id.toString())
        .isEmpty; // boolean that indicates if the current stream is in the user's rated streams

    if (!noRating) {
      // if user has rated the stream, fetch his rating
      RatingModel streamRating = _ratedStreams
          .where((ratedStream) =>
              ratedStream.streamId == widget.stream.id.toString())
          .single;

      return streamRating.rating;
    } else {
      // if not, return a constant value
      return 1.0;
    }
  }

  /// A function that adds or updates a movie or series in the user's Rating-collection
  /// rating: The RatingModel which contains the user's (new) rating for the current stream
  /// ratedStreams: The list of the user's rated streams
  saveUserRating(RatingModel rating, List ratedStreams) async {
    getRatings(); // fetch all current ratings
    UserModel user = await getUserProfileData();
    String? userId =
        user.id; // get user's id for adding a rating to a movie or series
    bool isAlreadyRated = false;

    if (ratedStreams.isNotEmpty) {
      for (RatingModel ratedStream in ratedStreams) {
        if (ratedStream.streamId == rating.streamId) {
          // the stream is already in the user's Rating-collection, i.e. update existing document
          isAlreadyRated = true; // the stream already exists
          final ratedStreamId = TextEditingController(text: ratedStream.id);
          await _ratingRepo.updateRating(rating, userId!, ratedStreamId.text);
        }
      }
    }

    if (!isAlreadyRated) {
      // the stream has been rated for the first time, i.e. add to Rating-collection
      await _ratingRepo.addToRatings(userId!, rating);
    }
  }

  /// A function that fetches all current user's ratings
  getRatings() async {
    UserModel user = await getUserProfileData();
    String? userId = user.id;
    _ratedStreams = await _ratingRepo.getUserRating(userId!);
  }

  /// A function that determines the position of the rating star icon to show the user rating below it, in case the page is scrolled
  void getRatingIconPosition() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox box =
            keyRating.currentContext!.findRenderObject() as RenderBox;

        setState(() {
          _positionRating = box.localToGlobal(Offset.zero); // coordinate system
        });
      });

  /// A function that opens the full cover image of a movie or stream
  Widget loadCoverImage() => GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    // open image in a Dialog
                    backgroundColor: Colors.transparent,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.stream.image,
                        placeholder: (context, url) =>
                            _cav.streamImagePlaceholder,
                        errorWidget: (context, url, error) =>
                            _cav.imageErrorWidget,
                      ),
                    ),
                  ));
        },
        child: CachedNetworkImage(
          imageUrl: widget.stream.image,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height,
          placeholder: (context, url) => _cav.streamDetailsPlaceholder,
          errorWidget: (context, url, error) => _cav.imageErrorWidget,
        ),
      );

  /// A function that shares an actual screenshot when pressing the share icon
  /// imgBytes: Bytes to load image
  void share(Uint8List imgBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final img = File("${directory.path}/flutter.png");
    img.writeAsBytes(imgBytes); // write image to bytes

    await Share.shareXFiles(text: "Gefunden auf StreaMe ☺", [
      XFile(img.path) // share message and Link
    ]);
  }

  /// A function that divides the different genres with a "•" for better overview
  String divideGenres() {
    List<String> genres = widget.stream.genre;
    String divideString = genres.first;
    if (genres.length < 2) {
      return genres.first;
    } else {
      for (var element in genres) {
        if (element != divideString) {
          divideString += " • $element";
        }
      }
      return divideString;
    }
  }

  /// A function that determines if a stream has a release date or is a long-term show
  /// years: The year(s) of the current stream
  String streamYears(List years) {
    String streamYears = "";
    for (String year in years) {
      if (years.length == 1) {
        // if movie or series was produced in one year only
        streamYears = year;
      } else {
        String currentYear = DateTime.timestamp().year.toString();
        if (year.contains(currentYear)) {
          // if movie or series is still running
          streamYears = "${years.first} - current";
        } else {
          // if series is longer than one year
          streamYears = "${years.first} - ${years.last}";
        }
      }
    }
    return streamYears;
  }

  /// A function that returns a GestureDetector of a Button with the actors/directors
  /// When tapping on Button, the corresponding actor/director screen should be shown
  /// actorDirector: The actor or director whose Button is being generated
  Widget castAndDirectorButton(String actorDirector) {
    EdgeInsets outsidePadding = const EdgeInsets.fromLTRB(
        10.0, 7.0, 0.0, 7.0); // normal padding between actor/director buttons

    if (widget.stream.cast.first == actorDirector ||
        widget.stream.direction.first == actorDirector) {
      // no left-padding if actor/director is first in actor/director list
      outsidePadding = const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0);
    }

    // Button with GestureDetector to navigate to actor/director screen if clicked:
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActorDirectorDetailsPage(
                // open actor/director page
                actorDirector: currentActorDirector(actorDirector)),
          )),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        // padding inside button
        margin: outsidePadding,
        // padding outside button
        decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0)),
        child: Center(
            child: Text(actorDirector,
                style: TextStyle(
                    color: _color.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0))),
      ),
    );
  }

  /// A function that returns all the actor or director information
  /// actorDirector: The current actor or director whose information should be displayed
  Actor currentActorDirector(String actorDirector) {
    Actor currentActor = const Actor(
        // if the actor does not exist already
        id: 99999999,
        displayName: "No one 😢",
        firstName: "No",
        secondName: "Name",
        age: 0,
        birthday: "00.00.0000",
        placeOfBirth: "Nowhere",
        biography: "No Biography.",
        acting: {},
        production: {},
        directing: {},
        image:
            "https://static9.depositphotos.com/1555678/1106/i/950/depositphotos_11060156-stock-photo-3d-white-leaning-back-against.jpg");
    try {
      currentActor = allActors.firstWhere(
          (element) => element.displayName.toString() == actorDirector,
          orElse: () => currentActor);
    } catch (e) {
      print(e);
    }
    return currentActor;
  }

  /// A function that generates the different Rows of each SD-, HD- and 4k-Tab in the Provider-overview of the specific stream, rowLabel works as a sort of headline and defines the different platforms in it
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platforms: the name of the platforms one can watch the stream on, defined for each rowLabel, also indicates link to Logo pictures
  /// platformLabels: the corresponding label of the platforms (including the prices)
  /// platformLinks: the corresponding link to the platforms
  Align providerRow(String rowLabel, List platforms, List platformLabels,
      List platformLinks) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5.0),
          Container(
            height: 20,
            color: Colors.transparent,
            child: Text(
              rowLabel,
              style: TextStyle(
                  color: _color.bodyTextColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 3.0),
          // The tile of each available stream platform for each "Stream on:", "Rent" and "Buy":
          // (it contains the platform logo (card) and the corresponding text of it below)
          checkEmptyCard(rowLabel, platforms, platformLabels, platformLinks),
        ],
      ),
    );
  }

  /// The tile of each available stream platform for each "Stream on:", "Rent" and "Buy"
  /// It contains the platform logo (card) and the corresponding text of it below
  /// If the list is empty, it returns a short text instead of a platform tile
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platforms: the name of the platforms one can watch the stream, defined for each rowLabel, also indicates link to Logo pictures
  /// platformLabels: the corresponding label of the platforms (including the prices)
  /// platformLinks: the corresponding link to the platforms
  Widget checkEmptyCard(String rowLabel, List platforms, List platformLabels,
      List platformLinks) {
    if (platforms.isEmpty) {
      // Empty platform List, i.e. Stream is not available:
      return Container(
        height: 95,
        color: Colors.transparent,
        child: const Padding(
          padding: EdgeInsets.only(left: 25.0, top: 28.0),
          child: Text(
            "Not available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    } else {
      // List has content, i.e. a platform tile is shown:
      return Container(
        height: 95,
        color: Colors.transparent,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: platforms.length,
            itemBuilder: (context, index) {
              final platform = platforms[index];
              final platformLabel = platformLabels[index];
              final platformLink = platformLinks[index];
              return buildCard(
                  rowLabel, platform, platformLabel, platforms, platformLink);
            }),
      );
    }
  }

  /// A function that builds the streaming platform card tiles
  /// First it checks, if there is only one provider, if so, it is returned
  /// Otherwise it returns the other provider tile cards starting from the first different one in the list (if provider.last != provider)
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platform: indicates the link to Logo pictures, also the name of the platforms one can watch the stream, defined for the corresponding rowLabel
  /// platformLabel: the corresponding label of the platforms in List "platforms" (including the prices)
  /// platforms: the name of the platforms one can watch the stream, defined for each rowLabel, also indicates link to Logo pictures
  /// platformLink: the corresponding link to the platform
  Widget buildCard(String rowLabel, String platform, String platformLabel,
      List platforms, String platformLink) {
    String assetImage = platform; // the link of the platform logo

    // Create Card with platform logo in it:
    Widget card = GestureDetector(
      onTap: () {
        // Function for the platform tiles that opens an alert dialog window with a link to the corresponding stream:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return tapPlatformCard(
                  rowLabel, platform, platformLabel, platformLink);
            });
      },
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.transparent,
                  child: Image.asset(
                      assetImage), // return the first streaming provider
                )),
          ),
          const SizedBox(height: 1.0),
          Text(
            platformLabel,
            style: TextStyle(
                color: _color.bodyTextColor,
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
                height: _cav.textHeight),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.fade,
          )
        ],
      ),
    );
    assetImage = "";

    // If more than one provider, create space between them:
    if (platforms.length > 1) {
      if (platforms.last == platform) {
        // if the current provider is the last named provider in the list, no space is needed at the end
        return card;
      } else {
        // else add space because the current provider is not the last named provider in the list
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: card,
        );
      }
      // If only one provider, space is not needed:
    } else {
      return card;
    }
  }

  /// The content for the onTap function of the platform tiles that opens an alert dialog window with a link to the corresponding stream
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platform: indicates the link to Logo pictures, also the name of the platforms one can watch the stream, defined for the corresponding rowLabel
  /// platforms: the name of the platforms one can watch the stream, defined for each rowLabel, also indicates link to Logo pictures
  /// platformLink: the corresponding link to the platform
  Padding tapPlatformCard(String rowLabel, String platform,
          String platformLabel, String platformLink) =>
      Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: AlertDialog(
          // Background style of the Alert Dialog:
          backgroundColor: _color.middleBackgroundColor.withOpacity(0.93),
          elevation: 0.0,
          insetPadding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.blueAccent, width: 1.0)),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(platform),
                  fit: BoxFit.fitHeight,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.05), BlendMode.dstATop)),
            ),
            // Column that includes a headline, a text to the stream URL and a close Button that closes the Dialog:
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The Dialog headline (Stream, Rent or Buy):
                Text(
                  "${rowLabel.contains(" ") ? "Stream" : rowLabel.substring(0, rowLabel.indexOf(":"))} on " // Stream / Rent / Buy
                  "${platformLabel.contains(" ") && rowLabel != "Stream on:" ? platformLabel.substring(0, platformLabel.indexOf("€") - 1) : platformLabel}",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: _color.bodyTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 22,
                ),
                // The actual content of the Alert Dialog:
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Try it out. Click ",
                        style: TextStyle(
                            color: _color.bodyTextColor, fontSize: 16),
                      ),
                      WidgetSpan(
                        child: InkWell(
                            onTap: () => launchUrl(Uri.parse(platformLink)),
                            // adding the individual URL to every stream
                            child: const Text(
                              style: TextStyle(
                                  height: 1.10,
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blueAccent),
                              "here",
                            )),
                      ),
                      TextSpan(
                        style: TextStyle(
                            color: _color.bodyTextColor, fontSize: 16),
                        text: " to watch ${widget.stream.title}.",
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                // The Button to close the Dialog window:
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 108.0),
                      decoration: BoxDecoration(
                          color: _color.bodyTextColor.withOpacity(0.3),
                          border: Border.all(
                              color: _color.middleBackgroundColor, width: 0.5),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            color: _color.middleBackgroundColor,
                            size: 20.0,
                          ),
                          const SizedBox(width: 5),
                          Text("Close",
                              style: TextStyle(
                                  color: _color.middleBackgroundColor,
                                  fontSize: 14.0)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      );

  /// A function that fetches the current user's data based on the email
  getUserProfileData() {
    User? user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (email != null) {
      return UserData().getUserData(email);
    }
  }

  /// A function that fetches the user's Favourite list based on his id
  getFavouriteStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id; // get user's id for Favourites list

    _favouriteStreams = await _favouritesRepo.getFavourites(id!);
    _addFavourites = _favouriteStreams
        .where((favourite) => favourite.title == widget.stream.title)
        .isNotEmpty; // check if the current opened stream is saved in Favourites
  }

  /// A function that fetches the user's Watchlist based on his id
  getWatchlistStreams() async {
    UserModel user = await getUserProfileData();
    String? id = user.id; // get user's id for Watchlist

    _watchlistStreams = await _watchlistRepo.getWatchlist(id!);
    _addWatchlist = _watchlistStreams
        .where(
            (watchlistStream) => watchlistStream.title == widget.stream.title)
        .isNotEmpty; // check if the current opened stream is saved in Watchlist
  }

  /// A function that handles the Favourites actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to his Favourites
  /// favourite: The current stream that will be added or removed from the user's Favourites list
  void favouriteActions(FavouritesModel favourite) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(favouriteSnackBar(widget.stream
          .type)); // show Snackbar when adding or removing a stream to or from Favourites list

    UserModel user = await getUserProfileData();
    String? id =
        user.id; // get user's id for adding or removing a movie or series

    setState(() {
      _addFavourites = !_addFavourites;
    });

    _addFavourites
        ? await _favouritesRepo.addToFavourites(id!,
            favourite) // if clicked on empty heart, i.e. addFavourites = true => add to Favourites
        : await _favouritesRepo.removeFromFavourites(
            id!,
            widget.stream.id
                .toString()); // if clicked on filled heart, i.e. addFavourites = false => remove from Favourites
  }

  /// A function that handles the Watchlist actions of a user,
  /// i.e. showing a snackbar and adding or removing a Stream to his Watchlist
  /// watchlist: The current stream that will be added or removed from the user's Watchlist
  void watchlistActions(WatchlistModel watchlist) async {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(watchlistSnackBar(widget.stream
          .type)); // show Snackbar when adding or removing a stream to or from Watchlist

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
            widget.stream.id
                .toString()); // if clicked on checked list, i.e. _addWatchlist = false => remove from Watchlist
  }

  /// A function that generates a snackbar if clicked on the heart icon
  /// If the heart is filled, the "added to Favourites" Snackbar is shown,
  /// if not, the "removed from Favourites" Snackbar is shown
  /// stream: The current stream that is added to or removed from Favourites
  SnackBar favouriteSnackBar(String stream) => SnackBar(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 6.0),
      duration: const Duration(milliseconds: 1500),
      content: Text(
        _addFavourites
            ? "$stream removed from Favourites"
            : "$stream added to Favourites",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

  /// A function that generates a snackbar if clicked on the (un-)checked list icon
  /// If the icon changes to a checked list icon, the "added to Watchlist" Snackbar is shown,
  /// if the icon changes to a unchecked list icon, the "removed from Watchlist" Snackbar is shown
  /// stream: The current stream that is added to or removed from Watchlist
  SnackBar watchlistSnackBar(String stream) => SnackBar(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 6.0),
      duration: const Duration(milliseconds: 1500),
      content: Text(
        _addWatchlist
            ? "$stream removed from Watchlist"
            : "$stream added to Watchlist",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));
}
