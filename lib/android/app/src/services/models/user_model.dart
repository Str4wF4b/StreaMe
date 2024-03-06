import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String username;
  final String fullName;
  final String email;
  final String password;
  final String imageUrl;

  const UserModel(
      {this.id,
      required this.username,
      required this.fullName,
      required this.email,
      required this.password,
      required this.imageUrl});

  /// A function that returns the Json value of the UserModel to store it into Firestore DB
  /// If it's a Google Account, the password is not known and it will return 5 dots
  toJson() => password != ""
      ? {
          "Email": email.toLowerCase(),
          "Full_Name": fullName,
          "ImageUrl": imageUrl,
          "Password": password,
          "Username": username,
        }
      : {
          "Email": email,
          "Full_Name": fullName,
          "ImageUrl": imageUrl,
          "Password": "•••••",
          "Username": username,
        };

  /// A function that fetches data in a map from Firebase to UserModel
  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      email: data["Email"],
      fullName: data["Full_Name"],
      imageUrl: data["ImageUrl"],
      password: data["Password"],
      username: data["Username"],
    );
  }
}
