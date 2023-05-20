import 'package:flutter/foundation.dart';

import '../models/dream_model.dart';
import '../services/dream_service.dart';

class DreamProvider with ChangeNotifier {
  final DreamService _dreamService = DreamService();

  List<DreamModel> _dreams = [];
  List<DreamModel> get dreams => _dreams;

  void updateDreams(List<DreamModel> dreams) {
    _dreams = dreams;
    notifyListeners();
  }

  void listenToDreams(String uid) {
    _dreamService.fetchAllDreams(uid).listen(updateDreams);
  }

  Future<DreamModel> getDream(String uid, String dreamId) async {
    return await _dreamService.getDream(uid, dreamId);
  }

  Future<void> addDream(String uid, DreamModel dream) async {
    var dreamWithId = await _dreamService.addDream(uid, dream);
    _dreams.add(dreamWithId);
    notifyListeners();
  }

  Future<void> updateDream(String uid, String dreamId, DreamModel dream) async {
    await _dreamService.updateDream(uid, dreamId, dream);
  }

  Future<void> deleteDream(String uid, String dreamId) async {
    await _dreamService.deleteDream(uid, dreamId);
  }
}
