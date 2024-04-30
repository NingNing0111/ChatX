import 'package:dart_openai/dart_openai.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/message.dart';

var uuid = Uuid();

class ChatPageController extends GetxController {
  final HistoryMessage historyMessages = HistoryMessage(
      id: uuid.v1(), title: "新的对话", messages: [], createTime: DateTime.now());

  @override
  void onInit() {
    super.onInit();
  }

  void updateMessage(int index, String content) {
    historyMessages.messages[index].content = content;
    update();
  }

  void addMessage(Message message) {
    historyMessages.messages.add(message);
    update();
  }
}
