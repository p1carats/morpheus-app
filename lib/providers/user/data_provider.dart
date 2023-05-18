import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../services/user/data_service.dart';

class UserDataProvider extends ChangeNotifier {
  final UserDataService _userDataService;

  UserModel? _user;
  UserModel? get user => _user;

  late String _gender;
  late DateTime _birthDate;

  UserDataProvider({required UserDataService userDataService})
      : _userDataService = userDataService;

  String get gender => _gender;
  DateTime get birthDate => _birthDate;

  Future<void> updateGender(String uid, String gender) async {
    await _userDataService.setGender(uid, gender);
    _gender = gender;
    notifyListeners();
  }

  Future<void> updateSleepHours(String uid, DateTime birthDate) async {
    await _userDataService.setBirthDate(uid, birthDate);
    _birthDate = birthDate;
    notifyListeners();
  }

  // Delete user with reauthentication
  Future<void> deleteUser() async {
    await _userDataService.deleteUser();
    _user = null;
    notifyListeners();
  }

  // Change email address with reauthentication
  Future<void> changeEmail(String email) async {
    await _userDataService.changeEmail(email);
    _user!.email = email;
    notifyListeners();
  }

  // Change password with reauthentication
  Future<void> changePassword(String password) async {
    await _userDataService.changePassword(password);
  }

  // Send a verification email
  Future<void> sendVerificationEmail() async {
    await _userDataService.sendVerificationEmail();
  }

  // Reauthenticate user
  Future<void> reauthenticate(String password) async {
    await _userDataService.reauthenticate(password);
  }

  // Disconnect user
  Future<void> disconnect() async {
    await _userDataService.disconnect();
    _user = null;
    notifyListeners();
  }
}
