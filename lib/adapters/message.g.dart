// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../model/messaging/message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 5;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      creation: fields[0] as String,
      name: fields[1] as String,
      messageType: fields[2] as MessageType,
      messageName: fields[3] as String,
      title: fields[4] as String,
      replies: (fields[7] as List).cast<Reply>(),
      studentNo: fields[5] as String?,
      studentName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.creation)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.messageType)
      ..writeByte(3)
      ..write(obj.messageName)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.studentNo)
      ..writeByte(6)
      ..write(obj.studentName)
      ..writeByte(7)
      ..write(obj.replies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
