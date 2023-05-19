import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user's gender
  Future<String> getGender(String uid) async {
    var doc = await _firestore.collection('users').doc(uid).get();
    return doc['gender'] ?? '';
  }

  // Get user's birth date
  Future<DateTime> getBirthDate(String uid) async {
    var doc = await _firestore.collection('users').doc(uid).get();
    return (doc['birthDate'] as Timestamp).toDate();
  }

  // Set user's gender
  Future<void> setGender(String uid, String gender) async {
    await _firestore.collection('users').doc(uid).set(
      {'gender': gender},
      SetOptions(merge: true),
    );
  }

  // Set user's birth date
  Future<void> setBirthDate(String uid, DateTime birthDate) async {
    await _firestore.collection('users').doc(uid).set(
      {'birthDate': birthDate},
      SetOptions(merge: true),
    );
  }

  // Deletes the current user
  Future<void> deleteUser() async {
    var user = _firebaseAuth.currentUser!;
    FirebaseAuth.instance.currentUser?.reload();
    await user.delete();
  }

  // Changes the user's email address
  Future<void> changeEmail(String email) async {
    var user = _firebaseAuth.currentUser!;
    await user.updateEmail(email);
  }

  // Changes the user's password
  Future<void> changePassword(String password) async {
    var user = _firebaseAuth.currentUser!;
    await user.updatePassword(password);
  }

  // Sends a verification email
  Future<void> sendVerificationEmail() async {
    var user = _firebaseAuth.currentUser!;
    await user.sendEmailVerification();
  }

  // Reauthenticates the user
  Future<void> reauthenticate(String password) async {
    var user = _firebaseAuth.currentUser!;
    var credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
  }

  // Disconnects the user
  Future<void> disconnect() async {
    await _firebaseAuth.signOut();
  }
}
