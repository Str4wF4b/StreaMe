import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../model/stream_model.dart';
import '../data/stream_data.dart';

//TODO: Maybe Stateful?
//TODO: SliverAppBar
class StreamPage extends StatefulWidget {
  final Stream stream;

  StreamPage({super.key, required this.stream});

  @override
  State<StreamPage> createState() => _StreamPageState();

  List<bool> favourites = List.filled(allStreams.length,
      false); //a list with all the favourite movies and streams
}

class _StreamPageState extends State<StreamPage> {
  final Color backgroundColor = const Color.fromRGBO(38, 35, 35, 1.0);

  //final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);

  final screenshotController =
      ScreenshotController(); //controller to manage screenshots

  bool addFavourites = false; //boolean to trigger the favourites button option
  bool addWatchlist = false; //boolean to trigger the watchlist button option
  double rating = 1; //initial rating

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: FittedBox(child: Text(widget.stream.title)),
          centerTitle: true,
          backgroundColor: backgroundColor,
          elevation: 0.0,
        ),
        body: Container(
          padding: const EdgeInsets.only(bottom: 15.0),
          color: backgroundColor,
          child: SingleChildScrollView(
            child: Column(children: [
              //Image:
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: isOnline(),
              ),

              //First row with share, rating, add to watchlist and add to favourites
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      //Share Button
                      onPressed: () async {
                        final imgBytes = await screenshotController.capture();
                        share(imgBytes!);
                      },
                      icon: Icon(Icons.share_rounded,
                          color: Colors.grey.shade400, size: 28.0),
                    ),
                    Stack(children: [
                      //Rating Button + overall Rating //TODO: Function for overall rating in Text widget
                      IconButton(
                          onPressed: () async {
                            await makeRating();
                            setState(
                                () {}); //needed in addition to async to update the rating inside the Stream Page
                          },
                          icon: Icon(Icons.star,
                              color: Colors.grey.shade400, size: 28.0)),
                      Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 13.0),
                        child: Text("$rating",
                            style: TextStyle(
                                fontSize: 20.0, color: Colors.grey.shade400)),
                      )
                    ]),
                    IconButton(
                        //Add to Watchlist Button
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(listSnackBar(widget.stream.type));
                          setState(() {
                            addWatchlist = !addWatchlist;
                            //TODO: Save film to watchlist
                          });
                        },
                        icon: addWatchlist
                            ? Icon(Icons.check_rounded,
                                color: Colors.grey.shade400, size: 34.0)
                            : Icon(Icons.add_rounded,
                                color: Colors.grey.shade400, size: 34.0)),
                    IconButton(
                        //Favourites Button
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(favSnackBar(widget.stream.type));
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
                padding:
                    const EdgeInsets.only(left: 15.0, right: 8.0, top: 25.0),
                child: Row(
                  children: [
                    //Year:
                    Text(
                      widget.stream.year,
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 18),
                    ),
                    const SizedBox(width: 25.0),
                    //PG:
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(2.2, 1.0, 2.2, 1.0),
                          height: 23,
                          width: 35.5,
                          //25.5 for only numbers
                          color: Colors.grey.shade400,
                          child: Text(
                            widget.stream.pg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    const SizedBox(width: 25.0),
                    //Seasons / Duration:
                    Text(
                      widget.stream.seasonOrDuration,
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 18),
                    )
                  ],
                ),
              ),

              //Third row with genres
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
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
                              color: Colors.grey.shade400,
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
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 18.0),
                  //top only 18 instead of 20, because the text in checkForMaxLines gets added 2 top-padding
                  child: LayoutBuilder(builder: (context, constraints) {
                    return checkForMaxLines(
                        widget.stream.plot, context, constraints);
                  })),

              //Fifth row with cast
              Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Text(
                          "Cast:",
                          style: TextStyle(
                              color: Colors.grey.shade400,
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
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Text(
                        "Directed by:",
                        style: TextStyle(
                            color: Colors.grey.shade400,
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
                              final actor = widget.stream.direction[index];
                              return castAndDirectorButton(actor);
                            }),
                      ),
                    ),
                  ],
                ),
              ),

              //last row with streaming providers
              Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 30.0, right: 15.0),
                //Stream providers:
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(checkEmptyList(),
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 95,
                          color: Colors.transparent,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.stream.provider.length,
                              itemBuilder: (context, index) {
                                final provider = widget.stream.provider[index];
                                return buildCard(provider);
                              }),
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
    );
  }

  /**
   * A function that divides the different genres with a "•" for better overview
   */
  String divideGenres() {
    List<String> genres = widget.stream.genre;
    String divideString = genres.first;
    if (genres.length < 2) {
      return genres.first;
    } else {
      genres.forEach((element) {
        if (element != divideString) {
          divideString += " • $element";
        }
      });
      return divideString;
    }
  }

  /**
   * A function that builds the streaming provider tiles
   * First it checks, if there is only on provider, if so, it is returned
   * Otherwise it returnes the other provider tile cards starting from the first different one in the list (if provider.last != provider)
   */
  Widget buildCard(String provider) {
    String assetImage =
        "assets/images/provider/${provider.toLowerCase()}.png"; //Name in assets equals JSON-File name

    //Create Card with provider logo in it:
    Widget card = ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          width: 95,
          height: 95,
          color: Colors.transparent,
          child: Image.asset(
              assetImage), // return the first and only streaming provider
        ));
    assetImage = "";

    //If more than one provider than create space between them
    if (widget.stream.provider.length > 1) {
      if (widget.stream.provider.last == provider) {
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

      //If only one provider space is not needed
    } else {
      return card;
    }
  }

  /**
   * A function that checks if the provider list is empty
   * If so, only a Text is returned that explains that the movie or stream cannot be streamed anywhere
   * If not, a title is returned above the listed provider tile cards
   */
  String checkEmptyList() {
    if (widget.stream.provider.isNotEmpty) {
      return "Stream on:";
    } else {
      return "This ${widget.stream.type} is not streamable at the moment.";
    }
  }

  /**
   * A function that shares an acutal screenshot when pressing the share icon
   */
  void share(Uint8List imgBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final img = File("${directory.path}/flutter.png");
    img.writeAsBytes(imgBytes);

    await Share.shareFiles(text: "Gefunden auf StreaMe ☺", [
      img.path
    ]); //TODO: Wenn man erste mal auf share icon drückt, geht nicht, erst beim 2. Mal
  }

  /**
   * A function that generates a snackbar if clicked on the heart icon.
   * If the heart is filled, the "added to Favourites" snack bar is shown,
   * if not, the "removed from Favourites" snack bar is shown
   */
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

  /**
   * A function that generates a snackbar if clicked on the plus, respectively check icon.
   * If the icon changes to a check icon, the "added to Watchlist" snack bar is shown,
   * if the icon changes to a plus icon, the "removed from Watchlist" snack bar is shown
   */
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

  /**
   * A
   */
  Future makeRating() => showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
            builder: (context, setState) => Dialog(
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.grey.shade400)),
                insetPadding:
                    const EdgeInsets.only(left: 125, top: 140.0, right: 15.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 6.0, 5.0),
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
          ));

  /**
   * A function that checks if the movie or series has a plot with over 5 lines
   * If so, make text in a scrollable container with Shader Mask for blur effect, a scrollable SizedBox and the defined Text (returnPlot) inside it,
   * if not, make a simple Text (returnPlot)
   */
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
          height: 88.0,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical, child: returnPlot),
        ),
      );
    }

    return returnPlot;
  }

  /**
   * A function that returns a GestureDetector of a Button with the actors/directors
   * When tapping on Button, the corresponding actor/director screen should be shown
   */
  Widget castAndDirectorButton(String actor) {
    EdgeInsets outsidePadding = const EdgeInsets.fromLTRB(10.0, 7.0, 0.0, 7.0); //Normal padding between actor/director buttons

    if (widget.stream.cast.first == actor || widget.stream.direction.first == actor) { //No padding left if first actor/director button
      outsidePadding = const EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 7.0);
    }

    //Button with GestureDetector to navigate to actor/director screen if clicked on
    return GestureDetector(
      onTap: () {},
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
            child: Text(actor,
                style: TextStyle(
                    color: backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0))),
      ),
    );
  }

  Image isOnline() {
    try {
      return Image.network(widget.stream.image,
          width: double.infinity, height: 320, fit: BoxFit.cover);
    } on SocketException catch (_) {
      return Image.asset("assets/images/questionMark.png",
          width: double.infinity, height: 320, fit: BoxFit.cover);
    }
  }

