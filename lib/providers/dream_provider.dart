import 'package:flutter/foundation.dart';

import '../models/dream_model.dart';
import '../services/dream_service.dart';

class DreamProvider with ChangeNotifier {
  final DreamService _dreamService;

  DreamProvider({required DreamService dreamService})
      : _dreamService = dreamService;
}
