import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String gender;
  final DateTime birthDate;
  final bool isEmailVerified;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthDate,
    required this.isEmailVerified,
  });

  factory UserModel.fromFirebaseUser(User user,
      {required String gender, required DateTime birthDate}) {
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? '',
      gender: gender,
      birthDate: birthDate,
      isEmailVerified: user.emailVerified,
    );
  }
}
