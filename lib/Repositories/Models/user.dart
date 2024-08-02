import 'package:firebase_auth/firebase_auth.dart';

class User {
  String email;
  String fName;
  String lName;
  String familyCode;

  UserCredential userCredential;

  User(
      {required this.userCredential,
      required this.lName,
      required this.fName,
      required this.email,
      required this.familyCode});
}
