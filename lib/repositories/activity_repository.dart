import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_model.dart';
import '../utils/constants.dart';

class ActivityRepository {
  final String _boxName = AppConstants.activitiesBoxName;

  ActivityRepository();

  Future<Map<String, List<Activity>>> loadActivities() async {
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box(_boxName).close();
    }
    final box = await Hive.openBox(_boxName);

    final Map<String, List<Activity>> dailyActivities = {};
    for (var dayKey in AppConstants.dayKeys) {
      final activityList = box.get(dayKey, defaultValue: <Activity>[]);
      dailyActivities[dayKey] = List<Activity>.from(activityList);
    }
    return dailyActivities;
  }

  Future<void> saveActivitiesForDay(
      String dayKey, List<Activity> activities) async {
    final box = await Hive.openBox(_boxName);
    await box.put(dayKey, activities);
  }
}
