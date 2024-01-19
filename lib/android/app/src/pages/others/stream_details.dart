import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stream_me/android/app/src/data/actor_data.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/data/sd_data.dart';
import 'package:stream_me/android/app/src/data/hd_data.dart';
import 'package:stream_me/android/app/src/data/uhd_data.dart';
import 'package:stream_me/android/app/src/model/actor_model.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import 'package:stream_me/android/app/src/model/sd_model.dart';
import 'package:stream_me/android/app/src/model/hd_model.dart';
import 'package:stream_me/android/app/src/model/uhd_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/global/streame_refresh.dart';
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
  final ColorPalette color = ColorPalette();
  final Images image = Images();
  final ConstantsAndValues cons = ConstantsAndValues();

  final screenshotController =
      ScreenshotController(); //controller to manage screenshots
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  final keyRating =
      GlobalKey(); //GlobalKey to determine the size and position of the rating icon
  Size? sizeRating; //The size of the rating icon
  Offset? positionRating; //The position of the rating icon

  bool addFavourites = false; //boolean to trigger the favourites button option
  bool addWatchlist = false; //boolean to trigger the watchlist button option
  double rating = 1; //initial rating

  int i = 0;

  List<bool> favourites = List.filled(allStreams.length,
      false); //a list with all the favourite movies and streams
  late List actorsDirectors = allActors;
  late List allSdStreams = allSd;

  @override
  Widget build(BuildContext context) {
    getSizeAndPosition();
    final Sd sdProvider = allSd[widget.stream.id];
    final Hd hdProvider = allHd[widget.stream.id];
    final Uhd uhdProvider = allUhd[widget.stream.id];

    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
          backgroundColor: color.backgroundColor,
          /*appBar: AppBar(
          title: FittedBox(child: Text(widget.stream.title)),
          centerTitle: true,
          backgroundColor: backgroundColor,
          elevation: 0.0,
        ),*/
          body: StreameRefresh(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: color.backgroundColor,
                title: FittedBox(child: Text(widget.stream.title)),
                centerTitle: true,
                elevation: 0.0,
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(
                  background: loadCoverImage(),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  color: color.backgroundColor,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      //Image:
                      /* Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isOnline(),
                      ),*/

                      //First row with share, rating, add to watchlist and add to favourites
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              //Share Button
                              onPressed: () async {
                                final imgBytes =
                                    await screenshotController.capture();
                                share(imgBytes!);
                              },
                              icon: Icon(Icons.share_rounded,
                                  color: color.bodyTextColor, size: 28.0),
                            ),
                            Stack(children: [
                              //Rating Button + overall Rating //TODO: Function for overall rating in Text widget
                              IconButton(
                                  onPressed: () async {
                                    await makeRating();
                                    setState(
                                        () {}); //needed in addition to async to update the rating inside the Stream Page
                                  },
                                  icon: Icon(
                                    Icons.star,
                                    color: color.bodyTextColor,
                                    size: 28.0,
                                    key: keyRating,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 40.0, top: 13.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await makeRating();
                                    setState(
                                        () {}); //needed in addition to async to update the rating inside the Stream Page
                                  },
                                  child: Text("$rating",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: color.bodyTextColor)),
                                ),
                              )
                            ]),
                            IconButton(
                                //Add to Watchlist Button
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        listSnackBar(widget.stream.type));
                                  setState(() {
                                    addWatchlist = !addWatchlist;
                                    //TODO: Save film to watchlist
                                  });
                                },
                                icon: addWatchlist
                                    ? Icon(Icons.check_rounded,
                                        color: color.bodyTextColor, size: 34.0)
                                    : Icon(Icons.add_rounded,
                                        color: color.bodyTextColor,
                                        size: 34.0)),
                            IconButton(
                                //Favourites Button
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                        favSnackBar(widget.stream.type));
                                  setState(() {
                                    addFavourites = !addFavourites;
                                    //TODO: Save film to favourites
                                  });
                                },
                                icon: addFavourites
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 32.0,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined,
                                        color: Colors.red,
                                        size: 32.0,
                                      )),
                          ],
                        ),
                      ),

                      //Second row with year, pg and seasons/duration
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 8.0, top: 25.0),
                        child: Row(
                          children: [
                            //Year:
                            Text(
                              widget.stream.year,
                              style: TextStyle(
                                  color: color.bodyTextColor, fontSize: 18),
                            ),
                            const SizedBox(width: 25.0),
                            //PG:
                            ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      2.2, 1.0, 2.2, 1.0),
                                  height: 23,
                                  width: 35.5,
                                  //25.5 for only numbers
                                  color: Colors.grey.shade400,
                                  child: Text(
                                    widget.stream.pg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: color.backgroundColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            const SizedBox(width: 25.0),
                            //Seasons / Duration:
                            Text(
                              widget.stream.seasonOrDuration,
                              style: TextStyle(
                                  color: color.bodyTextColor, fontSize: 18),
                            )
                          ],
                        ),
                      ),

                      //Third row with genres
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            //Genres:
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  textAlign: TextAlign.left,
                                  divideGenres(),
                                  style: TextStyle(
                                      color: color.bodyTextColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //Fourth row with plot
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 18.0),
                          //top only 18 instead of 20, because the text in checkForMaxLines gets added 2 top-padding
                          child: LayoutBuilder(builder: (context, constraints) {
                            return /*checkForMaxLines(
                                widget.stream.plot, context, constraints);*/
                                ExpandText(widget.stream.plot,
                                    style: TextStyle(
                                      color: color.bodyTextColor,
                                      fontSize: MediaQuery.textScalerOf(context)
                                          .scale(16),
                                    ),
                                    indicatorIcon: Icons.keyboard_arrow_down,
                                    indicatorIconColor: Colors.grey.shade400,
                                    indicatorPadding:
                                        const EdgeInsets.only(bottom: 1.0),
                                    maxLines: /*MediaQuery.of(context).textScaleFactor == 1.1 ? 6 : 5*/
                                        6,
                                    //TODO: !!
                                    expandIndicatorStyle:
                                        ExpandIndicatorStyle.icon);
                          })),

                      //Fifth row with cast
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
                                      color: color.bodyTextColor,
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

                      //Sixth row with director
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
                                    color: color.bodyTextColor,
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

                      //last row with streaming providers
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 30.0, right: 15.0),
                        //Stream providers:
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(/*checkEmptyList()*/ "Available on:",
                                  style: TextStyle(
                                      color: color.bodyTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  //Container that includes the 3 Tabs SD, HD and 4k and its streaming providers
                                  decoration: BoxDecoration(
                                    color: color.middleBackgroundColor,
                                    border: Border.all(
                                        width: 1.0, color: color.bodyTextColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(25.0)),
                                    // shape: BoxShape.rectangle
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25.0),
                                    child: Column(
                                      children: [
                                        //3 Tabs on top:
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 1.0),
                                          child: SizedBox(
                                            height: 40,
                                            child: TabBar(
                                              controller: _tabController,
                                              indicatorPadding:
                                                  const EdgeInsets.only(
                                                      left: 7.0,
                                                      right: 7.0,
                                                      bottom: 4.0),
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
                                        //Content of the 3 Tabs:
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
                                                //First Tab (SD Streams):
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
                                                //Second Tab (HD Streams):
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
                                                //Third Tab (4k Streams):
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

  /// A function that checks if the provider list is empty
  /// If so, only a Text is returned that explains that the movie or stream cannot be streamed anywhere
  /// If not, a title is returned above the listed provider tile cards
  String checkEmptyList() {
    if (widget.stream.provider.isNotEmpty) {
      return "Available on:";
    } else {
      return "This ${widget.stream.type} is not streamable at the moment.";
    }
  }

  /// A function that shares an acutal screenshot when pressing the share icon
  void share(Uint8List imgBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final img = File("${directory.path}/flutter.png");
    img.writeAsBytes(imgBytes);

    await Share.shareXFiles(text: "Gefunden auf StreaMe ☺", [
      XFile(img.path)
    ]); //TODO: Wenn man erste mal auf share icon drückt, geht nicht, erst beim 2. Mal
  }

  /// A function that generates a snackbar if clicked on the heart icon.
  /// If the heart is filled, the "added to Favourites" snack bar is shown,
  /// if not, the "removed from Favourites" snack bar is shown
  SnackBar favSnackBar(String stream) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 6.0),
      duration: const Duration(milliseconds: 1500),
      content: Text(
        addFavourites
            ? "$stream removed from Favourites"
            : "$stream added to Favourites",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

  /// A function that generates a snackbar if clicked on the plus, respectively check icon.
  /// If the icon changes to a check icon, the "added to Watchlist" snack bar is shown,
  /// if the icon changes to a plus icon, the "removed from Watchlist" snack bar is shown
  SnackBar listSnackBar(String stream) => SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 28.0, right: 28.0, bottom: 6.0),
      duration: const Duration(milliseconds: 1500),
      content: Text(
        addWatchlist
            ? "$stream removed from Watchlist"
            : "$stream added to Watchlist",
        style: TextStyle(color: Colors.grey.shade300),
        textAlign: TextAlign.center,
      ));

  /// A
  Future makeRating() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
            builder: (context, setState) => Stack(
              children: [
                Positioned(
                  top: positionRating?.dy,
                  child: SizedBox(
                    width: 370.0,
                    child: Dialog(
                        backgroundColor: color.backgroundColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.grey.shade400)),
                        insetPadding:
                            const EdgeInsets.only(left: 125.0, top: 10.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 6.0, 5.0),
                              child: RatingBar.builder(
                                  minRating: 1,
                                  maxRating: 5,
                                  initialRating: rating,
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
                                  onRatingUpdate: (rating) => setState(() {
                                        this.rating = rating;
                                        this.setState(
                                            () {}); //changing value inside Dialog and inside the Stream Page
                                      })),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text("$rating",
                                    style: TextStyle(
                                        color: Colors.grey.shade300,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600)))
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ));

  void getSizeAndPosition() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final RenderBox box =
            keyRating.currentContext!.findRenderObject() as RenderBox;

        setState(() {
          positionRating = box.localToGlobal(Offset.zero); //coordinate system
          //sizeRating = box.size;
        });
      });

  /// A function that returns a GestureDetector of a Button with the actors/directors
  /// When tapping on Button, the corresponding actor/director screen should be shown
  Widget castAndDirectorButton(String actorDirector) {
    EdgeInsets outsidePadding = const EdgeInsets.fromLTRB(
        10.0, 7.0, 0.0, 7.0); //Normal padding between actor/director buttons

    if (widget.stream.cast.first == actorDirector ||
        widget.stream.direction.first == actorDirector) {
      //No padding left if first actor/director button
      outsidePadding = const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0);
    }

    //Button with GestureDetector to navigate to actor/director screen if clicked on
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActorDirectorDetailsPage(
                actorDirector: currentActorDirector(actorDirector)),
          )),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        // padding inside button
        margin: outsidePadding,
        // padding outside button
        decoration: BoxDecoration(
            //border: Border.all(color: Colors.white70),
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0)),
        child: Center(
            child: Text(actorDirector,
                style: TextStyle(
                    color: color.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0))),
      ),
    );
  }

  Widget loadCoverImage() {
    //try {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.stream.image,
                      placeholder: (context, url) =>
                          cons.streamImagePlaceholder,
                      errorWidget: (context, url, error) =>
                          cons.imageErrorWidget,
                    ),
                  ),
                ));
      },
      child: CachedNetworkImage(
        imageUrl: widget.stream.image,
        //width: double.infinity, height: 320, fit: BoxFit.cover
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height,
        placeholder: (context, url) => cons.streamDetailsPlaceholder,
        errorWidget: (context, url, error) => cons.imageErrorWidget,
      ),
    );
    //} on SocketException catch (_) {
    // return Image.asset(image.notOnline,
    //     width: double.infinity, height: 320, fit: BoxFit.cover);
    //}
  }

  // ---------------------------------------------------------------------------------------------------------------------------------------------------------

  /// A function that checks if the movie or series has a plot with over 5 lines
  /// If so, make text in a scrollable container with Shader Mask for blur effect, a scrollable SizedBox and the defined Text (returnPlot) inside it,
  /// if not, make a simple Text (returnPlot)
  Widget checkForMaxLines(
      String text, BuildContext context, BoxConstraints constraints) {
    final TextStyle plotStyle = TextStyle(
        color: Colors.grey.shade400, fontSize: 16); //the TextStyle of the text
    final span = TextSpan(
        text: text,
        style: plotStyle); //the text's span with the text and its style
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: constraints.maxWidth);
    final numLines = tp
        .computeLineMetrics()
        .length; //the text and its style define the size of a line

    //The plot text:
    Widget returnPlot = Padding(
      padding: const EdgeInsets.only(top: 2.0, bottom: 5.0),
      child: Text(
        text,
        style: plotStyle,
        textAlign: TextAlign.justify,
      ),
    );

    if (numLines > 5) {
      //only if over 5 lines make the text scrollable, if not, return the defined plot text
      returnPlot = ShaderMask(
        //add blur effect at the bottom of container which contains the text
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white.withOpacity(0.05)],
            stops: const [0.88, 1],
            tileMode: TileMode.mirror,
          ).createShader(bounds);
        },
        child: SizedBox(
          //the box container that enables to scroll
          height: 100.0,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: returnPlot),
        ),
      );
    }

    return returnPlot;
  }

  Actor currentActorDirector(String actorDirector) {
    Actor currentActor = const Actor(
        //if the actor does not exist already, i.e. this means not that this is a placeholder if the internet connection etc. is not working
        id: 99999999,
        displayName: "No one 😢",
        firstName: "No",
        secondName: "Name",
        age: 0,
        birthday: "never born",
        placeOfBirth: "Nowhere",
        biography: "No Biography.",
        acting: {},
        production: {},
        directing: {},
        image:
            "https://static9.depositphotos.com/1555678/1106/i/950/depositphotos_11060156-stock-photo-3d-white-leaning-back-against.jpg");
    try {
      currentActor = allActors
          .where((element) => element.displayName.toString() == actorDirector)
          .single;
    } catch (e) {
      print(e);
    }
    return currentActor;
  }

  /// A function that generates the different Rows of each SD-, HD- and 4k-Tab in the Provider-overview of the specific stream, rowLabel works as a sort of headline and defines the different platforms in it
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platforms: the name of the platforms one can watch the stream, defined for each rowLabel, also indicates link to Logo pictures
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
                  color: color.bodyTextColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 3.0),
          //The container of each available stream platform for each "Stream on:", "Rent" and "Buy"
          //It contains the platform logo (card) and the corresponding text of it below
          checkEmptyCard(rowLabel, platforms, platformLabels, platformLinks),
        ],
      ),
    );
  }

  /// The container of each available stream platform for each "Stream on:", "Rent" and "Buy"
  /// It contains the platform logo (card) and the corresponding text of it below
  /// If the list is empty, it returns a short text instead of a platform tile
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platforms: the name of the platforms one can watch the stream, defined for each rowLabel, also indicates link to Logo pictures
  /// platformLabels: the corresponding label of the platforms (including the prices)
  /// platformLinks: the corresponding link to the platforms
  Widget checkEmptyCard(String rowLabel, List platforms, List platformLabels,
      List platformLinks) {
    if (platforms.isEmpty) {
      //Empty platform List, i.e. Stream is not available
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
      //List has content, i.e. a platform tile is shown
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

  /// A function that builds the streaming platform tiles
  /// First it checks, if there is only on provider, if so, it is returned
  /// Otherwise it returnes the other provider tile cards starting from the first different one in the list (if provider.last != provider)
  /// rowLabel: the different options of a stream in the specific quality (stream with subscription, rent or buy)
  /// platform: indicates the link to Logo pictures, also the name of the platforms one can watch the stream, defined for the corresponding rowLabel
  /// platformLabel: the corresponding label of the platforms in List "platforms" (including the prices)
  /// platforms: the name of the platforms one can watch the stream, defined for each rowLabel, also indicates link to Logo pictures
  /// platformLink: the corresponding link to the platform
  Widget buildCard(String rowLabel, String platform, String platformLabel,
      List platforms, String platformLink) {
    String assetImage = platform; //The link of the platform logo

    //Create Card with platform logo in it:
    Widget card = GestureDetector(
      onTap: () {
        //function for the platform tiles that opens an alert dialog window with a link to the corresponding stream
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
                  width: 80, //95,
                  height: 80, //95,
                  color: Colors.transparent,
                  child: Image.asset(
                      assetImage), // return the first and only streaming provider
                )),
          ),
          const SizedBox(height: 1.0),
          Text(
            platformLabel,
            style: TextStyle(
                color: color.bodyTextColor,
                fontSize: 11.0,
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.fade,
          )
        ],
      ),
    );
    assetImage = "";

    //If more than one provider than create space between them
    if (platforms.length > 1) {
      if (platforms.last == platform) {
        //if the current provider is the last named provider in the list, no space is needed at the end
        return card;
      } else {
        //else add space because the current provider is not the last named provider in the list
        return Padding(
          padding: const EdgeInsets.only(right: 10.0),
          //create space on right side of the card
          child: card,
        );
      }

      //If only one provider, space is not needed
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
          //Background style of the Alert Dialog:
          backgroundColor: color.middleBackgroundColor.withOpacity(0.93),
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
            //Column that includes a headline, a text to the stream URL and a close Button that closes the Dialog
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //The Dialog headline (Stream, Rent or Buy)
                Text(
                  "${rowLabel.contains(" ") ? "Stream" : rowLabel.substring(0, rowLabel.indexOf(":"))} on " //Stream / Rent / Buy
                  "${platformLabel.contains(" ") && rowLabel != "Stream on:" ? platformLabel.substring(0, platformLabel.indexOf("€") - 1) : platformLabel}",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: color.bodyTextColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 22,
                ),
                //The actual content of the Alert Dialog:
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Try it out. Click ",
                        style:
                            TextStyle(color: color.bodyTextColor, fontSize: 16),
                      ),
                      WidgetSpan(
                        child: InkWell(
                            onTap: () => launchUrl(Uri.parse(platformLink)),
                            //adding the individual URL to every stream
                            child: const Text(
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline),
                              "here",
                            )),
                      ),
                      TextSpan(
                        style:
                            TextStyle(color: color.bodyTextColor, fontSize: 16),
                        text: " to watch ${widget.stream.title}.",
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                //The Button to close the Dialog window:
                GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.symmetric(horizontal: 108.0),
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.white70),
                          color: color.bodyTextColor.withOpacity(0.3),
                          border: Border.all(
                              color: color.middleBackgroundColor, width: 0.5),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.close,
                            color: color.middleBackgroundColor,
                            size: 20.0,
                          ),
                          const SizedBox(width: 5),
                          Text("Close",
                              style: TextStyle(
                                  color: color.middleBackgroundColor,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 14.0)),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
}
