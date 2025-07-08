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
    // Eğer henüz ActivityProvider'dan veri gelmediyse, hiçbir şey yapma.
    if (_activityProvider == null) return;

    // 1. Her hesaplama öncesi haritaları temizle.
    final newTagDistribution = <String, double>{};
    final newDailyTotals = <String, double>{};

    // 2. ActivityProvider'dan tüm haftanın aktivitelerini al.
    final allActivitiesByDay = _activityProvider!.dailyActivities;

    // 3. Her bir günü (PZT, SAL, ...) ve o güne ait aktiviteleri döngüye al.
    allActivitiesByDay.forEach((dayKey, activities) {
      double totalMinutesForDay = 0;

      // 4. O gün içindeki her bir aktiviteyi döngüye al.
      for (final Activity activity in activities) {
        final duration = activity.durationInMinutes.toDouble();

        // O günün toplam süresini artır.
        totalMinutesForDay += duration;

        // 5. Etiket dağılımını hesapla.
        if (activity.tags.isEmpty) {
          // YENİ: Sabit bir anahtar kullanıyoruz.
          const untaggedKey = 'untagged';
          newTagDistribution[untaggedKey] =
              (newTagDistribution[untaggedKey] ?? 0) + duration;
        } else {
          // Aktivitenin her bir etiketini döngüye al.
          for (final String tag in activity.tags) {
            // Haritada o etiketin süresini aktivitenin süresi kadar artır.
            // Eğer etiket haritada yoksa, 0'dan başlat.
            newTagDistribution[tag] = (newTagDistribution[tag] ?? 0) + duration;
          }
        }
      }

      // 6. Gün için hesaplanan toplam süreyi haritaya ekle.
      newDailyTotals[dayKey] = totalMinutesForDay;
    });

    // 7. Hesaplanan yeni verileri provider'ın asıl değişkenlerine ata.
    _tagDistribution = newTagDistribution;
    _dailyTotals = newDailyTotals;
  }
}
