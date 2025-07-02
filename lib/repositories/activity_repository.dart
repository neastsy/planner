import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_model.dart';

class ActivityRepository {
  final Box<Map> _activitiesBox;
  ActivityRepository(this._activitiesBox);
  static const String _activitiesKey = 'daily_activities';

  Map<String, List<Activity>> loadActivities() {
    final Map<String, List<Activity>> dailyActivities = {
      'PZT': [],
      'SAL': [],
      'ÇAR': [],
      'PER': [],
      'CUM': [],
      'CMT': [],
      'PAZ': []
    };

    final dynamic savedData = _activitiesBox.get(_activitiesKey);

    if (savedData != null && savedData is Map) {
      savedData.forEach((key, value) {
        if (dailyActivities.containsKey(key) && value is List) {
          dailyActivities[key] = value.cast<Activity>().toList();
        }
      });
    }
    return dailyActivities;
  }

  Future<void> saveActivities(Map<String, List<Activity>> activities) async {
    await _activitiesBox.put(_activitiesKey, activities);
  }
}
