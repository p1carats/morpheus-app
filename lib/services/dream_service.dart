import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dream_model.dart';

class DreamService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all the dreams from a user
  Stream<List<DreamModel>> fetchAllDreams(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('dreams')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DreamModel.fromJson({
          'id': doc.id,
          ...doc.data(),
        });
      }).toList();
    });
  }

  // Get one specific dream from a user by its unique ID
  Future<DreamModel> getDream(String uid, String id) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('dreams')
          .doc(id)
          .get();
      if (snapshot.exists) {
        return DreamModel.fromJson({
          'id': snapshot.id,
          ...snapshot.data() as Map<String, dynamic>,
        });
      } else {
        throw Exception('Rêve non trouvé.');
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  // Add a new dream
  Future<DreamModel> addDream(String uid, DreamModel dream) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('dreams')
          .add(dream.toJson());
      return dream.copyWith(id: docRef.id);
    } catch (err) {
      throw Exception(err);
    }
  }

  // Update an existing dream
  Future<void> updateDream(String uid, String id, DreamModel dream) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('dreams')
          .doc(id)
          .update(dream.toJson());
    } catch (err) {
      throw Exception('Error updating dream: $err');
    }
  }

  // Delete an existing dream
  Future<void> deleteDream(String uid, String dreamId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('dreams')
          .doc(dreamId)
          .delete();
    } catch (err) {
      throw Exception('Error deleting dream: $err');
    }
  }
}
