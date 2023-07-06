import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_me/android/app/src/data/stream_data.dart';
import 'package:stream_me/android/app/src/view/filter_results.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key? key}) : super(key: key);

  final Color middleBackgroundColor = const Color.fromRGBO(44, 40, 40, 1.0);
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
  String? value;
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
  final List<String> actors = [
    "Hailee Steinfeld",
    "Shameik Moore",
    "Oscar Isaac",
    "Keir Gilchrist",
    "Brigette Lundy-Paine",
    "Jennifer Jason Leigh",
    "Michael Rapaport",
    "Kento Yamazaki",
    "Tao Tsuchiya",
    "Nijiro Murakami",
    "Morgan Freeman",
    "Brad Pitt",
    "Gwyneth Paltrow",
    "Natsuki Hanae",
    "Akari Kito",
    "Daniel Craig",
    "Ana de Armas",
    "Christopher Plummer",
    "Chris Evans",
    "Patrick Wilson",
    "Vera Farmiga",
    "Dylan O'Brien",
    "Kaya Scodelario",
    "Thomas Brodie-Sangster",
    "Will Poulter",
    "Jason Sudeikis",
    "Brett Goldstein",
    "Juno Temple",
    "Madison Wolfe",
    "Frances O'Connor"
  ];

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    widget.actors.sort((a, b) => a.toLowerCase().compareTo(
        b.toLowerCase())); //sort actors list before loading filter widget

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
            Icon(Icons.tune, color: Colors.grey.shade300, size: 30),
            const SizedBox(width: 10),
            Text(
              "Filters",
              style: TextStyle(
                  color: Colors.grey.shade300,
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
                makeFilter(
                    widget.value, widget.provider, "Streaming Platforms"),
                //Streaming Platform, e.g Netflix, Prime
                const SizedBox(height: 25.0),
                makeFilter(widget.value, widget.type, "Type"),
                //Type, i.e. Movie or Series
                const SizedBox(height: 25.0),
                makeFilter(widget.value, widget.genre, "Genre"),
                //Genre, e.g. Action, Drama
                const SizedBox(height: 25.0),
                Center(
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
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.normal),
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
                ),
                const SizedBox(height: 25.0),
                makeFilter(widget.value, widget.actors, "Actor"),
                //search an Actor in the whole Database
                const SizedBox(height: 30),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilterResultsPage()));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      margin: const EdgeInsets.symmetric(horizontal: 100.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade800,
                          border: Border.all(
                              color: Colors.grey.shade400, width: 1.5),
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text(
                        "Search filters",
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                      ),
                    ))
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
                    color: widget.middleBackgroundColor,
                  )),
            ),
          ),
        ),
      ]),
    );
  }

  String? checkValue(String? value) {
    if (value == "None") {
      return null;
    }
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
          dropdownColor: widget.middleBackgroundColor,
          borderRadius: BorderRadius.circular(20.0),
          //selectedItemBuilder: ,
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          isExpanded: true,
          //Decoration of the label and border of the dropdown button
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade400,
                fontSize: 18),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(20.0)),
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
