import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppStateProvider with ChangeNotifier {
// lets define a method to check and manipulate onboard status
  void hasOnboarded() async {
    // Get the SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // set the onBoardCount to true
    await prefs.setBool('hasOnboarded', true);
    // Notify listener provides converted value to all it listeneres
    notifyListeners();
  }
}
