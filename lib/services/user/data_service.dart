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
    await user.delete();
  }
}
