import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/user_auth_service.dart';

class UserAuthProvider with ChangeNotifier {
  final UserAuthService _userAuthService;

  UserAuthProvider({required UserAuthService userAuthService})
      : _userAuthService = userAuthService;

  UserModel? _user;
  UserModel? get user => _user;

  // Checks whether an email address is already registered
  Future<bool> isEmailRegistered(String email) async {
    return await _userAuthService.isEmailRegistered(email);
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _userAuthService.signIn(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
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
