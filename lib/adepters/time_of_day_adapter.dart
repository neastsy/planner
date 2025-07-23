import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = 2;

  @override
  TimeOfDay read(BinaryReader reader) {
    try {
      final hour = reader.readByte();
      final minute = reader.readByte();
      // Saat ve dakika değerlerinin geçerli aralıkta olup olmadığını kontrol et
      if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
        return TimeOfDay(hour: hour, minute: minute);
      } else {
        // Geçersiz değerler için varsayılan bir saat döndür
        return const TimeOfDay(hour: 0, minute: 0);
      }
    } catch (e) {
      // Okuma sırasında herhangi bir hata olursa (örn: dosya sonu)
      // yine güvenli bir varsayılan değer döndür
      debugPrint("Error reading TimeOfDay: $e");
      return const TimeOfDay(hour: 0, minute: 0);
    }
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeByte(obj.hour);
    writer.writeByte(obj.minute);
  }
}
