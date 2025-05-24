// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pole_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoleAdapter extends TypeAdapter<Pole> {
  @override
  final int typeId = 1;

  @override
  Pole read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pole(
      number: fields[1] as String,
      repairs: (fields[2] as List).cast<Repair>(),
      userName: fields[3] as String?,
      check: fields[4] as bool?,
      lastCheckDate: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Pole obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.repairs)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.check)
      ..writeByte(5)
      ..write(obj.lastCheckDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
