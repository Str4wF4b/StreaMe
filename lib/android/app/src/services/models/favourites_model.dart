import 'package:cloud_firestore/cloud_firestore.dart';

class FavouritesModel {
  final String? id;
  final String streamId;
  final String title;
  final String type;

  const FavouritesModel(
      {this.id,
      required this.streamId,
      required this.title,
      required this.type});

  /// A function that returns the Json value of the favourited Stream to store it into Firestore DB
  toJson() => {"StreamId": streamId, "Title": title, "Type": type};

  /// A function that fetches data in a map from Firebase to FavouritesModel
  factory FavouritesModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return FavouritesModel(
        id: document.id,
        streamId: data["StreamId"],
        title: data["Title"],
        type: data["Type"]);
  }
}
