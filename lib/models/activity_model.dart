import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'activity_model.g.dart';

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

  @HiveField(7)
  final List<String> tags;

  @HiveField(8)
  final bool isNotificationRecurring;

  int get durationInMinutes {
    // Eğer başlangıç ve bitiş aynıysa, bu 24 saatlik bir aktivitedir.
    if (startTime.hour == endTime.hour && startTime.minute == endTime.minute) {
      return 24 * 60; // 1440 dakika
    }

    final startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;

    // Eğer bitiş saati başlangıçtan önceyse, gece yarısını geçmiştir.
    if (endMinutes <= startMinutes) {
      // Eşitlik durumunu da kapsayacak şekilde güncelledik.
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
    List<String>? tags,
    this.isNotificationRecurring = false,
  })  : id = id ?? const Uuid().v4(),
        tags = tags ?? [];
}
