// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/parent/student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 6;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      no: fields[0] as String,
      name: fields[1] as String,
      classCode: fields[2] as String,
      className: fields[3] as String,
      sectionCode: fields[4] as String,
      sectionName: fields[5] as String,
      gender: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.no)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.classCode)
      ..writeByte(3)
      ..write(obj.className)
      ..writeByte(4)
      ..write(obj.sectionCode)
      ..writeByte(5)
      ..write(obj.sectionName)
      ..writeByte(6)
      ..write(obj.gender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
