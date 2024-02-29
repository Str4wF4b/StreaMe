import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';

class AuthService {
  final UserData _userData = UserData();

  // Google sign in:
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // get auth details from request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // if auth request is good, create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    String firstUsername = googleUser.email.substring(0, googleUser.email.indexOf("@")); //First username is the mail name till @-character
    String firstFullName = googleUser.displayName.toString(); //empty
    final user = UserModel(username: firstUsername,
        fullName: firstFullName,
        email: googleUser.email,
        password: "");
    _userData.createUserSetup(user);

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
}
