import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../models/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Checks if a user is already logged in
  Future<UserModel?> checkAuthentication() async {
    var user = _auth.currentUser;
    if (user != null) {
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
      );
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
    );
  }

  // Registers a new user
  Future<UserModel?> signUp(String name, String email, String password,
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
    // Update the user's name and profile picture, and send email verification
    await user.updateDisplayName(name);
    await user.updatePhotoURL(
        'https://image-uniservice.linternaute.com/image/450/3/1294835011/4443027.jpg');
    await user.reload();
    await user.sendEmailVerification();
    // Return the user details
    return UserModel.fromParams(
      user.uid,
      user.displayName!,
      user.email!,
      user.emailVerified,
      user.photoURL ??
          'https://image-uniservice.linternaute.com/image/450/3/1294835011/4443027.jpg',
      user.metadata.creationTime!,
      birthDate: birthDate,
      gender: gender,
    );
  }

  // Logs out the current user
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Updates the user's display name
  Future<void> updateDisplayName(String uid, String name) async {
    User? user = _auth.currentUser;
    return await user?.updateDisplayName(name);
  }

  // Updates the user's profile picture
  Future<void> updateProfilePicture(String uid, String url) async {
    User? user = _auth.currentUser;
    return await user?.updatePhotoURL(url);
  }

  // Updates the user's email address
  Future<void> updateEmail(String uid, String email) async {
    User? user = _auth.currentUser;
    return await user?.updateEmail(email);
  }

  // Sends a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  // Uploads a profile picture
  Future<String> uploadProfilePicture(File file, String uid) async {
    var ref = FirebaseStorage.instance.ref().child('users/$uid/profile.jpg');
    var uploadTask = ref.putFile(file);
    var snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }
}
