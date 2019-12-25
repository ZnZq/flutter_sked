// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Lesson.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonAdapter extends TypeAdapter<Lesson> {
  @override
  Lesson read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Lesson(
      number: fields[0] as int,
      time: fields[1] as LessonTime,
      type: fields[2] as LessonType,
      groupName: fields[4] as String,
      hall: fields[5] as String,
      info: fields[7] as String,
      name: fields[3] as Name,
      teacher: fields[6] as Name,
    );
  }

  @override
  void write(BinaryWriter writer, Lesson obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.number)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.groupName)
      ..writeByte(5)
      ..write(obj.hall)
      ..writeByte(6)
      ..write(obj.teacher)
      ..writeByte(7)
      ..write(obj.info);
  }
}
