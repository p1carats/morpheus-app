import 'package:flutter/foundation.dart';

import '../models/dream_model.dart';
import '../services/dream_service.dart';

class DreamProvider with ChangeNotifier {
  final DreamService _dreamService = DreamService();

  List<DreamModel> _dreams = [];
  List<DreamModel> _filteredDreams = [];
  String _filterType = 'all'; // all, dream, nightmare, isLucid
  bool _isOrderedChronologically = true;

  List<DreamModel> get filteredDreams => _filteredDreams;
  String get filterType => _filterType;
  bool get isOrderedChronologically => _isOrderedChronologically;

  // Update the dreams
  void updateDreams(List<DreamModel> dreams) {
    _dreams = dreams;
    _filterDreams();
  }

  // Filter the dreams
  void _filterDreams() {
    _filteredDreams = _dreams.where((dream) {
      switch (_filterType) {
        case 'dream':
          return dream.type == DreamType.dream;
        case 'nightmare':
          return dream.type == DreamType.nightmare;
        case 'lucid':
          return dream.isLucid;
        case 'recurrent':
          return dream.isRecurrent;
        default:
          return true;
      }
    }).toList();

    _filteredDreams.sort(
      (a, b) => _isOrderedChronologically
          ? b.date.compareTo(a.date)
          : a.date.compareTo(b.date),
    );

    notifyListeners();
  }

  // Listen to all the dreams from a user
  void listenToDreams(String uid) {
    _dreamService.fetchAllDreams(uid).listen(updateDreams);
  }

  // Set the filter type
  void setFilter(String filter) {
    _filterType = filter;
    _filterDreams();
  }

  // Toggle the order of the dreams
  void toggleOrder() {
    _isOrderedChronologically = !_isOrderedChronologically;
    _filterDreams();
  }

  // Get one specific dream from a user by its unique ID
  Future<DreamModel> getDream(String uid, String id) async {
    try {
      return await _dreamService.getDream(uid, id);
    } catch (err) {
      rethrow;
    }
  }

  // Add a new dream
  Future<void> addDream(String uid, DreamModel dream) async {
    try {
      await _dreamService.addDream(uid, dream);
    } catch (err) {
      rethrow;
    }
  }

  // Update a dream
  Future<void> updateDream(String uid, String id, DreamModel dream) async {
    try {
      await _dreamService.updateDream(uid, id, dream);
    } catch (err) {
      rethrow;
    }
  }

  // Delete a dream
  Future<void> deleteDream(String uid, String id) async {
    try {
      await _dreamService.deleteDream(uid, id);
    } catch (err) {
      rethrow;
    }
  }

  double getLucidDreamPercentage(Duration duration) {
    DateTime startDate = DateTime.now().subtract(duration);
    DateTime endDate = DateTime.now();

    final dreamsInPeriod = _dreams
        .where((dream) =>
            dream.date.isAfter(startDate) && dream.date.isBefore(endDate))
        .toList();

    if (dreamsInPeriod.isEmpty) return 0.0;

    final lucidDreams = dreamsInPeriod.where((dream) => dream.isLucid).length;

    return lucidDreams / dreamsInPeriod.length;
  }

  double getDreamNightmareRatio(Duration duration) {
    DateTime startDate = DateTime.now().subtract(duration);
    DateTime endDate = DateTime.now();

    final dreamsInPeriod = _dreams
        .where((dream) =>
            dream.date.isAfter(startDate) && dream.date.isBefore(endDate))
        .toList();

    if (dreamsInPeriod.isEmpty) return 0.0;

    final dreamCount =
        dreamsInPeriod.where((dream) => dream.type == DreamType.dream).length;
    final nightmareCount = dreamsInPeriod
        .where((dream) => dream.type == DreamType.nightmare)
        .length;

    return nightmareCount != 0 ? dreamCount / nightmareCount : double.infinity;
  }
}
