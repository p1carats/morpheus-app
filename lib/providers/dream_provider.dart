import 'package:flutter/foundation.dart';

import '../models/dream_model.dart';
import '../services/dream_service.dart';

class DreamProvider with ChangeNotifier {
  final DreamService _dreamService = DreamService();

  List<DreamModel> _dreams = [];
  List<DreamModel> get dreams => _dreams;

  Future<void> fetchDreams(String uid) async {
    _dreams = await _dreamService.getDreams(uid).first;
    notifyListeners();
  }

  Future<void> addDream(String uid, DreamModel dream) async {
    await _dreamService.addDream(uid, dream);
    await fetchDreams(uid);
  }

  Future<void> updateDream(String uid, String dreamId, DreamModel dream) async {
    await _dreamService.updateDream(uid, dreamId, dream);
    await fetchDreams(uid);
  }

  Future<void> deleteDream(String uid, String dreamId) async {
    await _dreamService.deleteDream(uid, dreamId);
    await fetchDreams(uid);
  }
}
