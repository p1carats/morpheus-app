import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import 'user_data_service.dart';

class UserAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserDataService _userDataService;

  UserAuthService({required UserDataService userDataService})
      : _userDataService = userDataService;

  // Fetches user details
  Future<UserModel> getUser(String uid) async {
    var gender = await _userDataService.getGender(uid);
    var birthDate = await _userDataService.getBirthDate(uid);
    return UserModel.fromFirebaseUser(
      _firebaseAuth.currentUser!,
      gender: gender,
      birthDate: birthDate,
    );
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
    return UserModel.fromFirebaseUser(
      user,
      gender: gender,
      birthDate: birthDate,
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
    await user.updateDisplayName(name);
    await _userDataService.setGender(user.uid, gender);
    await _userDataService.setBirthDate(user.uid, birthDate);
    await user.sendEmailVerification();
    return UserModel.fromFirebaseUser(user,
        gender: gender, birthDate: birthDate);
  }

  // Logs out the current user
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
