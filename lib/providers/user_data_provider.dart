import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/user_data_service.dart';

class UserDataProvider extends ChangeNotifier {
  final UserDataService _userDataService;

  late Genders _gender;
  late DateTime _birthDate;

  UserDataProvider({required UserDataService userDataService})
      : _userDataService = userDataService;

  Genders get gender => _gender;
  DateTime get birthDate => _birthDate;

  Future<void> updateGender(String uid, Genders gender) async {
    await _userDataService.setGender(uid, gender);
    _gender = gender;
    notifyListeners();
  }

  Future<void> updateSleepHours(String uid, DateTime birthDate) async {
    await _userDataService.setBirthDate(uid, birthDate);
    _birthDate = birthDate;
    notifyListeners();
  }
}
