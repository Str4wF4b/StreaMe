import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import 'package:stream_me/android/app/src/widgets/global/selection_button.dart';
import '../../widgets/features/edit_text_field.dart';

enum ButtonState { init, loading, done }

class EditProfilePage extends StatefulWidget {
  EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();

  final ImagePicker _picker = ImagePicker();
}

class _EditProfilePageState extends State<EditProfilePage> {
  XFile? _imageFile;
  Images image = Images();
  bool showPassword = true;
  final ColorPalette _color = ColorPalette();

  final _user = FirebaseAuth.instance.currentUser;
  //late final Rx<User?> firebaseUser; //_authRep = Rx<User?>(widget.user);
  final _userRepo = UserData();

  ButtonState buttonState = ButtonState.init;
  late bool _notSaving;
  late bool _savingDone;

  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  //final _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    _notSaving = buttonState == ButtonState.init;
    _savingDone = buttonState == ButtonState.done;

    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: Container(
        color: _color.backgroundColor,
        padding: const EdgeInsetsDirectional.only(top: 5.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FutureBuilder(
            future: getUserProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //data is completely fetched
                if (snapshot.hasData) {
                  UserModel userData = snapshot.data as UserModel;
                  print(userData.fullName);
                  print(userData.email);
                  print(userData.password);
                  print(userData.username);
                  return ListView(
                    children: [
                      Center(
                        //centering the profile picture
                        child: Stack(
                          children: [
                            Container(
                              //container for profile picture
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  //border around profile picture
                                  width: 3,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.white.withOpacity(0.3),
                                  )
                                ],
                                shape: BoxShape.circle,
                                //profile picture in circle shape
                                image: DecorationImage(
                                    //default profile picture
                                    fit: BoxFit.cover,
                                    image: selectImage()),
                              ),
                            ),
                            Positioned(
                                //positioning the "change picture" item
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      //border around profile picture
                                      width: 1,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        spreadRadius: 2,
                                        color: Colors.white.withOpacity(0.3),
                                      )
                                    ],
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: ((builder) =>
                                            bottomProfileSheet()),
                                        backgroundColor: _color.backgroundColor,
                                      );
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        //spacing between profile picture and text field
                        height: 58,
                      ),
                      EditTextField(
                          controller: _usernameCtrl,
                          labelText: "Username: ",
                          placeholder: "Enter new Username here",
                          isPassword: false,
                          userInput: userData.username.isNotEmpty ? userData.username : ""/*"${_user?.displayName}"*/),
                      EditTextField(
                          controller: _fullNameCtrl,
                          labelText: "Full Name: ",
                          placeholder: "Enter new Full Name here",
                          isPassword: false,
                          userInput: userData.fullName.isNotEmpty ? userData.fullName : ""/*"${_user?.displayName}"*/),
                      EditTextField(
                          controller: _emailCtrl,
                          labelText: "E-Mail: ",
                          placeholder: "Enter new E-Mail address here",
                          isPassword: false,
                          userInput: userData.email/*"${_user?.email}"*/),
                      EditTextField(
                          controller: _passwordCtrl,
                          labelText: "Password: ",
                          placeholder: "Enter new Password here",
                          isPassword: true,
                          userInput: userData.password/*"●●●●●"*/),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 26.0, right: 26.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //setting space between buttons cancel and save
                          children: [
                            saveButton(),
                            /*SelectionButton(
                          onTap: () async {
                            print(
                                " ------------------------------------------------------------ ");
                            UserData().updateUserPassword(
                                _passwordCtrl.text, _emailCtrl.text);
                            // print(widget.user?.providerData.first);
                            if (_passwordCtrl.text.length > 5) {
                              await widget.user
                                  ?.updatePassword(_passwordCtrl.text);
                              //UserData().userSetup(_usernameCtrl.text, _fullNameCtrl.text, _emailCtrl.text, _passwordCtrl.text);
                            }
                            //_passwordCtrl.clear();
                          },
                          color: Colors.blueAccent,
                          label: "Save"),*/
                            SelectionButton(
                                onTap: () {
                                  _usernameCtrl.clear();
                                  _fullNameCtrl.clear();
                                  _emailCtrl.clear();
                                  _passwordCtrl.clear();
                                },
                                color: Colors.red.shade400,
                                label: "Reset"),
                            /*Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16.0, 10.0, 0.0, 0.0),
                        child: OutlinedButton(
                          //styling of cancel button
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.red.shade500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                          ),
                          onPressed: () {
                            //TODO: Delete input function
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 16.0, 0.0),
                        child: ElevatedButton(
                          //styling of save button
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 50),
                            ),
                            onPressed: () {
                              //TODO: Save input (into DB also)
                            },
                            child: const Text(
                              "Save",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white,
                              ),
                            )),
                      )*/
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  print("hier");
                  return Center(child: Text(snapshot.error.toString()));
                } else {
                  return const Center(child: Text("Something went wrong!"));
                }
              } else {
                return const Center(child: CircularProgressIndicator(color: Colors.blueAccent));
              }
            },
          ),
        ),
      ),
    );
  }

  Widget bottomProfileSheet() {
    return Container(
      height: 90.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'Choose photo from ...',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            //spacing
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 5.0, 0.0, 0.0),
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.camera_alt,
                    size: 30,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.camera);
                  },
                  label: const Text(
                    'Camera',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 16.0, 0.0),
                child: TextButton.icon(
                  icon: const Icon(
                    Icons.image,
                    size: 30,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
                  },
                  label: const Text(
                    'Gallery',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await widget._picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  ImageProvider<Object> selectImage() {
    return _imageFile == null
        ? AssetImage(image.blank)
        : FileImage(File(_imageFile!.path)) as ImageProvider;
  }

  /// The save button that changes its state into a laoding-state and done-state when clicked
  Widget saveButton() => GestureDetector(
      onTap: () async {
        setState(() => buttonState = ButtonState.loading);
        await Future.delayed(const Duration(seconds: 1));
        setState(() => buttonState = ButtonState.done);
        await Future.delayed(const Duration(seconds: 1));
        setState(() => buttonState = ButtonState.init);
      },
      child: Container(
          padding: _notSaving
              ? const EdgeInsets.only(top: 15.0, bottom: 15.0)
              : EdgeInsets.zero,
          width: 120,
          height: 53,
          decoration: BoxDecoration(
              color: _notSaving ? Colors.blueAccent : Colors.transparent,
              //removing the left and right background color after the button is pressed
              borderRadius: BorderRadius.circular(30.0)),
          child: _notSaving
              ? const Center(
                  child: Text("Save",
                      style: TextStyle(
                          letterSpacing: 0.5,
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                )
              : buildLoadingButton(_savingDone)));

  /// A function that changes between the loading circle indicator and the done icon
  /// After clicking "Save" the progress indicator is shown and after the done icon
  /// savingDone: The boolean that indicates if the button was clicked and the save is done, i.e. progress indicator is finished rotating
  Widget buildLoadingButton(bool savingDone) {
    final color = savingDone
        ? Colors.green.shade500
        : Colors
            .blueAccent; //changing background depending on showing either the progress indicator (savingDone = false) or the done icon (savingDone = true)
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: savingDone
          ? const Icon(Icons.done, size: 32, color: Colors.white)
          : Transform.scale(
              scaleX: 0.19,
              scaleY: 0.42,
              child: const CircularProgressIndicator(color: Colors.white)),
    );
  }

  getUserProfileData() {
    //firebaseUser = Rx<User?>(_user);
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }
}
