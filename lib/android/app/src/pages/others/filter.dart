import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/data/actor_data.dart';
import 'package:stream_me/android/app/src/pages/others/filter_results.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import '../../widgets/global/selection_button.dart';

class FilterPage extends StatefulWidget {
  FilterPage({super.key});

  final List<String> provider = [
    "Amazon Prime",
    "Apple TV",
    "Crunchyroll",
    "Disney+",
    "Hulu",
    "Netflix",
    "SkyGo",
    "None"
  ];
  final List<String> type = ["Movie", "Series"];
  final List<String> genre = [
    "Action",
    "Adventure",
    "Animation",
    "Comedy",
    "Crime",
    "Drama",
    "Fantasy",
    "Horror",
    "Mystery",
    "Science-Fiction",
    "Thriller"
  ];

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  ColorPalette color = ColorPalette();
  final List<String> actors = [];
  final List<String> year = List<String>.generate(
      225, (index) => "${index + 1800}"); //Years 1800 to 2024
  String? _selectedValue;

  @override
  void initState() {
    super.initState();

    for (var actor in allActors) {
      actors.add(actor.displayName);
    }

    year.sort((b, a) => a.compareTo(b)); //sort years descending

    actors.sort((a, b) => a.toLowerCase().compareTo(
        b.toLowerCase())); //sort actors list before loading filter widget
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      //Container transparent to show Dialog opacity background in SearchPage
      width: MediaQuery.of(context).size.width,
      //Filter screen with full window width
      height: MediaQuery.of(context).size.height,
      //Filter screen with full window height

      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 33),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.tune, color: color.bodyTextColor, size: 30),
            const SizedBox(width: 10),
            Text(
              "Filters",
              style: TextStyle(
                  color: color.bodyTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
              textAlign: TextAlign.start,
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28.0, bottom: 90.0),
          //margin on top and bottom of the scrollable field
          child: SingleChildScrollView(
            // scrolling up and down through filters
            child: Column(
              children: [
                // Actual filters:
                const SizedBox(height: 100.0),
                //Streaming Platform, e.g Netflix, Prime:
                makeFilter(
                    _selectedValue, widget.provider, "Streaming Platforms"),
                //Type, i.e. Movie or Series:
                const SizedBox(height: 25.0),
                makeFilter(_selectedValue, widget.type, "Type"),
                //Genre, e.g. Action, Drama:
                const SizedBox(height: 25.0),
                makeFilter(_selectedValue, widget.genre, "Genre"),
                //Year, from 1800 to 2024
                const SizedBox(height: 25.0),
                makeFilter(_selectedValue, year, "Year"),
                /*Center(
                  //Year Textfield
                  child: Container(
                    width: 330,
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: TextFormField(
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.grey.shade100),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      //allow only numbers in year-textfield
                      decoration: InputDecoration(
                        labelText: "Year",
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade400,
                            fontSize: 18),
                        hintText: "Search for year",
                        contentPadding: EdgeInsets.fromLTRB(12.0, 22.0, 12.0, 22.0),
                        isDense: true,
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(20.0)),
                        filled: true,
                        fillColor: Colors.black38,
                      ),
                    ),
                  ),
                ),*/
                const SizedBox(height: 25.0),
                makeFilter(_selectedValue, actors, "Actor"),
                //search an Actor in the whole Database
                const SizedBox(height: 45),
                Padding(
                  padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectionButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FilterResultsPage()));
                          },
                          color: Colors.blueAccent,
                          label: "Search"),
                      SelectionButton(
                          onTap: () {},
                          color: Colors.redAccent,
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
                    color: color.middleBackgroundColor,
                  )),
            ),
          ),
        ),
      ]),
    );
  }

  Center makeFilter(String? selectedValue, List<String> list, String label) {
    return Center(
      child: Container(
        width: 330,
        padding: const EdgeInsets.only(left: 25.0, right: 25.0),
        //margin left and right edge
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          //selected value stands in field
          items: list.map(buildMenuItem).toList(),
          //dropdown items
          dropdownColor: color.middleBackgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          //selectedItemBuilder: ,
          onChanged: (value) {
            setState(() {
              //_selectedValue = value;
            });
          },
          isExpanded: true,
          //Decoration of the label and border of the dropdown button
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
            filled: true,
            fillColor: Colors.black38,
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.0),
        child: FittedBox(
          child: Text(
            item,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.grey.shade100),
          ),
        ),
      ));
}
