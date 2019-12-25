// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LessonType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LessonTypeAdapter extends TypeAdapter<LessonType> {
  @override
  LessonType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LessonType.lecture;
      case 1:
        return LessonType.laboratory;
      case 2:
        return LessonType.practical;
      case 3:
        return LessonType.offset;
      case 4:
        return LessonType.exam;
      case 5:
        return LessonType.window;
      default:
        return null;
    }
  }

  @override
  void write(BinaryWriter writer, LessonType obj) {
    switch (obj) {
      case LessonType.lecture:
        writer.writeByte(0);
        break;
      case LessonType.laboratory:
        writer.writeByte(1);
        break;
      case LessonType.practical:
        writer.writeByte(2);
        break;
      case LessonType.offset:
        writer.writeByte(3);
        break;
      case LessonType.exam:
        writer.writeByte(4);
        break;
      case LessonType.window:
        writer.writeByte(5);
        break;
    }
  }
}
