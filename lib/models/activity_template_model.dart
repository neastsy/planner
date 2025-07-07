import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// Bu satır, build_runner çalıştırıldıktan sonra hata vermeyecektir.
part 'activity_template_model.g.dart';

@HiveType(typeId: 4)
class ActivityTemplate extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int durationInMinutes;

  @HiveField(3)
  final Color color;

  @HiveField(4)
  final String? note;

  @HiveField(5)
  final int? notificationMinutesBefore;

  // Gelecekteki etiketleme özelliği için şimdiden eklendi.
  @HiveField(6)
  final List<String> tags;

  ActivityTemplate({
    String? id,
    required this.name,
    required this.durationInMinutes,
    required this.color,
    this.note,
    this.notificationMinutesBefore,
    List<String>? tags,
  })  : id = id ?? const Uuid().v4(),
        tags = tags ?? []; // Eğer etiket listesi verilmezse, boş liste ata.
}
