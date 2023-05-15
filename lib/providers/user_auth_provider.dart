import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/user_auth_service.dart';

class UserAuthProvider with ChangeNotifier {
  final UserAuthService _userAuthService;
  UserModel? _user;

  UserAuthProvider({required UserAuthService userAuthService})
      : _userAuthService = userAuthService;

  UserModel? get user => _user;

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _userAuthService.signIn(email, password);
      notifyListeners();
    } on FirebaseAuthException catch (err) {
      if (kDebugMode) {
        print(err.message);
      }
    }
  }

  // Sign up
  Future<void> signUp(String name, String email, String password, String gender,
      DateTime birthDate) async {
    _user =
        await _userAuthService.signUp(name, email, password, gender, birthDate);
    notifyListeners();
  }

  // Sign out
  Future<void> signOut() async {
    await _userAuthService.signOut();
    _user = null;
    notifyListeners();
  }
}
