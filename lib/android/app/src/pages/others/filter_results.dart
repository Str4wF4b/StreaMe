import 'package:flutter/material.dart';
import '../../widgets/features/stream_poster_tile.dart';
import '../../data/actor_data.dart';
import '../../data/streams_data.dart';
import 'package:stream_me/android/app/src/model/streams_model.dart';
import '../../utils/constants_and_values.dart';
import '../../utils/color_palette.dart';

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
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  // Local instances:
  final List _actors = [];

  @override
  void initState() {
    super.initState();

    for (var actor in allActors) {
      _actors.add(actor.displayName); // fill actors list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: Column(
        children: [
          AppBar(
            title: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "Filter Results",
                style: TextStyle(
                  color: _color.bodyTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            backgroundColor: _color.backgroundColor,
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                // Close Button on upper right-hand side:
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
                color: _color.backgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filter Row:
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // The active filters selected by the user:
                            filterActive(widget.keyPlatforms),
                            filterActive(widget.keyType),
                            filterActive(widget.keyGenre),
                            filterActive(widget.keyYear),
                            filterActive(widget.keyActor),
                            checkAllEmptyFilters(
                                // check if no filter has been selected
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          filterResults(widget.keyPlatforms, widget.keyType,
                              widget.keyGenre, widget.keyYear, widget.keyActor),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// A function that generates a field of the selected Filter if its value is not null and an icon to delete this filter
  /// key: The GlobalKey that refers to the actual filter
  Container filterActive(GlobalKey<FormFieldState> key) {
    // If the value of the GlobalKey is null, i.e. the filter is not active, just return an empty Container:
    if (key.currentState?.value == null) {
      return Container();
    }
    // If the value of the GlobalKey is not null, generate a field with an icon as Button (GestureDetector)
    else {
      return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 5.0, 5.0, 5.0),
        // padding inside button
        margin: const EdgeInsets.fromLTRB(7.0, 7.0, 0.0, 7.0),
        // padding outside button
        decoration: BoxDecoration(
            color: Colors.grey.shade600,
            borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          children: [
            Text("${key.currentState?.value} ",
                // the selected value of the Filter
                style: TextStyle(
                    color: _color.backgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0)),
            GestureDetector(
              onTap: () {
                key.currentState?.reset(); // delete filter
                setState(() {
                  filterActive(widget.keyPlatforms);
                });
              },
              child: Icon(Icons.close, size: 18, color: _color.backgroundColor),
            )
          ],
        ),
      );
    }
  }

  /// A function that that checks if all filters are empty
  /// keyPlatforms: The GlobalKey of the selected platform-filter
  /// keyType: The GlobalKey of the selected type-filter
  /// keyGenre: The GlobalKey of the selected genre-filter
  /// keyYear: The GlobalKey of the selected year-filter
  /// keyActor: The GlobalKey of the selected actor-filter
  /// return: a String message that informs the user that no filter was selected
  Widget checkAllEmptyFilters(
      GlobalKey<FormFieldState> keyPlatforms,
      GlobalKey<FormFieldState> keyType,
      GlobalKey<FormFieldState> keyGenre,
      GlobalKey<FormFieldState> keyYear,
      GlobalKey<FormFieldState> keyActor) {
    List allFilterKeys = [keyPlatforms, keyType, keyGenre, keyYear, keyActor];
    Widget emptyFilterMsg = const Text("");
    if (allFilterKeys.every((element) => element.currentState?.value == null)) {
      // if value of every Filter is noll
      emptyFilterMsg = Container(
        padding: const EdgeInsets.fromLTRB(2.0, 5.0, 5.0, 4.0),
        margin: const EdgeInsets.fromLTRB(7.0, 7.0, 0.0, 7.0),
        child: const Text("No filters selected.",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 15)),
      );
    }
    return emptyFilterMsg;
  }

  /// A function that determines the active filter(s) selected by the user and returns the filter results generated in another method
  /// keyPlatforms: The GlobalKey of the selected platform-filter
  /// keyType: The GlobalKey of the selected type-filter
  /// keyGenre: The GlobalKey of the selected genre-filter
  /// keyYear: The GlobalKey of the selected year-filter
  /// keyActor: The GlobalKey of the selected actor-filter
  /// return: The final results of the user's filter(s)
  Widget filterResults(
      GlobalKey<FormFieldState> keyPlatform,
      GlobalKey<FormFieldState> keyType,
      GlobalKey<FormFieldState> keyGenre,
      GlobalKey<FormFieldState> keyYear,
      GlobalKey<FormFieldState> keyActor) {
    List keys = [keyPlatform, keyType, keyGenre, keyYear, keyActor];
    List activeFilters = []; // the list of active filters
    Widget filterResult = Container();

    // Checking for active Filters before generating the filter results:
    for (var element in keys) {
      var keyValue = element.currentState.value;
      if (keyValue != null) {
        activeFilters.add(element.currentState.value);
      }
    }

    filterResult = generateResults(activeFilters);

    return filterResult;
  }

  /// A function that generates the results of the selected filter(s) by the user
  /// activeFilters: The list of active filters that have to be observed to generate the filter results
  /// return: The filtered movies and/or series Column-widget
  Widget generateResults(List activeFilters) {
    List movies = allStreams
        .where((element) => (element.type.toString() == "Movie"))
        .toList(); // List of all potential movies
    List series = allStreams
        .where((element) => (element.type.toString() == "Series"))
        .toList(); // List of all potential series

    List filteredStreams = checkAllFilters(
        [], activeFilters, movies + series); // List before filtering
    List filteredMovies = filteredStreams
        .where((element) => element.type.contains("Movie"))
        .toList(); // Filtered movies list
    List filteredSeries = filteredStreams
        .where((element) => element.type.contains("Series"))
        .toList(); // Filtered series list

    var type = widget
        .keyType.currentState?.value; // actual type (null, Movie or Series)

    Widget result = Container();

    if (type == null) {
      // No type selected, i.e. both types (Movie and Series)
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
      // Type "Movie" selected:
      result = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          filterLabel("Movies"),
          filterEmptyList(filteredMovies),
          filteredResults(filteredMovies, filteredStreams, "Movies"),
        ],
      );
    } else {
      // Type "Series" selected:
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

  /// A function that generates a headline above the determined filtered movies or series
  /// label: The label of the headline for the currently checked list (movies or series list)
  Text filterLabel(String label) => Text(label,
      style: TextStyle(
          color: _color.bodyTextColor,
          fontSize: 18.0,
          fontWeight: FontWeight.bold));

  /// A function that checks if a list is empty or not and thus determines the space below the label
  /// filtered: A list of movies or series
  SizedBox filterEmptyList(List filtered) => filtered.isNotEmpty
      ? const SizedBox(height: 10.0)
      : const SizedBox(height: 0.0);

  /// A function that checks if the filtered list (either movie or series list, not both) is empty after filtering,
  /// if not: a List View with the found streams is returned
  /// otherwise: a message that indicates that no filter results have been found is returned
  /// filtered: A list of movies or series (a part of "filteredStreams", i.e. filteredStreams is divided in movies and series)
  /// filteredStreams: The final filtered list after each filter has been selected (includes movies and series)
  /// label: The label of the current checked list (Movies or Series)
  Widget filteredResults(List filtered, List filteredStreams, String label) =>
      SizedBox(
          height: filtered.isNotEmpty ? 210 : 30,
          child: filtered
              .isNotEmpty // if the movies or series list is not empty after filtering, return the results
              ? ListView.builder(
              itemCount: filtered.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                String currentTitle = filtered.elementAt(index).title; // title of current stream
                if (filteredStreams.isNotEmpty) {
                  // If the general filtered list (i.e. includes movies and series) is not empty, tiles for found movies or series can be generated:
                  Streams currentStream = filtered.elementAt(index);
                  StreamPosterTile currentTile = StreamPosterTile(
                    stream: currentStream,
                    imageUrl: currentStream.image,
                    title: currentTitle,
                  );
                  return currentTile;
                } else {
                  // If the general filtered list (i.e. includes movies and series) is empty, no results can be found:
                  return Container();
                }
              })
              : Text("    No $label found.",
              // if the movies or series list is empty, return a message to indicate that
              style: TextStyle(
                  color: _color.bodyTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.8)));


  /// A function that includes all methods to check each filter
  /// filteredList: The list that will be filtered throughout the whole method (empty at the beginning)
  /// activeFilters: The active filters that have to be observed to generate the filter results
  /// allStreams: The list with all possible streams to start the filtering process
  /// return: The final filtered list after each (or no) filter has been selected
  List checkAllFilters(List filteredList, List activeFilters, List allStreams) {
    filteredList = checkPlatformFilter(allStreams, activeFilters);
    filteredList = checkTypeFilter(filteredList, activeFilters);
    filteredList = checkGenreFilter(filteredList, activeFilters);
    filteredList = checkYearFilter(filteredList, activeFilters);
    filteredList = checkActorFilter(filteredList, activeFilters);
    return filteredList;
  }

  /// A function that checks if and what platform filter is selected
  /// filtered: The current filtered list
  /// activeFilters: The active filter values that have to be observed to generate the filter results
  /// return: The new filtered list after the (selected) platform filter
  List checkPlatformFilter(List filtered, List activeFilters) {
    if (widget.keyPlatforms.currentState?.value != null) { // if filter has a value, i.e. has been selected
      for (var key in activeFilters) { // check all filter values
        if (_cav.platforms.contains(key)) { // if one filter value is a platform value ...
          filtered.removeWhere((element) => !(element.provider.contains(key))); // ... remove the streams from other platforms
        }
      }
    }
    return filtered;
  }

  /// A function that checks if and what type filter is selected
  /// filtered: The current filtered list
  /// activeFilters: The active filter values that have to be observed to generate the filter results
  /// return: The new filtered list after the (selected) type filter
  List checkTypeFilter(List filtered, List activeFilters) {
    if (widget.keyType.currentState?.value != null) { // if filter has a value, i.e. has been selected
      for (var key in activeFilters) { // check all filter values
        if (_cav.types.contains(key)) { // if one filter value is a type value ...
          filtered.removeWhere((element) => !(element.type.contains(key))); // ... remove the streams of other types
        }
      }
    }
    return filtered;
  }

  /// A function that checks if and what genre filter is selected
  /// filtered: The current filtered list
  /// activeFilters: The active filter values that have to be observed to generate the filter results
  /// return: The new filtered list after the (selected) genre filter
  List checkGenreFilter(List filtered, List activeFilters) {
    if (widget.keyGenre.currentState?.value != null) { // if filter has a value, i.e. has been selected
      for (var key in activeFilters) { // check all filter values
        if (_cav.genres.contains(key)) { // if one filter value is a genre value ...
          filtered.removeWhere((element) => !(element.genre.contains(key))); // ... remove the streams of other genres
        }
      }
    }
    return filtered;
  }

  /// A function that checks if and what year filter is selected
  /// filtered: The current filtered list
  /// activeFilters: The active filter values that have to be observed to generate the filter results
  /// return: The new filtered list after the (selected) year filter
  List checkYearFilter(List filtered, List activeFilters) {
    if (widget.keyYear.currentState?.value != null) { // if filter has a value, i.e. has been selected
      for (var key in activeFilters) { // check all filter values
        if (_cav.years.contains(key)) { // if one filter value is a year value ...
          filtered.removeWhere((element) => !(element.year.contains(key))); // ... remove the streams from other years
        }
      }
    }
    return filtered;
  }

  /// A function that checks if and what actor filter is selected
  /// filtered: The current filtered list
  /// activeFilters: The active filter values that have to be observed to generate the filter results
  /// return: The new filtered list after the (selected) actor filter
  List checkActorFilter(List filtered, List activeFilters) {
    if (widget.keyActor.currentState?.value != null) { // if filter has a value, i.e. has been selected
      for (var key in activeFilters) { // check all filter values
        if (_actors.contains(key)) { // if one filter value is an actor value ...
          filtered.removeWhere((element) => !(element.cast.contains(key))); // ... remove the streams with other actors
        }
      }
    }
    return filtered;
  }
}