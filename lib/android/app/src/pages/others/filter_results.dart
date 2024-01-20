import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../utils/color_palette.dart';
import '../../widgets/features/actor_director_tab.dart';

class FilterResultsPage extends StatefulWidget {
  final GlobalKey<FormFieldState> keyPlatforms;
  final GlobalKey<FormFieldState> keyType;
  final GlobalKey<FormFieldState> keyGenre;
  final GlobalKey<FormFieldState> keyYear;
  final GlobalKey<FormFieldState> keyActor;

  const FilterResultsPage(
      {Key? key,
      required this.keyPlatforms,
      required this.keyType,
      required this.keyGenre,
      required this.keyYear,
      required this.keyActor})
      : super(key: key);

  @override
  State<FilterResultsPage> createState() => _FilterResultsPageState();
}

class _FilterResultsPageState extends State<FilterResultsPage> {
  ColorPalette color = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color.backgroundColor,
      body: Column(
        children: [
          AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Filter Results",
                style: TextStyle(
                  color: color.bodyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            backgroundColor: color.backgroundColor,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              )
            ],
          ),
          Expanded(
            flex: 5,
            child: SizedBox.expand(
              child: Container(
                color: color.backgroundColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Row(
                          children: [
                            filterActive(widget.keyPlatforms),
                            filterActive(widget.keyType),
                            filterActive(widget.keyGenre),
                            filterActive(widget.keyYear),
                            filterActive(widget.keyActor),
                          ],
                        ),
                      ),
                    ],
                    //Actor abgleichen mit value von key, am besten mit allen Actors, wenn gleich, dann in ActorDirectorTab und acting anzeigen, sonst nichts (evtl. auch acting übergeben neben Actor selbst)
                    //ActorDirectorTab(actorDirector: widget.keyActor, tabContent: widget.keyActor.currentState?.value.acting),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * A function that generates a field with the entered Filter if its value is not null and a button to delete the filter
   * key: The GlobalKey that indicates the actual filter
   */
  Container filterActive(GlobalKey<FormFieldState> key) {
    //If the value of the GlobalKey is null, i.e. no filter is active, just return an empty Container
    if (key.currentState?.value == null) {
      return Container();
    }
    //If the value of the GlobalKey is not null, generate a field with a Button (GestureDetector)
    else {
      return Container(
        //Padding inside button:
        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 5.0),

        //Padding outside button:
        margin: const EdgeInsets.fromLTRB(7.0, 7.0, 0.0, 7.0),

        decoration: BoxDecoration(
            //border: Border.all(color: Colors.white70),
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          children: [
            Text("${key.currentState?.value} ",
                style: TextStyle(
                    color: color.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0)),
            GestureDetector(
              onTap: () {
                key.currentState?.reset();
                setState(() {
                  filterActive(widget.keyPlatforms);
                });

              },
              child: Icon(Icons.close, size: 18, color: color.backgroundColor),
            )
          ],
        ),
      );
    }
  }
}
