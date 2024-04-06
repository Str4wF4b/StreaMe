import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_me/android/app/src/services/models/rating_model.dart';

class RatingData {
  // Database:
  final _db = FirebaseFirestore.instance;

  /// A function that adds a movie or series to the Rating-collection
  /// userId: The current user document id
  /// rating: The movie or series with its streamId, title and type that should be added to Ratings
  Future<void> addToRatings(String userId, RatingModel rating) async {
    await _db
        .collection("Users")
        .doc(userId)
        .collection("Ratings")
        .add(rating.toJson());
  }

  /// A function that fetches the movies or series from a user's Ratings-collection
  /// userId: The current user document id
  Future<List<RatingModel>> getUserRating(String userId) async {
    final snapshot =
        await _db.collection("Users").doc(userId).collection("Ratings").get();
    final ratingData =
        snapshot.docs.map((e) => RatingModel.fromSnapshot(e)).toList();
    return ratingData;
  }

  /// A function that updates a user's rating for a movie or series
  /// rating: The RatingModel with the stream's id, streamId, title, type and rating
  /// userId: The current user document id
  /// ratingId: The current rating document id
  Future<void> updateRating(
      RatingModel rating, String userId, String ratingId) async {
    await _db
        .collection("Users")
        .doc(userId)
        .collection("Ratings")
        .doc(ratingId)
        .update(rating.toJson());
  }

  /// A function that fetches all Ratings from Firestore DB
  /// streamId: The current stream document id
  Future<List<RatingModel>> getAllStreamRatings(String streamId) async {
    final snapshot = await _db
        .collectionGroup("Ratings")
        .where("StreamId", isEqualTo: streamId)
        .get();
    final ratingData =
        snapshot.docs.map((e) => RatingModel.fromSnapshot(e)).toList();
    return ratingData;
  }
}
