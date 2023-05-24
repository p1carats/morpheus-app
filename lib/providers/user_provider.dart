import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/user_service.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  UserModel? _user;
  UserModel? get user => _user;

  // Checks if an user is already logged in
  Future<void> checkAuthentication() async {
    try {
      _user = await _userService.checkAuthentication();
    } catch (error) {
      print('Error checking authentication: $error');
    }
    notifyListeners();
  }

  // Checks whether an email address is already registered
  Future<bool> isEmailRegistered(String email) async {
    return await _userService.isEmailRegistered(email);
  }

  // Logs in an existing user
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

  // Registers a new user
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

  // Logs out the current user
  Future<void> signOut() async {
    try {
      await _userService.signOut();
      _user = null;
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // sendEmailVerification
  Future<void> sendEmailVerification() async {
    try {
      await _userService.sendEmailVerification();
    } on FirebaseAuthException catch (err) {
      if (err.code == 'too-many-requests') {
        throw ('Veuillez patienter quelques instants avant de faire une nouvelle demande.');
      } else {
        throw Exception('Une erreur est survenue : ${err.message}');
      }
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // updateDesiredSleepDuration
  Future<void> updateDesiredSleepDuration(String uid, int duration) async {
    try {
      await _userService.updateDesiredSleepDuration(uid, duration);
      _user = await _userService.checkAuthentication();
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // updateProfilePicture
  Future<void> updateProfilePicture(String uid, File image) async {
    try {
      await _userService.updateProfilePicture(uid, image);
      _user = await _userService.checkAuthentication();
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // updateDisplayName
  Future<void> updateDisplayName(String uid, String name) async {
    try {
      await _userService.updateDisplayName(uid, name);
      _user = await _userService.checkAuthentication();
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // update email
  Future<void> updateEmail(String uid, String name, String password) async {
    try {
      await _userService.updateEmail(uid, name, password);
      _user = await _userService.checkAuthentication();
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      await _userService.resetPassword(email);
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _userService.changePassword(oldPassword, newPassword);
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }

  // Deletes the current user
  Future<void> deleteUser(String password) async {
    await _userService.deleteUser(password);
    _user = null;
    notifyListeners();
  }
}
