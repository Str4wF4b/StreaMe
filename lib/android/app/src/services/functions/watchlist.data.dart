import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_me/android/app/src/services/models/watchlist_model.dart';

class WatchlistData {
  // Database:
  final _db = FirebaseFirestore.instance;

  /// A function that adds a movie or series to the Watchlist-collection
  /// userId: The current user document id
  /// watchlist: The movie or series with its streamId, title and type that should be added to Watchlist
  Future<void> addToWatchlist(String userId, WatchlistModel watchlist) async {
    await _db
        .collection("Users")
        .doc(userId)
        .collection("Watchlist")
        .add(watchlist.toJson());
  }

  /// A function that deletes a movie or series from the Watchlist-collection
  /// userId: The current user document id
  /// streamId: The current stream document id
  Future<void> removeFromWatchlist(String userId, String streamId) async {
    final snapshot = await _db
        .collection("Users")
        .doc(userId)
        .collection("Watchlist")
        .where("StreamId", isEqualTo: streamId)
        .get();
    final removeWatchlist =
        snapshot.docs.map((e) => WatchlistModel.fromSnapshot(e)).single;
    await _db
        .collection("Users")
        .doc(userId)
        .collection("Watchlist")
        .doc(removeWatchlist.id)
        .delete();
  }

  /// A function that fetches the movies or series from a user's Watchlist-collection
  /// userId: The current user document id
  Future<List<WatchlistModel>> getWatchlist(String userId) async {
    final snapshot =
        await _db.collection("Users").doc(userId).collection("Watchlist").get();
    final watchlistData =
        snapshot.docs.map((e) => WatchlistModel.fromSnapshot(e)).toList();
    return watchlistData;
  }
}
