// lib/widgets/tag_pie_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gunluk_planlayici/l10n/app_localizations.dart';

class TagPieChart extends StatefulWidget {
  final Map<String, double> tagDistribution;

  const TagPieChart({super.key, required this.tagDistribution});

  @override
  State<TagPieChart> createState() => _TagPieChartState();
}

class _TagPieChartState extends State<TagPieChart> {
  int? touchedIndex;

  // Rastgele renkler üretmek için bir yardımcı liste.
  // Gerçek bir uygulamada bu renkler daha anlamlı olabilir (örn. etiketin kendi rengi).
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.yellow,
    Colors.cyan,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<PieChartSectionData> sections = [];
    final List<Widget> indicators = [];
    int colorIndex = 0;

    // Toplam süreyi hesapla (yüzde hesabı için gerekli).
    final double totalValue = widget.tagDistribution.values
        .fold(0, (prev, element) => prev + element);

    widget.tagDistribution.forEach((tag, value) {
      final isTouched = sections.length == touchedIndex;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final color = _colors[colorIndex % _colors.length];

      // Pasta grafiğinin her bir dilimini oluştur.
      sections.add(PieChartSectionData(
        color: color,
        value: value,
        title: '${(value / totalValue * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      ));

      // Grafiğin yanındaki renkli göstergeleri (lejant) oluştur.
      indicators.add(
        Indicator(
          color: color,
          // 'untagged' anahtarını yerelleştirilmiş metne çevir.
          text: tag == 'untagged' ? l10n.untagged : tag,
          isSquare: false,
          size: 14,
          textColor: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      );

      colorIndex++;
    });

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Lejantı oluştur.
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: indicators,
        ),
      ],
    );
  }
}

// Lejant için yardımcı bir widget.
class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
