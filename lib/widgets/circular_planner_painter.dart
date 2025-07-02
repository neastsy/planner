import 'dart:math';
import 'package:flutter/material.dart';
import '../models/activity_model.dart';

class CircularPlannerPainter extends CustomPainter {
  final List<Activity> activities;
  final Color textColor;
  final Color circleColor;

  CircularPlannerPainter({
    required this.activities,
    required this.textColor,
    required this.circleColor,
  });

  double _timeToAngle(TimeOfDay time) =>
      ((time.hour + time.minute / 60) / 24) * 2 * pi - (pi / 2);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 20;

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

    final drawableActivities = List<Activity>.from(activities);

    drawableActivities
        .sort((a, b) => b.durationInMinutes.compareTo(a.durationInMinutes));

    for (final activity in drawableActivities) {
      final startAngle = _timeToAngle(activity.startTime);
      final endAngle = _timeToAngle(activity.endTime);
      final sweepAngle = (endAngle - startAngle) >= 0
          ? endAngle - startAngle
          : (2 * pi) + endAngle - startAngle;

      final activityPaint = Paint()
        ..color = activity.color
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
    final now = DateTime.now();
    final currentTimeOfDay = TimeOfDay.fromDateTime(now);
    final nowAngle = _timeToAngle(currentTimeOfDay);

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

  @override
  bool shouldRepaint(covariant CircularPlannerPainter oldDelegate) =>
      oldDelegate.activities != activities ||
      oldDelegate.textColor != textColor ||
      oldDelegate.circleColor != circleColor;
}
