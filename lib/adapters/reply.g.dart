// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/messaging/reply.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReplyAdapter extends TypeAdapter<Reply> {
  @override
  final int typeId = 4;

  @override
  Reply read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reply(
      sendingDate: fields[0] as String,
      name: fields[1] as String,
      senderName: fields[2] as String,
      message: fields[3] as String,
      isRead: fields[4] as int,
      isAdministration: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Reply obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.sendingDate)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.senderName)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.isRead)
      ..writeByte(5)
      ..write(obj.isAdministration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
