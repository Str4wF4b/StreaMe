import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:stream_me/android/app/src/model/login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stream_me/android/app/src/view/home_page.dart';
import 'package:stream_me/android/app/src/view/login_page.dart';

class LoginController extends ControllerMVC {
  final FirebaseAuth _auth = FirebaseAuth.instance; // object

  /**
   * A function that returns a popup if the email or password is wrong when logging in
   */
  void wrongInputPopup(String input, BuildContext context, bool isLogin) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            checkLoginOrRegisterTitle(isLogin),
            style: const TextStyle(fontSize: 18.0),
            textAlign: TextAlign.center,
          ),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Divider(
              thickness: 0.5,
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                checkLoginOrRegisterContent(isLogin, input),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 5.0),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, "Try again"),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20.0))),
                child: const Text("Try again"),
              ),
            )
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.red, width: 3.0)),
        );
      },
    );
  }

  String checkLoginOrRegisterTitle(bool isLogin) {
    if (isLogin) {
      return "Login not possible.";
    } else {
      return "Registration not possible.";
    }
  }

  String checkLoginOrRegisterContent(bool isLogin, String input) {
    if (isLogin) {
      return "The $input is not correct. Please try again.";
    } else {
      return "The passwords do not match. Please try again.";
    }
  }

/*
  void signUserIn(TextEditingController emailController, TextEditingController passwordController, BuildContext context) async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // sign in try
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text);
      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);

      // if email is wrong:
      if (e.code == "user-not-found") {
        wrongInputPopup("Email", context);
        //widget.emailController.text = "Wrong Email.";
        // if password is wrong:
      } else if (e.code == "wrong-password") {
        wrongInputPopup("Password", context);
      } else if (e.code == "user-not-found" && e.code == "wrong-password") {
        //wrongEmailPopup();
      }
    }

    // Navigator.pop(context);
  }
  */

/*
  Padding loginTextField(TextEditingController inputController,
      bool obscureText, String hintText, IconData prefixIcon/*, Icon suffixIcon*/) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: inputController, // get user's input
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(prefixIcon, size: 28),
            prefixIconColor: Colors.grey,
            /*suffixIcon:
                checkIconButton(suffixIcon, inputController, obscureText),*/
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(20.0)),
            filled: true,
            fillColor: Colors.grey.shade300,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey)),
      ),
    );
  }
  */

/*
  Widget checkIconButton(
      Icon icon, TextEditingController controller, bool obscureText) {
    obscureText = this.obscureText;
    if (icon.toString() == const Icon(Icons.remove_red_eye).toString()) {
      // check if suffixIcon is the needed one or not
      print(obscureText);
      return ToggleWidgets(obscureText: obscureText);
    } else {
      return IconButton(
          onPressed: null,
          icon: icon,
          disabledColor:
              Colors.transparent); // disable other not needed suffixIcon
    }
  }
  */

/*
  GestureDetector signInButton() {
    return GestureDetector(
      onTap: signUserIn,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        // padding inside button
        margin: const EdgeInsets.symmetric(horizontal: 100.0),
        // padding outside button
        decoration: BoxDecoration(
            //border: Border.all(color: Colors.white70),
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(30.0)),
        child: const Center(
            child: Text("Sign In",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0))),
      ),
    );
  }
   */

/*
  Padding loginDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: const [
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.white70,
          )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Or continue with",
              style: TextStyle(color: Colors.white60),
            ),
          ),
          Expanded(child: Divider(thickness: 0.5, color: Colors.white70))
        ],
      ),
    );
  }
   */
}
