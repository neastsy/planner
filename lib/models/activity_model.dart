import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part '../activity_model.g.dart';

@HiveType(typeId: 1)
class Activity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final TimeOfDay startTime;

  @HiveField(3)
  final TimeOfDay endTime;

  @HiveField(4)
  final Color color;

  @HiveField(5)
  final String? note;

  @HiveField(6)
  final int? notificationMinutesBefore;

  int get durationInMinutes {
    final startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    if (endMinutes < startMinutes) {
      endMinutes += 24 * 60;
    }
    return endMinutes - startMinutes;
  }

  Activity({
    String? id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.color,
    this.note,
    this.notificationMinutesBefore,
  }) : id = id ?? const Uuid().v4();
}
