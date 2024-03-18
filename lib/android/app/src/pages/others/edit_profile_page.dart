import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
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
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  late UploadTask _uploadTask;
  Images image = Images();
  bool showPassword = true;
  final ColorPalette _color = ColorPalette();

  User? _user = FirebaseAuth.instance.currentUser;
  late Rx<User?> firebaseUser; //_authRep = Rx<User?>(widget.user);
  final _userRepo = UserData();

  bool _isNotLoading = true;

  late String _oldEmail;
  late String _oldPassword;
  bool _updateToFirebase = false;
  late String _urlDownload = "";
  bool _pickedImage = false;

  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _fullNameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();

  final AuthPopups _popups = AuthPopups();

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
              //data is completely fetched

              //print("----------------------------------------------------------- _user? - Email: ${_user?.email}");
              if (snapshot.hasData) {
                UserModel user = snapshot.data as UserModel;
                final id = TextEditingController(text: user.id);
                _oldEmail = user.email;
                _oldPassword = user.password;
                //print("----------------------------------------------------------- user - Username: ${user.username}");
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
                                  image: getProfilePicture(user.imageUrl)),
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
                                      elevation: 0.0
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
                        userInput: user.username),
                    EditTextField(
                        controller: _fullNameCtrl,
                        labelText: "Full Name: ",
                        placeholder: "Enter new Full Name here",
                        isPassword: false,
                        userInput: user.fullName),
                    EditTextField(
                        controller: _emailCtrl,
                        labelText: "E-Mail: ",
                        placeholder: "Enter new E-Mail address here",
                        isPassword: false,
                        userInput: user.email),
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
                          saveButton(id, user),
                          SelectionButton(
                              onTap: () {
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
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      _pickedImage = true;
    }
    setState(() {
      print("Now");
      _imageFile = pickedFile;
    });
    print("Image saving");
    uploadPicture(_imageFile);
  }

  /// A function
  /// pickedFile:
  Future uploadPicture(XFile? pickedFile) async {
    /*if (_updateToFirebase && (_oldEmail != _user?.email)) {
      // Delete the path of the old email when changing the user's email:
      final oldPath = "profilePictures/$_oldEmail";
      await File(oldPath).delete();
    }*/

    // Add the path to Firestore storage:
    final path = "profilePictures/${_user?.email}/${_imageFile!.name}";
    print("Path: $path");
    final file = File(pickedFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);
    _uploadTask = ref.putFile(file);

    final snapshot = await _uploadTask;
    _urlDownload = await snapshot.ref.getDownloadURL();
    print(_urlDownload);
    print("--------------------------------------------------------------------- ${_imageFile!.path}");
  }

  /// A function
  /// user:
  getProfilePicture(String imageUrl) {
    if (imageUrl == "" && !_pickedImage) {
        return AssetImage(image.blank);
    } else if (!_pickedImage){
      return NetworkImage(imageUrl);//FileImage(File(user.imageUrl));
    } else {
      return FileImage(File(_imageFile!.path));
    }
  }

  /// The save button that updates all changes in the edit profile page and loads them into the Firestore DB
  /// id:
  /// user:
  Widget saveButton(TextEditingController id, UserModel user) =>
      GestureDetector(
          onTap: () async {
            _updateToFirebase = true; // save changes to firebase
            List<UserModel> allUsersData = await _userRepo.getAllUserData(); // get all user's data to check for duplicate emails
            setState(() {
              _isNotLoading = false; // change button state to a loading button
            });
            // Update profile changes:
            final updatedUserData = UserModel(
                id: id.text,
                email: _emailCtrl.text.isEmpty
                    ? user.email
                    : checkDuplicatedEmail(_emailCtrl.text.trim(), user.email, allUsersData),
                fullName: _fullNameCtrl.text.isEmpty
                    ? user.fullName
                    : _fullNameCtrl.text,
                imageUrl: /*_imageFile?.path == null ? user.imageUrl : _imageFile!.path*/ _urlDownload == "" ? user.imageUrl : _urlDownload,
                password: _passwordCtrl.text.isEmpty
                    ? user.password
                    : _passwordCtrl.text,
                username: _usernameCtrl.text.isEmpty
                    ? user.username
                    : _usernameCtrl.text);

            // Clear text field inputs after saving:

            if (_updateToFirebase) await updateUserProfileData(updatedUserData);
            _usernameCtrl.clear();
            _fullNameCtrl.clear();
            _emailCtrl.clear();
            _passwordCtrl.clear();
            if (mounted) setState(() {});
            //print(
            //    "----------------------------------------------------------- user - Password: ${user.password}");
            //print("-----------------------------------------------------------  updatedUserData - updated Password: ${updatedUserData
            //    .password}");

            _isNotLoading = true;
          },
          child: Container(
              padding: _isNotLoading
                  ? const EdgeInsets.only(top: 15.0, bottom: 15.0)
                  : EdgeInsets.zero,
              width: 120,
              height: 53,
              decoration: BoxDecoration(
                  color: _isNotLoading ? Colors.blueAccent : Colors.transparent,
                  //removing the left and right background color after the button is pressed
                  borderRadius: BorderRadius.circular(30.0)),
              child: _isNotLoading
                  ? const Center(
                      child: Text("Save",
                          style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    )
                  : Container(
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.blueAccent),
                child: Transform.scale(
                    scaleX: 0.19,
                    scaleY: 0.42,
                    child: const CircularProgressIndicator(color: Colors.white)),
              )));

  /// A function
  getUserProfileData() {
    //firebaseUser = Rx<User?>(_user);
    //final email = firebaseUser.value?.email;
    _user = FirebaseAuth.instance.currentUser;
    final email = _user?.email;
    print("----------------------------------------------------------- getUserProfileData - Email: $email");
    //print("Firebase User: $email");
    //final id = _user?.uid;
    if (email != null) {
      return _userRepo.getUserData(email);
    }
  }

  /// A function
  /// user:
  updateUserProfileData(UserModel user) async {
    await updateData(user);
    if (_updateToFirebase) {
      await _userRepo.updateUserData(user);
    }
  }

  /// A function that updates the Firebase user data of the current user
  /// user:
  updateData(UserModel user) async {
    try {
      await _user?.updateDisplayName(user.username);
      //await _user?.reload();
      await _user?.updateEmail(user.email);
      await _user?.updatePassword(user.password);
      await _user?.reload();

      _user = FirebaseAuth.instance
          .currentUser; // new user data, i.e. username, full name, email and password will be fetched from new current user
      _updateToFirebase = true;
      //String? newDisplayName = _user?.displayName;
      //String? newEmail = _user?.email;
      //print("----------------------------------------------------------- updateData - New Display Name: $newDisplayName");
      //print("----------------------------------------------------------- updateData - New Email: $newEmail");
    } on FirebaseAuthException catch (e) {
      //await _user?.reload();
      if (e.code == "requires-recent-login") {
        AuthCredential newCredential = EmailAuthProvider.credential(
            email: _oldEmail, password: _oldPassword);
        _user = FirebaseAuth.instance.currentUser;
        print("----------------------------------------------------------- Requires recent login: ${user.email} ${_user?.email}");
        print("----------------------------------------------------------- oldEmail: $_oldEmail | oldPassword: $_oldPassword");
        _usernameCtrl.clear();
        _fullNameCtrl.clear();
        _emailCtrl.clear();
        _passwordCtrl.clear();
        if (mounted) _popups.reauthenticateDialog(context);
        _updateToFirebase = false;
        await _user?.reauthenticateWithCredential(newCredential);
      }
    }
  }

  /// A function that checks if a changed email is already in use or not
  /// newEmail: The new email a user wants to use and which is checked for duplicate
  /// email: The current email of a user
  /// allUsersData: The full data stack of all users
  String checkDuplicatedEmail(String newEmail, String email, List allUsersData) {
    bool duplicateEmail = false;
    for (UserModel user in allUsersData) {
      if (user.email == newEmail) {
        print(newEmail);
       duplicateEmail = true; // the email is already in use
      }
    }

    if (duplicateEmail) {
      if (mounted) {
        _isNotLoading = true; // stop loading, i.e. stop saving data
        _emailCtrl.clear();
        _popups.duplicateEmailDialog(context); // inform user about duplicate email
        _updateToFirebase = false; // stop saving changes to firebase because of duplicate email
      }
      return email; // return user email before the duplicate change
    } else {
      return newEmail; // return new email, i.e. no duplicate email
    }
  }
}
