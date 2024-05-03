
import 'package:dart_openai/dart_openai.dart';
import 'package:hive/hive.dart';

part 'message.g.dart';

// 会话信息
@HiveType(typeId: 1)
class Message {
  
  // 内容
  @HiveField(0)
  String content;
  // 角色
  @HiveField(1)
  OpenAIChatMessageRole role;
  // historyMessageID
  @HiveField(2)
  String historyId;

  Message({required this.content, required this.role, required this.historyId});

  @override
  String toString() {
    return 'Message{content: $content, role: $role, historyId: $historyId}';
  }
}

@HiveType(typeId: 2)
// 历史记录
class HistoryMessage {
  // UUID
  @HiveField(0)
  String id;
  // 标题
  @HiveField(1)
  String title;
  // 会话记录
  @HiveField(2)
  List<Message> messages;
  // 创建时间
  @HiveField(3)
  DateTime createTime;

  HistoryMessage({required this.id, required this.title, required this.messages, required this.createTime});

  @override
  String toString() {
    return 'HistoryMessage{id: $id, title: $title, messages: $messages, createTime: $createTime}';
  }
}