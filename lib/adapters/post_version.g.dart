// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/post_version.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PostVersionAdapter extends TypeAdapter<PostVersion> {
  @override
  final int typeId = 8;

  @override
  PostVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PostVersion(
      type: fields[0] as String,
      name: fields[1] as String,
      version: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PostVersion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
