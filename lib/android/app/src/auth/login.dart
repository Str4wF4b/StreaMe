import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import 'package:stream_me/android/app/src/widgets/features/login_divider.dart';
import '../services/functions/auth_popups.dart';
import '../widgets/features/login_sign_buttons.dart';
import '../widgets/features/login_text_field.dart';
import '../widgets/features/login_tile.dart';
import '../services/functions/auth_service.dart';
import '../services/functions/user_data.dart';
import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final Images _image = Images();

  // Instances:
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthPopups _popup = AuthPopups();

  // Database:
  final UserData _userData = UserData();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.deepOrangeAccent,
          _color.backgroundColor,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ListView(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(
                    // Logo on top of screen:
                    _image.streameIcon,
                    width: 200,
                  ),
                  const SizedBox(height: 50),
                  LoginTextField(
                      // Email Textfield:
                      inputController: _emailController,
                      obscureText: false,
                      hintText: "Email",
                      prefixIcon: Icons.person),
                  const SizedBox(height: 13),
                  LoginTextField(
                      // Password Textfield:
                      inputController: _passwordController,
                      obscureText: true,
                      hintText: "Password",
                      prefixIcon: Icons.lock),
                  const SizedBox(height: 18),
                  // Forgot Password Button:
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ForgotPasswordPage(); // go to Forgot Password Page
                          },
                        ),
                      );
                    },
                    child: const Text("Forgot Password?",
                        style: TextStyle(color: Colors.white60)),
                  ),
                  const SizedBox(height: 30),
                  // Sign In Button:
                  SignButton(onTap: signInUser, text: "Sign In"),
                  const SizedBox(height: 55),
                  LoginDivider(),
                  const SizedBox(height: 55),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 3 Login Tiles with 3 Sign Methods:
                      // Google Sign In:
                      LoginTile(
                          imagePath: _image.google,
                          onTap: () => AuthService().signInWithGoogle()),
                      const SizedBox(width: 12),
                      // Apple Sign In:
                      LoginTile(
                          imagePath: _image.apple,
                          onTap: () => AuthService().signInWithApple()),
                      const SizedBox(width: 12),
                      // Anonymous Sign In:
                      LoginTile(
                          imagePath: _image.anon,
                          onTap: () => AuthService().signInAnon()),
                    ],
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Not a member yet?",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 4),
                      // Register Button (clickable Text):
                      GestureDetector(
                        onTap: widget.onTap, // open Register Page
                        child: const Text("Register now",
                            style: TextStyle(color: Colors.lightBlue)),
                      )
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  /// A function that tries to sign in a already registered user
  /// It checks if the email or password or both is wrong, if not: the user is signed in
  void signInUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
              color: Colors.blueAccent), // show loading circle
        );
      },
    );

    // Sign in try:
    try {
      await _userData.loginUser(
          _emailController.text, _passwordController.text);
      if (mounted) Navigator.pop(context); // pop loading circle
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.pop(context); // pop loading circle

      // If email is wrong:
      if (e.code == "user-not-found") {
        if (mounted) _popup.wrongInputPopup("Email", context, true);
        // If password is wrong:
      } else if (e.code == "wrong-password") {
        if (mounted) _popup.wrongInputPopup("Password", context, true);
      } else if (e.code == "user-not-found" && e.code == "wrong-password") {}
    }
  }
}
