import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/actor_data.dart';
import 'package:stream_me/android/app/src/pages/others/filter_results.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/constants_and_values.dart';
import '../../widgets/global/selection_button.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final ConstantsAndValues _cav = ConstantsAndValues();

  // Instances:
  final GlobalKey<FormFieldState> _keyPlatforms = GlobalKey();
  final GlobalKey<FormFieldState> _keyType = GlobalKey();
  final GlobalKey<FormFieldState> _keyGenre = GlobalKey();
  final GlobalKey<FormFieldState> _keyYear = GlobalKey();
  final GlobalKey<FormFieldState> _keyActor = GlobalKey();

  // Local instances:
  final List<String> _actors = [];
  String? _value;

  @override
  void initState() {
    super.initState();

    for (var actor in allActors) {
      _actors.add(actor.displayName);
    } // fill actors list
    _cav.years.sort((b, a) => a.compareTo(b)); // sort years in descending order
    _actors.sort((a, b) => a.toLowerCase().compareTo(
        b.toLowerCase())); // sort actors list in alphabetically ascending order
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color.backgroundColor.withOpacity(0.93),
      width: MediaQuery.of(context).size.width, // full window width
      height: MediaQuery.of(context).size.height, // full window height

      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 33),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.tune, color: _color.bodyTextColor, size: 30),
            const SizedBox(width: 10),
            Text(
              "Filters",
              style: TextStyle(
                  color: _color.bodyTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
              textAlign: TextAlign.start,
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0, bottom: 90.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Actual filters:
                const SizedBox(height: 100.0),
                // Streaming Platforms, e.g Netflix, Prime:
                makeFilter(_value, _cav.platforms, "Streaming Platforms",
                    _keyPlatforms),
                const SizedBox(height: 25.0),

                // Type, i.e. Movie or Series:
                makeFilter(_value, _cav.types, "Type", _keyType),
                const SizedBox(height: 25.0),

                // Genre, e.g. Action, Drama:
                makeFilter(_value, _cav.genres, "Genre", _keyGenre),
                const SizedBox(height: 25.0),

                // Years, from 1895 to 2024:
                makeFilter(_value, _cav.years, "Year", _keyYear),
                const SizedBox(height: 25.0),

                // All actors:
                makeFilter(_value, _actors, "Actor", _keyActor),
                const SizedBox(height: 45),

                Padding(
                  padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Search Button:
                      SelectionButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FilterResultsPage(
                                        keyPlatforms: _keyPlatforms,
                                        keyType: _keyType,
                                        keyGenre: _keyGenre,
                                        keyYear: _keyYear,
                                        keyActor: _keyActor)));
                          },
                          color: Colors.blueAccent,
                          label: "Search"),
                      // Reset Button:
                      SelectionButton(
                          onTap: () {
                            // Clear all Dropdown Form Field inputs:
                            _keyPlatforms.currentState?.reset();
                            _keyType.currentState?.reset();
                            _keyGenre.currentState?.reset();
                            _keyYear.currentState?.reset();
                            _keyActor.currentState?.reset();
                          },
                          color: Colors.red.shade400,
                          label: "Reset"),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        // Close Button:
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 590, bottom: 15.0),
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: _color.middleBackgroundColor,
                  )),
            ),
          ),
        ),
      ]),
    );
  }

  /// A function that generates a filter to choose between different options inside a DropdownButtonFormField
  /// selectedValue: The currently selected value by a user
  /// list: The list of all selectable options
  /// label: The initial label of the Dropdown Button Form Field
  /// keyController: The key of the currently used filter
  Center makeFilter(String? selectedValue, List<String> list, String label,
      GlobalKey keyController) => Center(
      child: Container(
        width: 330,
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        child: DropdownButtonFormField2<String>(
          key: keyController,
          isExpanded: true,
          value: selectedValue,
          // selected value stands in field
          items: list.map(buildMenuItem).toList(),
          // dropdown items
          dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                  color: _color.middleBackgroundColor,
                  borderRadius: BorderRadius.circular(20.0)),
              maxHeight: MediaQuery.textScalerOf(context).scale(202)),
          onChanged: (value) {
            setState(() {
              selectedValue = value
                  .toString(); // change current value to new selected value inside Dropdown menu
            });
          },
          // Decoration of the Dropdown Button including label and border decorations:
          decoration: InputDecoration(
            labelText: label,
            contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 12.0, 20.0),
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                fontSize: 18),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(30.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(30.0)),
            filled: true,
            fillColor: Colors.black38,
          ),
        ),
      ),
    );

  /// A function that builds the selected item from the Dropdown menu
  /// item: The item selected by the user
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: FittedBox(
        child: Text(
          item,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.grey.shade100),
        ),
      ));
}
