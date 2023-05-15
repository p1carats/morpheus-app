import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user's gender (there're only two of em)
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
}
