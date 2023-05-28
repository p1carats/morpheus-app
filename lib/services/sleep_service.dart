import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class SleepService {
  final HealthFactory health =
      HealthFactory(useHealthConnectIfAvailable: false);

  // Health data types that we want to fetch
  List<HealthDataType> types = [
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_IN_BED
  ];

  // Get the neccessary autorisations and permissions from the user
  Future authorize() async {
    // (Android) Reading sleep data requires the ACTIVITY_RECOGNITION permission
    await Permission.activityRecognition.request();

    // Check if we have permission
    final permissions = types.map((e) => HealthDataAccess.READ).toList();
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);
    hasPermissions = false;
    bool authorized = false;
    if (!hasPermissions) {
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (err) {
        throw Exception('Exception in authorize: $err');
      }
    }
    return authorized;
  }

  // Revoke access to the data types
  Future revokeAccess() async {
    try {
      await health.revokePermissions();
    } catch (err) {
      print('Caught exception in revokeAccess: $err');
    }
  }
}
