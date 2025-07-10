// lib/providers/statistics_provider.dart (YENİ HALİ)

import 'package:flutter/foundation.dart';
import 'package:gunluk_planlayici/models/activity_model.dart';
import 'package:gunluk_planlayici/providers/activity_provider.dart';

class StatisticsProvider with ChangeNotifier {
  ActivityProvider? _activityProvider;

  // Hesaplanan verileri tutacak olan haritalar.
  Map<String, double> _tagDistribution = {};
  Map<String, double> _dailyTotals = {};

  // UI'ın bu verilere erişmesi için getter'lar.
  Map<String, double> get tagDistribution => _tagDistribution;
  Map<String, double> get dailyTotals => _dailyTotals;

  // Bu metot, ActivityProvider her değiştiğinde ChangeNotifierProxyProvider
  // tarafından otomatik olarak çağrılır.
  void update(ActivityProvider activityProvider) {
    // Gelen en güncel ActivityProvider'ı kendi içimizde saklıyoruz.
    _activityProvider = activityProvider;

    // Aktivite verileri her güncellendiğinde istatistikleri yeniden hesapla.
    _calculateStatistics();

    // Hesaplamalar bittikten sonra UI'ı bilgilendir.
    notifyListeners();
  }

  // Asıl hesaplama mantığının bulunduğu özel metot.
  void _calculateStatistics() {
    if (_activityProvider == null) return;

    final newTagDistribution = <String, double>{};
    final newDailyTotals = <String, double>{};

    final allActivitiesByDay = _activityProvider!.dailyActivities;

    allActivitiesByDay.forEach((dayKey, activities) {
      double totalMinutesForDay = 0;

      for (final Activity activity in activities) {
        final duration = activity.durationInMinutes.toDouble();

        totalMinutesForDay += duration;

        // 5. Etiket dağılımını hesapla.
        if (activity.tags.isEmpty) {
          const untaggedKey = 'untagged';
          newTagDistribution[untaggedKey] =
              (newTagDistribution[untaggedKey] ?? 0) + duration;
        } else {
          for (final String tag in activity.tags) {
            newTagDistribution[tag] = (newTagDistribution[tag] ?? 0) + duration;
          }
        }
      }

      // 6. Gün için hesaplanan toplam süreyi haritaya ekle.
      newDailyTotals[dayKey] = totalMinutesForDay.clamp(0, 1440);
    });

    _tagDistribution = newTagDistribution;
    _dailyTotals = newDailyTotals;
  }
}
