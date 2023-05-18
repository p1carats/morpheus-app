import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/user_auth_service.dart';

class UserAuthProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserAuthService _userAuthService;

  UserAuthProvider({required UserAuthService userAuthService})
      : _userAuthService = userAuthService {
    checkAuthentication();
  }

  UserModel? _user;
  UserModel? get user => _user;

  // Check if a user is already logged in
  Future<void> checkAuthentication() async {
    var firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      _user = await _userAuthService.getUser(firebaseUser.uid);
      notifyListeners();
    }
  }

  // Checks whether an email address is already registered
  Future<bool> isEmailRegistered(String email) async {
    return await _userAuthService.isEmailRegistered(email);
  }

  // Sign in
  Future<void> signIn(String email, String password) async {
    try {
      _user = await _userAuthService.signIn(email, password);
      notifyListeners();
    } on FirebaseAuthException catch (err) {
      if (err.code == 'wrong-password') {
        throw Exception('Mot de passe incorrect.');
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
      _user = await _userAuthService.signUp(
          name, email, password, gender, birthDate);
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
      await _userAuthService.signOut();
      _user = null;
      notifyListeners();
    } catch (err) {
      throw Exception('Une erreur est survenue : $err');
    }
  }
}
