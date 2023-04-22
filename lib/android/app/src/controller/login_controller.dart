import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:stream_me/android/app/src/model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginController extends ControllerMVC {

  final FirebaseAuth _auth = FirebaseAuth.instance; // object

  Future signInAnon() async {
    try {
      UserCredential anonCredential = await _auth.signInAnonymously();
      User? user = anonCredential.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //TODO: Sign in with e-mail & password

  //TODO: Sign in with Google

  //TODO: Register with e-mail & password

  //TODO: Register with Google

  //TODO: Sign out

}