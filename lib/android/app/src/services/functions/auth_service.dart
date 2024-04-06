import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';

class AuthService {
  // Database:
  final _auth = FirebaseAuth.instance;
  final UserData _userData = UserData();

  /// A function that handles the Google Sign in
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Get auth details from request:
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // If auth request is good, create new credential for user:
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Check if user with same email is already registered:
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    if (authResult.additionalUserInfo!.isNewUser) {
      // user is actually new user
      String firstUsername = googleUser.email.substring(
          0,
          googleUser.email.indexOf(
              "@")); // first Username consists of the email name before @-character
      String firstFullName = googleUser.displayName
          .toString(); // first Full Name is the Google display name
      final ref = FirebaseStorage.instance.ref().child("person_icon.png");
      String blankPersonUrl = await ref
          .getDownloadURL(); // first profile picture is the default person icon

      handleUserData(firstUsername, firstFullName, googleUser.email,
          blankPersonUrl); // save data
    }

    // Sign in with new credential of user:
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  /// A function that handles the Google Sign in
  /// (is not working for Android Studio right now)
  signInWithApple() async {}

  /// A function that handles the anonymous Sign in
  Future signInAnon() async {
    try {
      UserCredential anonCredential = await FirebaseAuth.instance
          .signInAnonymously(); // create credential for anonymous user
      User? user = anonCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          break;
        default:
          return null;
      }
    }
  }

  /// A function that creates a new User Setup of the registered user and loads it into Firebase DB
  /// username: The username (= Google display name) of the new user
  /// fullName: The full name of the new user
  /// email: The email (= Google mail) of the new user
  /// imageUrl: The link to the profile picture of the new user (default picture)
  void handleUserData(
      String username, String fullName, String email, String imageUrl) {
    // Generate User instance:
    final user = UserModel(
        username: username,
        fullName: fullName,
        email: email,
        password: "",
        imageUrl: imageUrl);
    _userData.createUserSetup(user); // load new UserModel into DB
  }
}
