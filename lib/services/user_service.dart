import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Checks if an user is already logged in
  Future<UserModel?> checkAuthentication() async {
    var user = _auth.currentUser;
    if (user != null) {
      var doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromParams(
          user.uid,
          user.displayName!,
          user.email!,
          user.emailVerified,
          user.photoURL!,
          user.metadata.creationTime!,
          birthDate: (doc['birthDate'] as Timestamp).toDate(),
          gender: doc['gender'],
          desiredSleepDuration: doc['desiredSleepDuration'] as int,
        );
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // Checks whether an email address is already registered
  Future<bool> isEmailRegistered(String email) async {
    var users = await _auth.fetchSignInMethodsForEmail(email);
    return users.isNotEmpty;
  }

  // Logs in an existing user
  Future<UserModel> signIn(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = authResult.user!;
    var doc = await _firestore.collection('users').doc(user.uid).get();
    return UserModel.fromParams(
      user.uid,
      user.displayName!,
      user.email!,
      user.emailVerified,
      user.photoURL!,
      user.metadata.creationTime!,
      birthDate: (doc['birthDate'] as Timestamp).toDate(),
      gender: doc['gender'],
      desiredSleepDuration: doc['desiredSleepDuration'] as int,
    );
  }

  // Registers a new user
  Future<UserModel> signUp(String name, String email, String password,
      String gender, DateTime birthDate) async {
    var authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    var user = authResult.user!;
    // Set the user's birth date and gender
    await _firestore.collection('users').doc(user.uid).set({
      'birthDate': birthDate,
      'gender': gender,
    });
    // Update the user's name
    await user.updateDisplayName(name);
    // Set the user's profile picture
    var ref = FirebaseStorage.instance.ref().child('users/default.jpg');
    await user.updatePhotoURL(await ref.getDownloadURL());
    // Send a verification email
    await user.sendEmailVerification();
    await user.reload();
    user = _auth.currentUser!;
    // age desired sleep duration
    final currentDate = DateTime.now();
    int age = currentDate.month < birthDate.month ||
            (currentDate.month == birthDate.month &&
                currentDate.day < birthDate.day)
        ? currentDate.year - birthDate.year - 1
        : currentDate.year - birthDate.year;
    int desiredSleepDuration;
    if (age >= 26) {
      desiredSleepDuration = 9;
    } else if (age >= 18) {
      desiredSleepDuration = 8;
    } else if (age >= 14) {
      desiredSleepDuration = 10;
    } else if (age >= 6) {
      desiredSleepDuration = 11;
    } else {
      desiredSleepDuration = 12;
    }
    // Set the user's birth date, gender, and desired sleep duration
    await _firestore.collection('users').doc(user.uid).set({
      'birthDate': birthDate,
      'gender': gender,
      'desiredSleepDuration': desiredSleepDuration,
    });
    // Return the user details
    return UserModel.fromParams(
      user.uid,
      user.displayName!,
      user.email!,
      user.emailVerified,
      user.photoURL!,
      user.metadata.creationTime!,
      birthDate: birthDate,
      gender: gender,
      desiredSleepDuration: 8,
    );
  }

  // Logs out the current user
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null) return await user.sendEmailVerification();
  }

  // Updates the user's desired sleep duration
  Future<void> updateDesiredSleepDuration(String uid, int duration) async {
    await _firestore.collection('users').doc(uid).update({
      'desiredSleepDuration': duration,
    });
  }

  // Updates the user's profile picture
  Future<void> updateProfilePicture(String uid, File image) async {
    User? user = _auth.currentUser;
    var ref = FirebaseStorage.instance.ref().child('users/$uid/profile.jpg');
    var snapshot = await ref.putFile(image).whenComplete(() => null);
    var link = await snapshot.ref.getDownloadURL();
    return await user?.updatePhotoURL(link);
  }

  // Updates the user's display name
  Future<void> updateDisplayName(String uid, String name) async {
    User? user = _auth.currentUser;
    return await user?.updateDisplayName(name);
  }

  // Updates the user's email address
  Future<void> updateEmail(String uid, String email, String password) async {
    User? user = _auth.currentUser;
    return await user?.updateEmail(email);
  }

  // Sends a password reset email
  Future<void> resetPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      AuthCredential credentials = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: oldPassword,
      );
      await user.reauthenticateWithCredential(credentials);
      await user.updatePassword(newPassword);
    }
  }

  // Deletes the current user
  Future<void> deleteUser(String password) async {
    User? user = _auth.currentUser;
    if (user != null) {
      AuthCredential credentials = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!,
        password: password,
      );
      try {
        await user.reauthenticateWithCredential(credentials);
        await _firestore.collection('users').doc(user.uid).delete();
        await user.delete();
      } on FirebaseAuthException catch (err) {
        if (err.code == 'wrong-password') {
          throw ('Mot de passe incorrect, merci de réessayer.');
        } else {
          throw Exception('An error occurred');
        }
      } catch (err) {
        throw Exception('An error occurred');
      }
    }
  }
}
