// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/album.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlbumAdapter extends TypeAdapter<Album> {
  @override
  final int typeId = 1;

  @override
  Album read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Album(
      title: fields[2] as String,
      creation: fields[0] as String,
      name: fields[1] as String,
      description: fields[3] as String,
      views: fields[4] as int,
      likes: fields[5] as int,
      approvedComments: fields[6] as int,
      fileUrl: fields[7] as String,
      isViewed: fields[8] as int,
      isLiked: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Album obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.approvedComments)
      ..writeByte(7)
      ..write(obj.fileUrl)
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
      other is AlbumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
