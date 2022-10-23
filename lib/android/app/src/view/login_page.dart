import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  final String title = "Login";
  final String subtitle = "Do something";

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginController logCon = LoginController();


// TODO: Move functionality to controller (separate the code into MVC pattern)
// TODO: Connect with Firebase/Firestore DB (https://github.com/NearHuscarl/flutter_login/issues/162#issuecomment-869908814)

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: "TEST LOGIN",
      navigateBackAfterRecovery: true,

      loginAfterSignUp: false,

      userValidator: (value) {
        if (!value!.contains('@') || !value.endsWith('.com')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        //return _loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (var element in signupData.termsOfService) {
            debugPrint(
                ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}');
          }
        }
        //return _signupUser(signupData);
      },
      /*onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(FadePageRoute(
          builder: (context) => const DashboardScreen(),
        ));
      },*/
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        //return _recoverPassword(name);
        // Show new password dialog
      },
      //showDebugButtons: true,
    );
  }
}