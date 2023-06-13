import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class ForgotPasswordController extends ControllerMVC {

  /**
   * A function that returns a popup if a password reset link is sent to the entered email
   */
  void wrongInputPopup(BuildContext context, bool correctMail, TextEditingController emailController) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            checkMail(correctMail),
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
                checkMailContent(correctMail, emailController),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          contentPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 5.0),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context, checkMessage(correctMail, emailController)),
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(20.0))),
                child: Text(checkMessage(correctMail, emailController)),
              ),
            )
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              side: BorderSide(color: Colors.blueAccent, width: 2.0)),
        );
      },
    );
  }

  /**
   * A function that simply checks if the entered mail is correct or not and returns the corresponding title in the popup
   */
  String checkMail(bool correctMail) {
    if (correctMail) {
      return "Password resetted.";
    } else {
      return "Wrong Email";
    }
  }

  /**
   * A function that simply checks if the entered mail is correct or not and returns the corresponding content in the popup
   */
  String checkMailContent(bool correctMail, TextEditingController emailController) {
    if (correctMail) {
      return "A Password reset link has been sent to ${emailController.text}.";
    } else {
      return "The Email is not correct. Please try again.";
    }
  }

  /**
   * A function that simply checks if the entered mail is correct or not, resets the input of the TextField and returns the corresponding button in the popup
   */
  String checkMessage(bool correctMail, TextEditingController emailController) {
    if (correctMail) {
      emailController.text = "";
      return "Back";
    } else {
      return "Try again";
    }
  }
}