import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'user_data_service.dart';

class UserAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserDataService _userDataService;

  UserAuthService({required UserDataService userDataService})
      : _userDataService = userDataService;

  // Fetches user details
  Future<UserModel?> getUser(String uid) async {
    var firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      var gender = await _userDataService.getGender(uid);
      var birthDate = await _userDataService.getBirthDate(uid);
      return UserModel.fromParams(
        firebaseUser.uid,
        firebaseUser.displayName!,
        firebaseUser.email!,
        firebaseUser.emailVerified,
        firebaseUser.metadata.creationTime!,
        birthDate: birthDate,
        gender: gender,
      );
    } else {
      return null;
    }
  }

  // Checks whether an email address is already registered
  Future<bool> isEmailRegistered(String email) async {
    var users = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    return users.isNotEmpty;
  }

  // Logs in an existing user
  Future<UserModel> signIn(String email, String password) async {
    var authResult = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = authResult.user!;
    var gender = await _userDataService.getGender(user.uid);
    var birthDate = await _userDataService.getBirthDate(user.uid);
    return UserModel.fromParams(
      user.uid,
      user.displayName!,
      user.email!,
      user.emailVerified,
      user.metadata.creationTime!,
      birthDate: birthDate,
      gender: gender,
    );
  }

  // Registers a new user
  Future<UserModel?> signUp(String name, String email, String password,
      String gender, DateTime birthDate) async {
    var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = authResult.user!;
    // Set the user details (custom fields)
    await _userDataService.setGender(user.uid, gender);
    await _userDataService.setBirthDate(user.uid, birthDate);
    // Update the display name and send email verification
    await user.sendEmailVerification();
    await user.updateDisplayName(name);
    await user.reload();
    // Return the user details
    return UserModel.fromParams(
      user.uid,
      user.displayName!,
      user.email!,
      user.emailVerified,
      user.metadata.creationTime!,
      birthDate: birthDate,
      gender: gender,
    );
  }

  // Logs out the current user
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
