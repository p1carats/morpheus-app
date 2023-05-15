import 'package:health/health.dart';

class HealthService {
  List<HealthDataPoint> _healthDataList = [];

  Future<List<HealthDataPoint>> getSleepData() async {
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime.now().subtract(const Duration(days: 7));

    // Create a HealthFactory for use in the app
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    // Define the types to get
    List<HealthDataType> types = [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_AWAKE,
      HealthDataType.SLEEP_IN_BED,
    ];

    // Requesting access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        for (HealthDataType type in types) {
          List<HealthDataPoint> healthData =
              await health.getHealthDataFromTypes(startDate, endDate, types);
          _healthDataList.addAll(healthData);
        }

        _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
      } catch (exception) {
        print(exception.toString());
      }
    }

    return _healthDataList;
  }
}
