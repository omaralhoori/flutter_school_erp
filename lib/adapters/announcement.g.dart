// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/announcement.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnnouncementAdapter extends TypeAdapter<Announcement> {
  @override
  final int typeId = 0;

  @override
  Announcement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Announcement(
      title: fields[2] as String,
      creation: fields[0] as String,
      name: fields[1] as String,
      description: fields[3] as String,
      views: fields[4] as int,
      likes: fields[5] as int,
      approvedComments: (fields[6]??0) as int,
    );
  }

  @override
  void write(BinaryWriter writer, Announcement obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.creation)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.views)
      ..writeByte(5)
      ..write(obj.likes)
      ..writeByte(6)
      ..write(obj.approvedComments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnnouncementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
