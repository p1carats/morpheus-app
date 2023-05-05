import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            displayName: user.displayName ?? '',
            isEmailVerified: user.emailVerified)
        : null;
  }

  // Check whether an email address is already being used
  Future<bool> isEmailAlreadyInUse(String email) async {
    try {
      await _auth.fetchSignInMethodsForEmail(email);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false;
      }
      throw Exception(e.message);
    }
  }

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw Exception(e.message);
    }
  }

  Future<UserModel?> signUp(
      String displayName, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? firebaseUser = result.user;
      if (firebaseUser != null) {
        // Send email verification
        await firebaseUser.sendEmailVerification();
        // Update the user's display name
        await firebaseUser.updateDisplayName(displayName);
        await firebaseUser.reload();
        firebaseUser = _auth.currentUser;
      }
      return _userFromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      throw Exception('Error signing out');
    }
  }
}
