import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_me/android/app/src/data/actor_data.dart';
import 'package:stream_me/android/app/src/pages/others/filter_results.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/widgets/features/filter_text-field.dart';
import '../../widgets/global/selection_button.dart';

class FilterPageTry extends StatefulWidget {
  FilterPageTry({Key? key}) : super(key: key);

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

  @override
  State<FilterPageTry> createState() => _FilterPageTryState();
}

class _FilterPageTryState extends State<FilterPageTry> {
  ColorPalette color = ColorPalette();
  final List<String> actors = [];
  final List<SelectedListItem> _listOfCities = [
    SelectedListItem(
      name: "Tokyo",
      value: "TYO",
      isSelected: false,
    ),
    SelectedListItem(
      name: "New York",
      value: "NY",
      isSelected: false,
    ),
    SelectedListItem(
      name: "London",
      value: "LDN",
      isSelected: false,
    ),
    SelectedListItem(name: "Paris"),
    SelectedListItem(name: "Madrid"),
    SelectedListItem(name: "Dubai"),
    SelectedListItem(name: "Rome"),
    SelectedListItem(name: "Barcelona"),
    SelectedListItem(name: "Cologne"),
    SelectedListItem(name: "MonteCarlo"),
    SelectedListItem(name: "Puebla"),
    SelectedListItem(name: "Florence"),
  ];

  /// This is register text field controllers.
  final TextEditingController _fullNameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _phoneNumberTextEditingController = TextEditingController();
  final TextEditingController _cityTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _fullNameTextEditingController.dispose();
    _emailTextEditingController.dispose();
    _phoneNumberTextEditingController.dispose();
    _cityTextEditingController.dispose();
    _passwordTextEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();

    for (var actor in allActors) {
      actors.add(actor.displayName);
    }

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
            child: Column(children: [FilterTextField(
              textEditingController: _fullNameTextEditingController,
              title: "FullName",
              hint: "EnterYourName",
              isCitySelected: false
            ),
            FilterTextField(
              textEditingController: _emailTextEditingController,
              title: "Email",
              hint: "EnterYourEmail",
              isCitySelected: false
            ),
            FilterTextField(
              textEditingController: _phoneNumberTextEditingController,
              title: "PhoneNumber",
              hint: "EnterYourPhoneNumber",
              isCitySelected: false,
            ),
            FilterTextField(
              textEditingController: _cityTextEditingController,
              title: "City",
              hint: "ChooseYourCity",
              isCitySelected: true,
              cities: _listOfCities,
            ),
            FilterTextField(
              textEditingController: _passwordTextEditingController,
              title: "Password",
              hint: "AddYourPassword",
              isCitySelected: false,
            ),
            const SizedBox(
              height: 15.0,
            ),])
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
          dropdownColor: color.middleBackgroundColor,
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
