import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../widgets/features/actor_director_tile.dart';
import '../../data/actor_data.dart';
import '../../data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import '../../utils/constants_and_values.dart';
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
  ConstantsAndValues cav = ConstantsAndValues();
  final List _actors = [];

  @override
  void initState() {
    super.initState();

    for (var actor in allActors) {
      _actors.add(actor.displayName);
    }
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Filter Row:
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            filterActive(widget.keyPlatforms),
                            filterActive(widget.keyType),
                            filterActive(widget.keyGenre),
                            filterActive(widget.keyYear),
                            filterActive(widget.keyActor),
                            checkAllEmptyFilters(
                                widget.keyPlatforms,
                                widget.keyType,
                                widget.keyGenre,
                                widget.keyYear,
                                widget.keyActor),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 55.0),
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          filterResults(widget.keyPlatforms, widget.keyType,
                              widget.keyGenre, widget.keyYear, widget.keyActor),
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
        ],
      ),
    );
  }

  ///
  /// A function that generates a field with the entered Filter if its value is not null and a button to delete the filter
  /// key: The GlobalKey that indicates the actual filter
  ///
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

  ///
  /// A method that checks if all filters are empty
  /// keyPlatforms: The GlobalKey of the selected platform-filter
  /// keyType: The GlobalKey of the selected type-filter
  /// keyGenre: The GlobalKey of the selected genre-filter
  /// keyYear: The GlobalKey of the selected year-filter
  /// keyActor: The GlobalKey of the selected actor-filter
  /// return: a String message that informs the user that no filter was selected
  ///
  Widget checkAllEmptyFilters(
      GlobalKey<FormFieldState> keyPlatforms,
      GlobalKey<FormFieldState> keyType,
      GlobalKey<FormFieldState> keyGenre,
      GlobalKey<FormFieldState> keyYear,
      GlobalKey<FormFieldState> keyActor) {
    List allFilterKeys = [keyPlatforms, keyType, keyGenre, keyYear, keyActor];
    Widget emptyFilterMsg = const Text("");
    if (allFilterKeys.every((element) => element.currentState?.value == null)) {
      emptyFilterMsg = Container(
        padding: const EdgeInsets.fromLTRB(2.0, 5.0, 5.0, 4.0),
        margin: const EdgeInsets.fromLTRB(7.0, 7.0, 0.0, 7.0),
        child: const Text("No filters selected.",
            style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 15)),
      );
    }
    return emptyFilterMsg;
  }

  ///
  /// A method that determines the active filter(s) selected by the user and returns the filter results generated in another method
  /// keyPlatforms: The GlobalKey of the selected platform-filter
  /// keyType: The GlobalKey of the selected type-filter
  /// keyGenre: The GlobalKey of the selected genre-filter
  /// keyYear: The GlobalKey of the selected year-filter
  /// keyActor: The GlobalKey of the selected actor-filter
  /// return: The final results of the user's filter(s)
  ///
  Widget filterResults(
      GlobalKey<FormFieldState> keyPlatform,
      GlobalKey<FormFieldState> keyType,
      GlobalKey<FormFieldState> keyGenre,
      GlobalKey<FormFieldState> keyYear,
      GlobalKey<FormFieldState> keyActor) {
    List keys = [keyPlatform, keyType, keyGenre, keyYear, keyActor];
    List activeFilters = [];
    Widget filterResult = Container();

    //Checking for active Filters before generating the filter results:
    for (var element in keys) {
      var keyValue = element.currentState.value;
      if (keyValue != null) {
        activeFilters.add(element.currentState.value);
      }
    }

    filterResult = generateResults(activeFilters);

    return filterResult;
  }

  ///
  /// A method that generates the results of the selected filter by the user
  /// activeFilters: The activeFilters that have to be observed to generate the filter results
  /// return:
  ///
  Widget generateResults(List activeFilters) {
    print("Aktive Filter: $activeFilters");

    List movies = allStreams
        .where((element) => (element.type.toString() == "Movie"))
        .toList();
    List series = allStreams
        .where((element) => (element.type.toString() == "Series"))
        .toList();

    List filteredStreams =
        checkAllFilters([], activeFilters, movies + series);
    List filteredMovies = filteredStreams
        .where((element) => element.type.contains("Movie"))
        .toList();
    List filteredSeries = filteredStreams
        .where((element) => element.type.contains("Series"))
        .toList();

    var type = widget.keyType.currentState?.value;

    Widget result = Container();

    if (type == null) {
      //No type selected, i.e. both types (Movie and Series)
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          filterLabel("Movies"),
          filterEmptyList(filteredMovies),
          filteredResults(filteredMovies, filteredStreams, "Movies"),
          const SizedBox(height: 20.0),
          Align(
            alignment: Alignment.centerLeft,
            child: filterLabel("Series"),
          ),
          filterEmptyList(filteredSeries),
          filteredResults(filteredSeries, filteredStreams, "Series"),
          const SizedBox(height: 15.0)
        ],
      );
    } else if (type == "Movie") {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          filterLabel("Movies"),
          filterEmptyList(filteredMovies),
          filteredResults(filteredMovies, filteredStreams, "Movies"),
        ],
      );
    } else {
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          filterLabel("Series"),
          filterEmptyList(filteredSeries),
          filteredResults(filteredSeries, filteredStreams, "Series"),
        ],
      );
    }
    return result;
  }

  List checkPlatformFilter(List allMoviesSeries, List activeFilters) {
    if (widget.keyPlatforms.currentState?.value != null) {
      for (var key in activeFilters) {
        if (cav.platforms.contains(key)) {
          allMoviesSeries
              .removeWhere((element) => !(element.provider.contains(key)));
        }
      }
    }
    return allMoviesSeries;
  }

  List checkTypeFilter(List filtered, List activeFilters) {
    if (widget.keyType.currentState?.value != null) {
      for (var key in activeFilters) {
        if (cav.types.contains(key)) {
          filtered.removeWhere((element) => !(element.type.contains(key)));
        }
      }
    }
    return filtered;
  }

  List checkGenreFilter(List filtered, List activeFilters) {
    if (widget.keyGenre.currentState?.value != null) {
      for (var key in activeFilters) {
        if (cav.genres.contains(key)) {
          filtered.removeWhere((element) => !(element.genre.contains(key)));
        }
      }
    }
    return filtered;
  }

  List checkYearFilter(List filtered, List activeFilters) {
    if (widget.keyYear.currentState?.value != null) {
      for (var key in activeFilters) {
        if (cav.years.contains(key)) {
          filtered.removeWhere((element) => !(element.year.contains(key)));
        }
      }
    }
    return filtered;
  }

  List checkActorFilter(List filtered, List activeFilters) {
    if (widget.keyActor.currentState?.value != null) {
      for (var key in activeFilters) {
        if (_actors.contains(key)) {
          filtered.removeWhere((element) => !(element.cast.contains(key)));
        }
      }
    }
    return filtered;
  }

  List checkAllFilters(List filteredList, List activeFilters, List allStreams) {
    filteredList = checkPlatformFilter(allStreams, activeFilters);
    filteredList = checkTypeFilter(filteredList, activeFilters);
    filteredList = checkGenreFilter(filteredList, activeFilters);
    filteredList = checkYearFilter(filteredList, activeFilters);
    filteredList = checkActorFilter(filteredList, activeFilters);
    return filteredList;
  }


  /*List checkFilter(List continuousList, List activeFilters, GlobalKey<FormFieldState> keyFilter, List filterList, List filterDataList) {
    if(keyFilter.currentState?.value != null) {
      for (var key in activeFilters) {
        if (filterList.contains(key)) {
          continuousList
              .removeWhere((element) => !(filterDataList.contains(key)));
        }
      }
    }
    return continuousList;
  }*/

  Text filterLabel(String label) => Text(label,
        style: TextStyle(
            color: color.bodyTextColor,
            fontSize: 18.0,
            fontWeight: FontWeight.bold));

  Widget filteredResults(List filtered, List filteredStreams, String label) => SizedBox(
        height: filtered.isNotEmpty ? 210 : 30,
        child: filtered.isNotEmpty
            ? ListView.builder(
                itemCount: filtered.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String currentTitle = filtered.elementAt(index).title;
                  if (filteredStreams.isNotEmpty) {
                    Streams currentStream = filtered.elementAt(index);
                    ActorDirectorTile currentTile = ActorDirectorTile(
                      stream: currentStream,
                      imageUrl: currentStream.image,
                      title: currentTitle,
                    );
                    return currentTile;
                  } else {
                    return Container();
                  }
                })
            : Text("    No $label found.",
                style: TextStyle(
                    color: color.bodyTextColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.8)));

  SizedBox filterEmptyList(List filtered) => filtered.isNotEmpty
      ? const SizedBox(height: 10.0)
      : const SizedBox(height: 0.0);
}
