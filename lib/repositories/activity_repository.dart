import 'package:hive_flutter/hive_flutter.dart';
import '../models/activity_model.dart';
import '../utils/constants.dart';

class ActivityRepository {
  // GÜNCELLENDİ: Box'ı daha genel bir tipte alıyoruz.
  final Box _activitiesBox;
  ActivityRepository(this._activitiesBox);

  // GÜNCELLENDİ: loadActivities metodu artık daha verimli.
  Map<String, List<Activity>> loadActivities() {
    final Map<String, List<Activity>> dailyActivities = {};
    for (var dayKey in AppConstants.dayKeys) {
      // Her gün için kendi anahtarından veriyi oku.
      // Eğer veri yoksa, boş bir liste ata.
      final activityList =
          _activitiesBox.get(dayKey, defaultValue: <Activity>[]);
      // Hive'dan gelen listenin tipini doğru şekilde belirle.
      dailyActivities[dayKey] = List<Activity>.from(activityList);
    }
    return dailyActivities;
  }

  // GÜNCELLENDİ: Artık tüm haritayı değil, sadece ilgili günü kaydediyoruz.
  // Bu, Provider katmanından çağrılacak.
  Future<void> saveActivitiesForDay(
      String dayKey, List<Activity> activities) async {
    // Sadece değiştirilen günün listesini kendi anahtarıyla kaydet.
    await _activitiesBox.put(dayKey, activities);
  }
}
