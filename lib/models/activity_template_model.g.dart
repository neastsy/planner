// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_template_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityTemplateAdapter extends TypeAdapter<ActivityTemplate> {
  @override
  final int typeId = 4;

  @override
  ActivityTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityTemplate(
      id: fields[0] as String?,
      name: fields[1] as String,
      durationInMinutes: fields[2] as int,
      color: fields[3] as Color,
      note: fields[4] as String?,
      notificationMinutesBefore: fields[5] as int?,
      tags: (fields[6] as List?)?.cast<String>(),
      isNotificationRecurring: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityTemplate obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.durationInMinutes)
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.note)
      ..writeByte(5)
      ..write(obj.notificationMinutesBefore)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.isNotificationRecurring);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
