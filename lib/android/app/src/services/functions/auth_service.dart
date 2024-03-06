import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';

class AuthService {
  final UserData _userData = UserData();
  final _auth = FirebaseAuth.instance;

  // Google sign in:
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Get auth details from request:
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // If auth request is good, create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Check if user with same email is already registered:
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    if (authResult.additionalUserInfo!.isNewUser) {
      // First username is email before the @-character,
      // first full name is the display name from the google account
      String firstUsername =
          googleUser.email.substring(0, googleUser.email.indexOf("@"));
      String firstFullName = googleUser.displayName.toString(); //empty
      handleUserData(firstUsername, firstFullName, googleUser.email);
    }

    // sign in with new credential of user
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //TODO: Apple sign in

  // Apple sign in:
  signInWithApple() async {}

  // Anonymous sign in:
  Future signInAnon() async {
    try {
      UserCredential anonCredential =
          await FirebaseAuth.instance.signInAnonymously();
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

  void handleUserData(String username, String fullName, String email) {
    final user = UserModel(
        username: username, fullName: fullName, email: email, password: "", imageUrl: "");
    _userData.createUserSetup(user);
  }
}
