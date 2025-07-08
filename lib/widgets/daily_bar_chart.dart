// lib/widgets/daily_bar_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import 'package:gunluk_planlayici/utils/constants.dart';

class DailyBarChart extends StatelessWidget {
  final Map<String, double> dailyTotals;

  const DailyBarChart({super.key, required this.dailyTotals});

  // Çubukların rengini belirlemek için bir yardımcı metot.
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    Color barColor = Colors.blue,
    double width = 22,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y / 60, // Dakikayı saate çevirerek gösteriyoruz.
          color: barColor,
          width: width,
          borderRadius: BorderRadius.zero,
        ),
      ],
    );
  }

  // Grafiğin altındaki gün etiketlerini (PZT, SAL vb.) oluşturan metot.
  Widget getTitles(double value, TitleMeta meta, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = [
      l10n.days_PZT,
      l10n.days_SAL,
      l10n.days_CAR,
      l10n.days_PER,
      l10n.days_CUM,
      l10n.days_CMT,
      l10n.days_PAZ
    ];
    final text = days[value.toInt()];

    return SideTitleWidget(
      meta: meta,
      space: 4,
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final dayKeys = AppConstants.dayKeys; // PZT, SAL, ...

    // Veri haritasını döngüye alarak her gün için bir çubuk grubu oluştur.
    for (int i = 0; i < dayKeys.length; i++) {
      final dayKey = dayKeys[i];
      final totalMinutes = dailyTotals[dayKey] ?? 0.0;
      barGroups.add(makeGroupData(i, totalMinutes));
    }

    // Grafikteki en yüksek Y değerini bul (otomatik ölçekleme için).
    final double maxYValue = (dailyTotals.values
                .fold(0.0, (prev, element) => element > prev ? element : prev) /
            60) *
        1.2;

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: maxYValue > 0
              ? maxYValue
              : 5, // Eğer hiç veri yoksa, varsayılan bir yükseklik ata.
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final dayKey = dayKeys[group.x.toInt()];
                final totalMinutes = dailyTotals[dayKey] ?? 0;
                final hours = totalMinutes ~/ 60;
                final minutes = (totalMinutes % 60).toInt();
                // Çubuğun üzerine gelindiğinde gösterilecek metin.
                return BarTooltipItem(
                  '${hours}h ${minutes}m',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) =>
                    getTitles(value, meta, context),
                reservedSize: 38,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 2 == 0 && value != 0) {
                    // Text widget'ını SideTitleWidget ile sarmalıyoruz ve meta ekliyoruz.
                    return SideTitleWidget(
                      meta: meta,
                      child: Text('${value.toInt()}h',
                          style: const TextStyle(fontSize: 12)),
                    );
                  }
                  // Boşluklar için Text('') yerine SizedBox kullanmak daha güvenlidir.
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
          // gridData: const FlGridData(show: true, drawVerticalLine: false), // Eski kullanım
          gridData: const FlGridData(
              show: true,
              drawVerticalLine: false), // Yeni kullanım (FlGridData)
        ),
      ),
    );
  }
}
