import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import '../../pages/others/filter.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../utils/constants_and_values.dart';

// Test:
import '../../pages/others/stream_details.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  final searchController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  //TODO: If showFilter = true, show Container on the actual one within Stack

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Streams> streams = allStreams;
  final ColorPalette color = ColorPalette();
  final ConstantsAndValues cons = ConstantsAndValues();

  @override
  Widget build(BuildContext context) {
    return /*AppOverlay(
      title: "Search",
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return*/
        Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: color.middleBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                      text: "Hey ",
                      style: TextStyle(
                          color: color.bodyTextColor,
                          fontSize: 15,
                          height: 1.2),
                      children: [
                        TextSpan(
                            text: checkUsername(),
                            //TODO: Different names (Google, Apple or Anon)
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const TextSpan(
                            text:
                                ", \nsearch for your favourite Movies or Series and add them to your Watchlist.",
                            style: TextStyle(fontSize: 15))
                      ]),
                ),
              ),
            ),
            Stack(children: [
              Container(
                margin: const EdgeInsets.fromLTRB(20.0, 30.0, 42.0, 20.0),
                child: TextField(
                  controller: widget.searchController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 22),
                    suffixIcon: widget.searchController.text.isNotEmpty
                        ? GestureDetector(
                            child: const Icon(Icons.close,
                                color: Colors.blueGrey, size: 22),
                            onTap: () {
                              widget.searchController.clear();
                              FocusScope.of(context).requestFocus(
                                  FocusNode()); //TextField outfocused
                            })
                        : null,
                    hintText: "Movie or Series",
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(30.0)),
                    filled: true,
                    fillColor: Colors.grey.shade300,
                    isDense: true,
                  ),
                  onChanged: searchStream,
                ),
              ),
              Positioned(
                //padding: const EdgeInsets.only(left: 354, top: 37),
                left: MediaQuery.of(context).size.width - 35,
                bottom: MediaQuery.of(context).size.height -
                    750, //766 when isDense = false
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            backgroundColor:
                                color.middleBackgroundColor.withOpacity(0.93),
                            insetPadding: EdgeInsets.zero,
                            //full width and height
                            child: FilterPage(),
                          );
                        });
                  },
                  child: Icon(
                    size: 28.0,
                    Icons.tune,
                    color: color.bodyTextColor,
                  ),
                ),
              ),
            ]),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: ListView.builder(
                itemCount: streams.length,
                itemBuilder: (context, index) {
                  final stream = streams[index];
                  //widget.streams.sort((a, b) => a.toString().toLowerCase().compareTo(b.toString().toLowerCase()));
                  return buildStream(stream);
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  /// Function that searches after a stream if a keyword is entered in the text field
  void searchStream(String enteredKeyword) {
    final suggestions = allStreams.where((stream) {
      final streamTitle = stream.title.toLowerCase();
      final input = enteredKeyword.toLowerCase();

      return streamTitle.contains(input);
    }).toList();

    setState(() => streams = suggestions);
  }

  /// Function that returns the clicked stream site with information about the movie or series
  Widget buildStream(Streams stream) => ListTile(
        leading: CachedNetworkImage(
          imageUrl: stream.image,
          key: UniqueKey(),
          fit: BoxFit.cover,
          width: 50,
          height: 50,
          placeholder: (context, url) => cons.streamImagePlaceholder,
          errorWidget: (context, url, error) => cons.imageErrorWidgetLittle,
        ),
        title: Text(
          stream.title,
          style: TextStyle(color: color.bodyTextColor),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamDetailsPage(stream: stream),
            )),
      );

  /// Function that checks if a user is logged in and so the Username is shown, or if it's an anonymous user
  String checkUsername() {
    if (widget.user?.displayName == null || widget.user?.displayName == "") {
      return "unknown User"; //shown if anonymous user
    } else {
      return "${widget.user?.displayName}"; //show username
    }
  }
}
