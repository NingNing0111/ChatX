
import 'package:dart_openai/dart_openai.dart';

// 会话信息
class Message {

  // 内容
  late String content;
  // 角色
  late OpenAIChatMessageRole role;
  // historyMessageID
  late String historyId;

  Message({required this.content, required this.role, required this.historyId});

  @override
  String toString() {
    return 'Message{content: $content, role: $role, historyId: $historyId}';
  }
}

// 历史记录
class HistoryMessage {
  // UUID
  late String id;
  // 标题
  late String title;
  // 会话记录
  late List<Message> messages;
  // 创建时间
  late DateTime createTime;

  HistoryMessage({required this.id, required this.title, required this.messages, required this.createTime});

  @override
  String toString() {
    return 'HistoryMessage{id: $id, title: $title, messages: $messages, createTime: $createTime}';
  }
}