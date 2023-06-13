import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google sign in:
  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // get auth details from request
    final GoogleSignInAuthentication googleAuth = await googleUser!
        .authentication;

    // if auth request is good, create new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // sign in with new credential of user
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //TODO: Apple sign in

  // Apple sign in:
  signInWithApple() async {

  }

  // Anonymous sign in:
  Future signInAnon() async {
    try {
      UserCredential anonCredential = await FirebaseAuth.instance
          .signInAnonymously();
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