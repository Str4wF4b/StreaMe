import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String? id;
  final String streamId;
  final String title;
  final String type;
  final double rating;

  const RatingModel(
      {this.id,
      required this.streamId,
      required this.title,
      required this.type,
      required this.rating});

  /// A function that returns the Json value of the rated Stream to store it into Firestore DB
  toJson() =>
      {"StreamId": streamId, "Title": title, "Type": type, "Rating": rating};

  /// A function that fetches data in a map from Firebase to RatingModel
  factory RatingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return RatingModel(
        id: document.id,
        streamId: data["StreamId"],
        title: data["Title"],
        type: data["Type"],
        rating: data["Rating"]);
  }
}
