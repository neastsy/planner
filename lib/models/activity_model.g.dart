// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 1;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      id: fields[0] as String?,
      name: fields[1] as String,
      startTime: fields[2] as TimeOfDay,
      endTime: fields[3] as TimeOfDay,
      color: fields[4] as Color,
      note: fields[5] as String?,
      notificationMinutesBefore: fields[6] as int?,
      tags: (fields[7] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.startTime)
      ..writeByte(3)
      ..write(obj.endTime)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.notificationMinutesBefore)
      ..writeByte(7)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
