import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_me/android/app/src/services/models/favourites_model.dart';

class FavouritesData {
  // Database:
  final _db = FirebaseFirestore.instance;

  /// A function that adds a movie or series to the Favourites-collection
  /// userId: The current user document id
  /// favourite: The movie or series with its streamId, title and type that should be added to Favourites
  Future<void> addToFavourites(String userId, FavouritesModel favourite) async {
    await _db
        .collection("Users")
        .doc(userId)
        .collection("Favourites")
        .add(favourite.toJson());
  }

  /// A function that deletes a movie or series from the Favourites-collection
  /// userId: The current user document id
  /// streamId: The current stream document id
  Future<void> removeFromFavourites(String userId, String streamId) async {
    final snapshot = await _db
        .collection("Users")
        .doc(userId)
        .collection("Favourites")
        .where("StreamId", isEqualTo: streamId)
        .get();
    final removeFavourite =
        snapshot.docs.map((e) => FavouritesModel.fromSnapshot(e)).single;
    await _db
        .collection("Users")
        .doc(userId)
        .collection("Favourites")
        .doc(removeFavourite.id)
        .delete();
  }

  /// A function that fetches the movies or series from a user's Favourites-collection
  /// userId: The current user document id
  Future<List<FavouritesModel>> getFavourites(String userId) async {
    final snapshot = await _db
        .collection("Users")
        .doc(userId)
        .collection("Favourites")
        .get();
    final favouritesData =
        snapshot.docs.map((e) => FavouritesModel.fromSnapshot(e)).toList();
    return favouritesData;
  }
}
