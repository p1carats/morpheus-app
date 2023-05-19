class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool emailVerified;
  final String profilePicture; // URL
  final DateTime creationTime;
  final DateTime birthDate;
  final String gender;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.profilePicture,
    required this.creationTime,
    required this.birthDate,
    required this.gender,
  });

  factory UserModel.fromParams(String uid, String name, String email,
      bool emailVerified, String profilePicture, DateTime creationTime,
      {required DateTime birthDate, required String gender}) {
    return UserModel(
      uid: uid,
      email: email,
      emailVerified: emailVerified,
      profilePicture: profilePicture,
      creationTime: creationTime,
      name: name,
      gender: gender,
      birthDate: birthDate,
    );
  }
}
