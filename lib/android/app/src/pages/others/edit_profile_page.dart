import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_me/android/app/src/services/functions/auth_popups.dart';
import 'package:stream_me/android/app/src/services/functions/user_data.dart';
import 'package:stream_me/android/app/src/services/models/user_model.dart';
import 'package:stream_me/android/app/src/utils/color_palette.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import 'package:stream_me/android/app/src/widgets/global/selection_button.dart';
import '../../widgets/features/edit_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // Utils:
  final ColorPalette _color = ColorPalette();
  final Images _image = Images();
  final AuthPopups _popups = AuthPopups();

  // Instances:
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Local instances:
  XFile? _imageFile;
  bool _pickedImage = false;
  late UploadTask _uploadTask;
  bool _isNotLoading = true; // flag to trigger button loading

  // Database:
  User? _user = FirebaseAuth.instance.currentUser;
  final _userRepo = UserData();
  late String _oldEmail;
  late String _oldPassword;
  bool _updateToFirebase =
      false; // flag to trigger if the database should be updated
  late String _urlDownload = ""; // download path of Firebase storage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _color.backgroundColor,
      body: Container(
        color: _color.backgroundColor,
        padding: const EdgeInsetsDirectional.only(top: 5.0),
        child: FutureBuilder(
          future: getUserProfileData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // data is completely fetched

              if (snapshot.hasData) {
                UserModel user = snapshot.data as UserModel;
                final id = TextEditingController(text: user.id);
                _oldEmail =
                    user.email; // set old email for possible re-authentication
                _oldPassword = user
                    .password; // set old password for possible re-authentication

                return ListView(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            // Profile picture attributes:
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              border: Border.all(
                                // border around profile picture
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
                              // profile picture in circle shape
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: getProfilePicture(user.imageUrl)),
                            ),
                          ),
                          Positioned(
                              // positioning the "change picture" item
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    // border around edit icon
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
                                        elevation: 0.0);
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
                      height: 58,
                    ),
                    // User's Username:
                    EditTextField(
                        controller: _usernameCtrl,
                        labelText: "Username: ",
                        placeholder: "Enter new Username here",
                        isPassword: false,
                        userInput: user.username),
                    // User's Full Name:
                    EditTextField(
                        controller: _fullNameCtrl,
                        labelText: "Full Name: ",
                        placeholder: "Enter new Full Name here",
                        isPassword: false,
                        userInput: user.fullName),
                    // User's Email:
                    EditTextField(
                        controller: _emailCtrl,
                        labelText: "E-Mail: ",
                        placeholder: "Enter new E-Mail address here",
                        isPassword: false,
                        userInput: user.email),
                    // User's Password:
                    EditTextField(
                        controller: _passwordCtrl,
                        labelText: "Password: ",
                        placeholder: "Enter new Password here",
                        isPassword: true,
                        userInput:
                            "●●●●●${user.password.substring(user.password.length - 1)}"),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 26.0, right: 26.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          saveButton(id, user), // button to save changes to DB
                          SelectionButton(
                              // button to reset changes in Textfields
                              onTap: () {
                                // Clear all controllers if clicked on "Reset":
                                _usernameCtrl.clear();
                                _fullNameCtrl.clear();
                                _emailCtrl.clear();
                                _passwordCtrl.clear();
                              },
                              color: Colors.red.shade400,
                              label: "Reset"),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return const Center(
                    child: Text(
                        "Something went wrong! Please try to login again."));
              }
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent));
            }
          },
        ),
      ),
    );
  }

  /// A function that returns the profile picture depending if the user saved a picture or not (yet)
  /// imageUrl: The path of the image url of a user (whether person_icon image if no picture saved yet or saved picture)
  getProfilePicture(String imageUrl) {
    if (imageUrl.contains("person_icon.png") && !_pickedImage) {
      // if the path of the image refers to the blank profile image and no image is picked
      return AssetImage(_image.blank); // show blank profile picture image
    } else if (!_pickedImage) {
      // if the path of the image is given and no picture is picked
      return NetworkImage(imageUrl); // show current saved picture from user
    } else {
      if (_imageFile != null) {
        // if imageFile (contains picked image) is not null
        return FileImage(File(_imageFile!
            .path)); // show imageFile, i.e. user's picked and not yet saved image
      }
    }
  }

  /// A function that shows the opportunities (via Camera or Gallery) to upload a profile picture
  Widget bottomProfileSheet() {
    return Container(
      height: 92.0,
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
                    changePicture(ImageSource.camera);
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
                    changePicture(ImageSource.gallery);
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

  /// A function that changes the current profile picture by picking from a source
  /// source: The source the picture is picked from, i.e. from camera or gallery
  void changePicture(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
        source: source); // currently picked picture from a source
    if (pickedFile != null) {
      _pickedImage = true; // an image is picked
    }
    setState(() {
      _imageFile = pickedFile;
    });
    if (_imageFile != null) {
      uploadPicture(_imageFile); // upload picture to DB process
    }
  }

  /// A function that uploads the picked picture from the user and that generates a download link inside the Firebase storage
  /// pickedFile: The currently picked picture from the user
  Future uploadPicture(XFile? pickedFile) async {
    final path =
        "profilePictures/${_user?.email}/${_imageFile!.name}"; // add the path to Firestore storage

    final file = File(pickedFile!.path);
    final ref =
        FirebaseStorage.instance.ref().child(path); // Firebase reference
    _uploadTask = ref.putFile(file); // put the picture into an upload file

    final snapshot = await _uploadTask; // upload the picture
    _urlDownload =
        await snapshot.ref.getDownloadURL(); // get download link of picture
  }

  /// The save button that updates all changes and loads them into the Firestore DB
  /// id: The id of the current user
  /// user: The current user whose information is changed
  Widget saveButton(TextEditingController id, UserModel user) =>
      GestureDetector(
          onTap: () async {
            _updateToFirebase = true; // save changes to Firebase
            List<UserModel> allUsersData = await _userRepo
                .getAllUserData(); // get all user's data to check for duplicate emails
            setState(() {
              _isNotLoading = false; // change button state to a loading button
            });
            // Update profile changes:
            final updatedUserData = UserModel(
                id: id.text,
                email: _emailCtrl.text.isEmpty
                    ? user.email
                    : checkDuplicatedEmail(
                        _emailCtrl.text.trim(), user.email, allUsersData),
                fullName: _fullNameCtrl.text.isEmpty
                    ? user.fullName
                    : _fullNameCtrl.text,
                imageUrl: _urlDownload == "" ? user.imageUrl : _urlDownload,
                password: _passwordCtrl.text.isEmpty
                    ? user.password
                    : _passwordCtrl.text,
                username: _usernameCtrl.text.isEmpty
                    ? user.username
                    : _usernameCtrl.text);

            if (_updateToFirebase) await updateUserProfileData(updatedUserData);
            // Clear text field inputs after saving:
            _usernameCtrl.clear();
            _fullNameCtrl.clear();
            _emailCtrl.clear();
            _passwordCtrl.clear();

            if (mounted) setState(() {}); // show changes
            _isNotLoading = true; // change button state back to normal
          },
          child: Container(
              padding: _isNotLoading
                  ? const EdgeInsets.only(top: 15.0, bottom: 15.0)
                  : EdgeInsets.zero,
              width: 120,
              height: 53,
              decoration: BoxDecoration(
                  color: _isNotLoading ? Colors.blueAccent : Colors.transparent,
                  // removing left and right background color after the button is pressed to show loading circle
                  borderRadius: BorderRadius.circular(30.0)),
              child: _isNotLoading
                  // If no data is saving, show normal button:
                  ? const Center(
                      child: Text("Save",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    )
                  // If data is being saved, show loading circle
                  : Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blueAccent),
                      child: Transform.scale(
                          scaleX: 0.19,
                          scaleY: 0.42,
                          child: const CircularProgressIndicator(
                              color: Colors.white)),
                    )));

  /// A function that checks if a changed email is already in use or not
  /// newEmail: The new email a user wants to use and which is checked for duplicate
  /// email: The current email of a user
  /// allUsersData: The full data stack of all users
  String checkDuplicatedEmail(
      String newEmail, String email, List allUsersData) {
    bool duplicateEmail = false;
    for (UserModel user in allUsersData) {
      if (user.email == newEmail) {
        duplicateEmail = true; // the email is already in use
      }
    }

    if (duplicateEmail) {
      if (mounted) {
        _isNotLoading = true; // stop loading, i.e. stop saving data
        _emailCtrl.clear();
        _popups
            .duplicateEmailDialog(context); // inform user about duplicate email
        _updateToFirebase =
            false; // stop saving changes to Firebase because of duplicate email
      }
      return email; // return current user email before the change attempt because new email is a duplicate
    } else {
      return newEmail; // return new email, i.e. no duplicate email
    }
  }

  /// A function that fetches the current user's data based on the email
  getUserProfileData() {
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

  /// A function that updates the user changes to Firestore
  /// user: The current user whose information is changed
  updateUserProfileData(UserModel user) async {
    await updateData(user);
    if (_updateToFirebase) {
      await _userRepo.updateUserData(user);
    }
  }

  /// A function that updates the Firebase user data of the current user
  /// user: The current user whose information is changed
  updateData(UserModel user) async {
    try {
      // Update currently edited user changes:
      await _user?.updateDisplayName(user.username);
      await _user?.updateEmail(user.email);
      await _user?.updatePassword(user.password);
      await _user?.reload();

      _user = FirebaseAuth.instance
          .currentUser; // new user data, i.e. username, full name, email and password will be fetched from new current user
      _updateToFirebase = true; // the update to Firestore DB is now opened
    } on FirebaseAuthException catch (e) {
      // If a recent login is required because of longer inactivity:
      if (e.code == "requires-recent-login") {
        AuthCredential newCredential = EmailAuthProvider.credential(
            email: _oldEmail,
            password:
                _oldPassword); // Login with old credential before being allowed to make changes
        _user = FirebaseAuth.instance.currentUser;

        // Clear text field inputs and don't update changes:
        _usernameCtrl.clear();
        _fullNameCtrl.clear();
        _emailCtrl.clear();
        _passwordCtrl.clear();

        if (mounted) _popups.reauthenticateDialog(context);
        _updateToFirebase = false; // don't update changes to Firestore DB
        await _user?.reauthenticateWithCredential(
            newCredential); // reauthenticate user with new Login
      }
    }
  }
}
