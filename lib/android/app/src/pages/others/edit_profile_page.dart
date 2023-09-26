import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_me/android/app/src/utils/images.dart';
import 'package:stream_me/android/app/src/widgets/global/selection_button.dart';
import '../../widgets/features/edit_text-field.dart';

class EditProfilePage extends StatefulWidget {
  final Color backgroundColor;

  EditProfilePage({Key? key, required this.backgroundColor})
      : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();

  bool showPassword = true;
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;
}

class _EditProfilePageState extends State<EditProfilePage> {
  Images image = Images();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Container(
        color: widget.backgroundColor,
        padding: const EdgeInsetsDirectional.only(top: 5.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
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
                          color: Theme.of(context).scaffoldBackgroundColor,
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
                              color: Theme.of(context).scaffoldBackgroundColor,
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
                                builder: ((builder) => bottomProfileSheet()),
                                backgroundColor: widget.backgroundColor,
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
              EditTextField(labelText: "Username: ", placeholder: "Enter new Username here", isPassword: false, userInput: "${widget.user?.displayName}"),
              EditTextField(labelText: "Full Name: ", placeholder: "Enter new Full Name here", isPassword: false, userInput: "${widget.user?.displayName}"),
              EditTextField(labelText: "E-Mail: ", placeholder: "Enter new E-Mail address here", isPassword: false, userInput: "${widget.user?.email}"),
              const EditTextField(labelText: "Password: ", placeholder: "Enter new Password here", isPassword: true, userInput: "●●●●●"),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //setting space between buttons cancel and save
                  children: [
                    SelectionButton(onTap: () {}, color: Colors.blueAccent, label: "Save"),
                    SelectionButton(onTap: () {}, color: Colors.redAccent, label: "Reset"),
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
          ),
        ),
      ),
    );
  }

  Widget bottomProfileSheet() {
    return Container(
      height: 100.0,
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
            height: 20.0,
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
    final pickedFile = await widget._picker.getImage(
        source:
        source); //TODO: maybe change function getImage to pickImage if it works
    setState(() {
      widget._imageFile = pickedFile;
    });
  }

  ImageProvider<Object> selectImage() {
    return widget._imageFile == null
        ? AssetImage(image.blank)
        : FileImage(File(widget._imageFile!.path)) as ImageProvider;
  }

/*  Future<bool?> showCancelDialog() => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Are you sure?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Yes')),
            TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('No')),
          ],
        ),
      );*/
}