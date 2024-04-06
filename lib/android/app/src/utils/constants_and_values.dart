import 'package:flutter/material.dart';

class ConstantsAndValues {
  Widget streamImagePlaceholder = Transform.scale(
      scale: 0.5,
      child: const CircularProgressIndicator(
          color: Colors.blueAccent)); // only for square image covers
  Widget actorDirectorPlaceholder = Transform.scale(
      scaleX: 0.25,
      scaleY: 0.16, //0.285,
      child: const CircularProgressIndicator(
          color: Colors
              .blueAccent)); // only for actor and director images in ActorDirector Screen
  Widget explorePlaceholder = Transform.scale(
      scale: 1,
      child: const CircularProgressIndicator(
          color: Colors.blueAccent)); // only for image covers in Explore Tab
  Widget streamDetailsPlaceholder = Transform.scale(
      scaleX: 0.215,
      scaleY: 0.25,
      child: const CircularProgressIndicator(
          color: Colors
              .blueAccent)); // only for image cover in StreamDetails Screen;

  double textHeight = 1.24; // height for 2-lined texts

  Widget imageErrorWidget =
      const Icon(Icons.error_outline, color: Colors.redAccent, size: 40);
  Widget imageErrorWidgetLittle =
      const Icon(Icons.error_outline, color: Colors.redAccent, size: 30);

  final List<String> platforms = [
    // List of all provider platforms
    "Apple TV",
    "Apple TV+",
    "Crunchyroll",
    "Disney+",
    "Hulu",
    "Magenta TV",
    "Netflix",
    "Prime",
    "Sky Go"
  ];

  List<String> types = ["Movie", "Series"]; // List of all Stream types

  final List<String> genres = [
    // List of all Stream genres
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

  final List<String> years = List<String>.generate(
      130, (index) => "${index + 1895}"); // List of years from 1895 to 2024
}
