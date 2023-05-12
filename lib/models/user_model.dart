import 'package:firebase_auth/firebase_auth.dart';

enum Genders { male, female, other }

class UserModel {
  final String uid;
  final String name;
  final String email;
  final Genders gender;
  final DateTime birthDate;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthDate,
  });

  factory UserModel.fromFirebaseUser(User user,
      {required Genders gender, required DateTime birthDate}) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      gender: gender,
      birthDate: birthDate,
    );
  }
}
