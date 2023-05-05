import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  late AuthService _authService;

  UserModel? get user => _user;

  void updateAuthService(AuthService authService) {
    _authService = authService;
  }

  // Login
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _authService.signIn(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Register
  Future<void> signUp(String displayName, String email, String password) async {
    try {
      _user = await _authService.signUp(displayName, email, password);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
