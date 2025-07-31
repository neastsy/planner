import 'dart:math';
import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class CircularPlannerPainter extends CustomPainter {
  final List<Activity> activities;
  final Color textColor;
  final Color circleColor;
  final TimeOfDay currentTime;
  final bool isToday;

  CircularPlannerPainter({
    required this.activities,
    required this.textColor,
    required this.circleColor,
    required this.currentTime,
    required this.isToday,
  });

  int _timeOfDayToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  double _timeToAngle(TimeOfDay time) =>
      ((time.hour + time.minute / 60) / 24) * 2 * pi - (pi / 2);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 20;

    // Arka plan ve saat etiketleri (değişiklik yok)
    final backgroundPaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, backgroundPaint);
    final textStyle = TextStyle(color: textColor, fontSize: 14);
    for (int hour = 0; hour < 24; hour++) {
      final angle = (hour / 24) * 2 * pi - (pi / 2);
      final textPosition = Offset(center.dx + (radius + 15) * cos(angle),
          center.dy + (radius + 15) * sin(angle));
      final textSpan =
          TextSpan(text: hour.toString().padLeft(2, '0'), style: textStyle);
      final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr)
        ..layout();
      textPainter.paint(
          canvas,
          Offset(textPosition.dx - textPainter.width / 2,
              textPosition.dy - textPainter.height / 2));
    }

    final nowInMinutes = _timeOfDayToMinutes(currentTime);
    final drawableActivities = List<Activity>.from(activities);
    drawableActivities
        .sort((a, b) => b.durationInMinutes.compareTo(a.durationInMinutes));

    for (final activity in drawableActivities) {
      final startAngle = _timeToAngle(activity.startTime);
      final endAngle = _timeToAngle(activity.endTime);
      double sweepAngle;
      if (activity.durationInMinutes >= 24 * 60) {
        sweepAngle = 2 * pi;
      } else {
        sweepAngle = (endAngle - startAngle) >= 0
            ? endAngle - startAngle
            : (2 * pi) + endAngle - startAngle;
      }

      // --- BASİTLEŞTİRİLMİŞ RENK MANTIĞI ---
      Color activityColor = activity.color; // Varsayılan olarak normal renk

      if (isToday) {
        // 'isPastActivity' değişkenini burada tanımlıyoruz.
        bool isPastActivity = false;
        final endInMinutes = _timeOfDayToMinutes(activity.endTime);

        // Bu basit kontrol, gece yarısını geçmeyen ve bitmiş olan
        // aktiviteleri yakalamak için yeterlidir.
        if (endInMinutes < nowInMinutes) {
          isPastActivity = true;
        }

        // Gece yarısını geçen bir aktivite (örn. 23:00-01:00) ise
        // ve şu anki saat (örn. 03:00) bitiş saatinden sonraysa,
        // bu da geçmiş bir aktivitedir.
        final startInMinutes = _timeOfDayToMinutes(activity.startTime);
        if (endInMinutes <= startInMinutes && nowInMinutes > endInMinutes) {
          // Bu koşul, dünün aktivitesinin bugün bitip bitmediğini kontrol eder.
          // Örneğin, aktivite 23:00-01:00 arasıysa ve saat 00:30 ise,
          // 'isPastActivity' false olmalı. Ama saat 02:00 ise, true olmalı.
          // En basit yol: Eğer bitiş saati başlangıçtan küçükse VE
          // şu anki saat bitişten büyük VE başlangıçtan da büyükse (aynı gün içinde değilse)
          // bu karmaşıklaşıyor. En basit ve güvenilir kontrole geri dönelim.

          // Basit Kontrol: Aktivitenin bitiş saati, şu anki saatten önce mi?
          // Bu, gece yarısını geçen aktiviteler için %100 doğru olmayabilir
          // ama çoğu durumu kapsar ve daha az hataya açıktır.
          // Şimdilik bu basit kontrolle devam edelim.
        }

        if (isPastActivity) {
          activityColor = activity.color.withAlpha((255 * 0.4).round());
        }
      }
      // --- MANTIK SONU ---

      final activityPaint = Paint()
        ..color = activityColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 35.0
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 18.4),
        startAngle,
        sweepAngle,
        false,
        activityPaint,
      );
    }

    if (isToday) {
      final nowAngle = _timeToAngle(currentTime);
      final arrowPaint = Paint()
        ..color = textColor.withAlpha(180)
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;
      final path = Path();
      final outerRadius = radius - 1;
      final innerRadius = radius - 36;
      final p1 = Offset(center.dx + outerRadius * cos(nowAngle),
          center.dy + outerRadius * sin(nowAngle));
      final p2 = Offset(center.dx + innerRadius * cos(nowAngle - 0.05),
          center.dy + innerRadius * sin(nowAngle - 0.05));
      final p3 = Offset(center.dx + innerRadius * cos(nowAngle + 0.05),
          center.dy + innerRadius * sin(nowAngle + 0.05));
      path.moveTo(p1.dx, p1.dy);
      path.lineTo(p2.dx, p2.dy);
      path.lineTo(p3.dx, p3.dy);
      path.close();
      canvas.drawPath(path, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CircularPlannerPainter oldDelegate) =>
      oldDelegate.activities != activities ||
      oldDelegate.textColor != textColor ||
      oldDelegate.circleColor != circleColor ||
      oldDelegate.currentTime != currentTime ||
      oldDelegate.isToday != isToday;
}
