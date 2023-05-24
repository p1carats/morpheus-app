import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SleepService {
  final HealthFactory health =
      HealthFactory(useHealthConnectIfAvailable: false);
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Health data types that we want to fetch
  List<HealthDataType> types = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_IN_BED
  ];

  Future<bool?> hasPermissions() async {
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    return await health.hasPermissions(types, permissions: permissions);
  }

  // Get the neccessary autorisations and permissions from the user
  Future authorize() async {
    // (Android) Reading sleep data requires the ACTIVITY_RECOGNITION permission
    await Permission.activityRecognition.request();

    if (await hasPermissions() == true) {
      return true;
    }

    // Check if we have permission
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    bool? hastPermissions =
        await health.hasPermissions(types, permissions: permissions);

    if (!hastPermissions!) {
      try {
        return await health.requestAuthorization(types,
            permissions: permissions);
      } catch (err) {
        throw Exception('Une erreur est survenue : $err');
      }
    }
  }

  // Revoke access to the data types
  Future revokeAccess() async {
    try {
      await health.revokePermissions();
    } catch (err) {
      throw Exception('Caught exception in revokeAccess: $err');
    }
  }
}
