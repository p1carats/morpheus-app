import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  UserModel? get user => _user;

  // Checks if user is already authenticated
  Future<void> checkAuthentication() async {
    _userService.checkAuthentication().then((UserModel? user) {
      _user = user;
      notifyListeners();
    }).catchError((error) {
      print('Error checking authentication: $error');
    });
  }

  // Checks whether an email address is already registered
  Future<bool> isEmailRegistered(String email) async {
    return await _userService.isEmailRegistered(email);
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _userService.signIn(email, password);
      notifyListeners();
    } on FirebaseAuthException catch (err) {
      if (err.code == 'wrong-password') {
        throw ('Mot de passe incorrect.');
      } else {
        throw Exception('Une erreur est survenue : ${err.message}');
      }
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // Sign up
  Future<void> signUp(String name, String email, String password, String gender,
      DateTime birthDate) async {
    try {
      _user =
          await _userService.signUp(name, email, password, gender, birthDate);
      notifyListeners();
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        throw Exception('Cette adresse email est déjà utilisée.');
      } else {
        throw Exception('Une erreur est survenue : ${err.message}');
      }
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _userService.signOut();
      _user = null;
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // Update user's display name
  Future<void> updateDisplayName(String uid, String name) async {
    try {
      _user = _userService.updateDisplayName(uid, name) as UserModel?;
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _userService.sendPasswordResetEmail(email);
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }
}
