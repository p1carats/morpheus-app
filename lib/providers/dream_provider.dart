import 'package:flutter/foundation.dart';

import '../models/dream_model.dart';
import '../services/dream_service.dart';

class DreamProvider with ChangeNotifier {
  final DreamService _dreamService = DreamService();

  List<DreamModel> _dreams = [];
  List<DreamModel> get dreams => _dreams;

  String _filterType = 'all'; // 'all', 'dream', 'nightmare', 'lucid'
  String get filterType => _filterType;

  bool _isOrderedChronologically = true;

  void updateDreams(List<DreamModel> dreams) {
    _dreams = dreams;
    notifyListeners();
  }

  void listenToDreams(String uid) {
    _dreamService.fetchAllDreams(uid).listen(updateDreams);
  }

  void setFilter(String filter) {
    _filterType = filter;
    notifyListeners();
  }

  void toggleOrder() {
    _isOrderedChronologically = !_isOrderedChronologically;
    notifyListeners();
  }

  List<DreamModel> get filteredDreams {
    var filteredDreams = _dreams;

    if (_filterType == 'dream') {
      filteredDreams = _dreams.where((dream) => dream.type == 'dream').toList();
    } else if (_filterType == 'nightmare') {
      filteredDreams =
          _dreams.where((dream) => dream.type == 'nightmare').toList();
    } else if (_filterType == 'lucid') {
      filteredDreams = _dreams.where((dream) => dream.isLucid).toList();
    }

    if (_isOrderedChronologically) {
      filteredDreams.sort((a, b) => b.date.compareTo(a.date));
    }

    return filteredDreams;
  }

  Future<DreamModel> getDream(String uid, String id) async {
    return await _dreamService.getDream(uid, id);
  }

  Future<void> addDream(String uid, DreamModel dream) async {
    await _dreamService.addDream(uid, dream);
  }

  Future<void> updateDream(String uid, String id, DreamModel dream) async {
    await _dreamService.updateDream(uid, id, dream);
  }

  Future<void> deleteDream(String uid, String id) async {
    await _dreamService.deleteDream(uid, id);
  }
}
