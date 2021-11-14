// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/parent/parent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentAdapter extends TypeAdapter<Parent> {
  @override
  final int typeId = 7;

  @override
  Parent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parent(
      contractNo: fields[0] as String,
      name: fields[1] as String,
      branchCode: fields[2] as String,
      branchName: fields[3] as String,
      yearName: fields[4] as String,
      students: (fields[5] as List).cast<Student>(),
      mobileNo: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Parent obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.contractNo)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.branchCode)
      ..writeByte(3)
      ..write(obj.branchName)
      ..writeByte(4)
      ..write(obj.yearName)
      ..writeByte(5)
      ..write(obj.students)
      ..writeByte(6)
      ..write(obj.mobileNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
