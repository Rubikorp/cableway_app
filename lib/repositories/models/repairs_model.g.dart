// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repairs_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepairAdapter extends TypeAdapter<Repair> {
  @override
  final int typeId = 2;

  @override
  Repair read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Repair(
      id: fields[0] as String,
      description: fields[1] as String,
      urgent: fields[2] as bool,
      completed: fields[3] as bool,
      date: fields[4] as String,
      dateComplete: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Repair obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.urgent)
      ..writeByte(3)
      ..write(obj.completed)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.dateComplete);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepairAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