/**
 * Row:
 * - Text Provider
 * - wenn keine Provider: Not on Streams
 * - wenn doch:
 *   - ClipRRects auflisten
 *     => für jedes Element ein neues hinzufügen zu Reihe + Padding
 */

/*  Row buildCards() {
    List<String> providers = widget.stream.provider;
    Widget card = ClipRRect();
    Text providerText = Text("Stream providers:",
        style: TextStyle(color: Colors.grey.shade400, fontSize: 18));
    List<Widget> allCards = [];
    //One streaming provider:
    if (providers.length == 1) {
      // if providers has only one streaming provider
      Widget card = ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 120,
            height: 120,
            color: Colors.grey.shade400,
            child: Image.asset(
                "assets/images/provider/${providers.first.toLowerCase()}"), // return the first and only streaming provider
          ));
      return Row(children: [
        providerText,
        const SizedBox(height: 10.0),
        card
      ]); // return the Row with the card
    }

    //More than one streaming provider:
    else if (providers.length > 1) {
      providers.forEach((element) {
        card = ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                width: 120,
                height: 120,
                color: Colors.grey.shade400,
                child: Image.asset(
                    "assets/images/provider/${element.toLowerCase()}"),
              ),
            ));
        allCards.add(card);
      });

      return Row(children: [
        providerText,
        const SizedBox(height: 10.0),
      ]);

      //No streaming provider:
    } else {
      Text noProvider = Text("Not streamable (yet)",
          style: TextStyle(color: Colors.grey.shade400, fontSize: 18));
      return Row(children: [providerText, noProvider]); // return the Row
    }
  }*/
}
