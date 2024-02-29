import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String username;
  final String fullName;
  final String email;
  final String password;

  const UserModel({this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.password});

  ///A function that returns the Json value of the UserModel to store it into Firestore DB
  ///If it's a Google Account, the password is not known and it will return null
  toJson() =>
      password != ""
          ? {
        "Email": email.toLowerCase(),
        "Full_Name": fullName,
        "Password": password,
        "Username": username,
      }
          : {
        "Email": email,
        "Full_Name": fullName,
        "Password": null,
        "Username": username,
      };

  ///A function that fetches data in a map from Firebase to UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      fullName: data["Full_Name"],
      password: data["Password"],
      username: data["Username"],
    );
  }
}
