// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 1;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    var roleField = fields[1].toString();
    OpenAIChatMessageRole role = OpenAIChatMessageRole.user;
    switch(roleField){
      case "user": role = OpenAIChatMessageRole.user;break;
      case "assistant": role = OpenAIChatMessageRole.assistant;break;
      case "system": role = OpenAIChatMessageRole.system;break;
      case "tool": role = OpenAIChatMessageRole.tool;break;
      case "function": role = OpenAIChatMessageRole.function;break;
    }
    return Message(
      content: fields[0] as String,
      role: role,
      historyId: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.role.name)
      ..writeByte(2)
      ..write(obj.historyId);
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

class HistoryMessageAdapter extends TypeAdapter<HistoryMessage> {
  @override
  final int typeId = 2;

  @override
  HistoryMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HistoryMessage(
      id: fields[0] as String,
      title: fields[1] as String,
      messages: (fields[2] as List).cast<Message>(),
      createTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HistoryMessage obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.createTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
