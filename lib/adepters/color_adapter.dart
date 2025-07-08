import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 3;

  @override
  Color read(BinaryReader reader) {
    // 1. Değeri nullable (null olabilir) bir int olarak oku.
    final value = reader.read() as int?;

    // 2. Eğer değer null ise (veri bozuk veya eksikse),
    //    çökmek yerine varsayılan bir renk döndür.
    if (value == null) {
      return Colors.grey.shade400; // Güvenli bir varsayılan renk
    }

    // 3. Değer null değilse, normal şekilde rengi oluştur.
    return Color(value);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.write(obj.toARGB32());
  }
}
