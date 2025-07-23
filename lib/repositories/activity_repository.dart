import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_model.dart';
import '../utils/constants.dart';

class ActivityRepository {
  final Box _activitiesBox;
  ActivityRepository(this._activitiesBox);

  Map<String, List<Activity>> loadActivities() {
    final Map<String, List<Activity>> dailyActivities = {};
    for (var dayKey in AppConstants.dayKeys) {
      final activityList =
          _activitiesBox.get(dayKey, defaultValue: <Activity>[]);

      // DEĞİŞİKLİK: Hive'dan gelen nesnelerin kopyalarını oluşturuyoruz.
      dailyActivities[dayKey] = List<Activity>.from(activityList)
          .map((activity) => activity.copyWith()) // Her aktiviteyi klonla
          .toList();
    }
    return dailyActivities;
  }

  Future<void> saveActivitiesForDay(
      String dayKey, List<Activity> activities) async {
    await _activitiesBox.put(dayKey, activities);
  }
}
