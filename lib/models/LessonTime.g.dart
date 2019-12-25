// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LessonTime.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonTimeAdapter extends TypeAdapter<LessonTime> {
  @override
  LessonTime read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LessonTime(
      start: fields[0] as DateTime,
      end: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LessonTime obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end);
  }
}
