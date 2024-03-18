import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_me/android/app/src/services/models/favourites_model.dart';

class FavouritesData {
  final _db = FirebaseFirestore.instance;

  /// A function that adds a movie or series to the Favourites-collection
  /// id: The current document id
  /// favourite: The movie or series with its streamId, title and type that should be added to Favourites
  Future<void> addToFavourites(String id, FavouritesModel favourite) async {
    await _db
        .collection("Users")
        .doc(id)
        .collection("Favourites")
        .add(favourite.toJson());
  }

  /// A function that deletes a movie or series from the Favourites-collection
  /// id: The current document id
  /// streamId: The current stream id
  /// favourite: The movie or series with its streamId, title and type that should be deleted from Favourites
  Future<void> removeFromFavourites(String id, String streamId, FavouritesModel favourites) async {
    final snapshot = await _db.collection("Users").doc(id).collection("Favourites").where("StreamId", isEqualTo: streamId).get();
    final removeFavourite = snapshot.docs.map((e) => FavouritesModel.fromSnapshot(e)).single;
    await _db.collection("Users").doc(id).collection("Favourites").doc(removeFavourite.id).delete();
  }

  /// A function that fetches the movies or series from a user's Favourites-collection
  /// id: The current document id
  Future<List<FavouritesModel>> getFavourites(String id) async {
    final snapshot = await _db.collection("Users").doc(id).collection("Favourites").get();
    final favouritesData = snapshot.docs.map((e) => FavouritesModel.fromSnapshot(e)).toList();
    return favouritesData;
  }
}
