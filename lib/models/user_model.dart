class UserModel {
  final String uid;
  final String displayName;
  final bool isEmailVerified;

  UserModel(
      {required this.uid,
      required this.displayName,
      required this.isEmailVerified});
}
