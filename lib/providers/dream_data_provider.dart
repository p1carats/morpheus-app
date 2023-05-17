import 'package:flutter/foundation.dart';

import '../models/dream_model.dart';
import '../services/dream_data_service.dart';

class DreamDataProvider with ChangeNotifier {
  final DreamDataService _dreamDataService;

  DreamDataProvider({required DreamDataService dreamDataService})
      : _dreamDataService = dreamDataService;

  List<DreamModel> _dreams = [];
  List<DreamModel> get dreams => _dreams;

  Future<void> fetchDreams(String uid) async {
    _dreams = await _dreamDataService.getDreams(uid).first;
    notifyListeners();
  }

  Future<void> addDream(String uid, DreamModel dream) async {
    await _dreamDataService.addDream(uid, dream);
    await fetchDreams(uid);
  }

  Future<void> updateDream(String uid, String dreamId, DreamModel dream) async {
    await _dreamDataService.updateDream(uid, dreamId, dream);
    await fetchDreams(uid);
  }

  Future<void> deleteDream(String uid, String dreamId) async {
    await _dreamDataService.deleteDream(uid, dreamId);
    await fetchDreams(uid);
  }
}
