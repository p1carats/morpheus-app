class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool emailVerified;
  final String profilePicture; // URL
  final DateTime creationTime;
  final DateTime birthDate;
  final String gender;
  final int desiredSleepDuration;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.emailVerified,
    required this.profilePicture,
    required this.creationTime,
    required this.birthDate,
    required this.gender,
    required this.desiredSleepDuration,
  });

  factory UserModel.fromParams(String uid, String name, String email,
      bool emailVerified, String profilePicture, DateTime creationTime,
      {required DateTime birthDate,
      required String gender,
      required int desiredSleepDuration}) {
    return UserModel(
      uid: uid,
      email: email,
      emailVerified: emailVerified,
      profilePicture: profilePicture,
      creationTime: creationTime,
      name: name,
      gender: gender,
      birthDate: birthDate,
      desiredSleepDuration: desiredSleepDuration,
    );
  }
}
