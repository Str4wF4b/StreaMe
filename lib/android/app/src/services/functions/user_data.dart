import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserData {
  // Database:
  final _db = FirebaseFirestore.instance;

  /// A function that signs the user up with its email and password
  /// email: The email of the user which he signed up with
  /// password: The password of the user which he signed up with
  Future<void> registerUser(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  /// A function that signs the user in with its email and password
  /// email: The email of the user which he attempted to sign in with
  /// password: The password of the user which he attempted to sign in with
  Future<void> loginUser(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  /// A function that saves a new registered user to the Firestore DB
  /// user: The UserModel with the user's username, full name, email and password
  Future<void> createUserSetup(UserModel user) async {
    await _db.collection("Users").add(user.toJson());
  }

  /// A function that fetches a user's data from Firestore DB by identifying with its email
  /// email: The unique email of a user with which one can fetch its unique user data
  Future<UserModel> getUserData(String email) async {
    final snapshot = await _db
        .collection("Users")
        .where("Email", isEqualTo: email)
        .get(); // get the current user data based on the email
    final userData = snapshot.docs
        .map((e) => UserModel.fromSnapshot(e))
        .single; // map data to convert it
    return userData;
  }

  /// A function that fetches all user's data from Firestore DB
  Future<List<UserModel>> getAllUserData() async {
    final snapshot =
        await _db.collection("Users").get(); // get data from all users
    final userData = snapshot.docs
        .map((e) => UserModel.fromSnapshot(e))
        .toList(); // map data to convert it
    return userData;
  }

  /// A function that updates a user's data from its UserModel
  /// user: The UserModel with the user's username, full name, email and password
  Future<void> updateUserData(UserModel user) async {
    await _db.collection("Users").doc(user.id).update(user.toJson());
  }
}
