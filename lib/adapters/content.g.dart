// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContentAdapter extends TypeAdapter<Content> {
  @override
  final int typeId = 3;

  @override
  Content read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Content(
      contentType: fields[0] as String,
      name: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String,
      creation: fields[4] as String,
      likes: fields[5] as int,
      views: fields[6] as int,
      approvedComments: fields[7] as int,
      isViewed: fields[8] as int,
      isLiked: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Content obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.contentType)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.creation)
      ..writeByte(5)
      ..write(obj.likes)
      ..writeByte(6)
      ..write(obj.views)
      ..writeByte(7)
      ..write(obj.approvedComments)
      ..writeByte(8)
      ..write(obj.isViewed)
      ..writeByte(9)
      ..write(obj.isLiked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
