// lib/screens/statistics_page.dart (YENİ HALİ)

import 'package:flutter/material.dart';
import 'package:gunluk_planlayici/providers/statistics_provider.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../widgets/tag_pie_chart.dart';
import '../widgets/daily_bar_chart.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.statisticsPageTitle),
      ),
      // Consumer widget'ı ile StatisticsProvider'ı dinliyoruz.
      // Provider'da bir değişiklik olduğunda (notifyListeners çağrıldığında)
      // sadece bu builder bloğu yeniden çizilir.
      body: Consumer<StatisticsProvider>(
        builder: (context, provider, child) {
          // Eğer hiç etiket verisi yoksa (yani hiç aktivite yoksa),
          // kullanıcıya bilgilendirici bir mesaj göster.
          if (provider.tagDistribution.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  l10n.noDataForStatistics,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            );
          }

          // Veri varsa, grafikler için hazırladığımız arayüzü göster.
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Pasta Grafiği için Kart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.tagDistributionTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      TagPieChart(tagDistribution: provider.tagDistribution),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Çubuk Grafiği için Kart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dailyActivityTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      DailyBarChart(dailyTotals: provider.dailyTotals),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
