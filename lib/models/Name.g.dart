// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Name.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NameAdapter extends TypeAdapter<Name> {
  @override
  Name read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Name(
      fullName: fields[1] as String,
      shortName: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Name obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.shortName)
      ..writeByte(1)
      ..write(obj.fullName);
  }
}
