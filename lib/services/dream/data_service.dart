import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/dream_model.dart';

class DreamDataService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all the dreams from a user
  Stream<List<DreamModel>> getDreams(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('dreams')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DreamModel.fromJson(doc.data());
      }).toList();
    });
  }

  // Get one specific dream from a user by its unique ID
  Future<DreamModel?> getDream(String uid, String dreamId) async {
    DocumentSnapshot dreamSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dreams')
        .doc(dreamId)
        .get();

    if (dreamSnapshot.exists) {
      return DreamModel.fromJson(dreamSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('Rêve non trouvé.');
    }
  }

  // Add a new dream
  Future<void> addDream(String uid, DreamModel dream) async {
    try {
      await _firestore.collection('users').doc(uid).collection('dreams').add(
            dream.toJson(),
          );
    } catch (err) {
      throw Exception(err);
    }
  }

  // Update an existing dream
  Future<void> updateDream(String uid, String dreamId, DreamModel dream) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('dreams')
        .doc(dreamId)
        .update(dream.toJson());
  }

  // Delete an existing dream
  Future<void> deleteDream(String uid, String dreamId) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('dreams')
        .doc(dreamId)
        .delete();
  }
}
