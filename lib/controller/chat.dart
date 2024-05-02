import 'package:chat_all/controller/sidebar.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../model/message.dart';

var uuid = Uuid();

class ChatPageController extends GetxController {
  HistoryMessage historyMessages = Get.find<SidebarPageController>().histories.last;

  @override
  void onInit() {
    super.onInit();
  }

  void updateMessageContent(int index, String content) {
    historyMessages.messages[index].content = content;
    update();
  }

  void addMessage(Message message) {
    historyMessages.messages.add(message);
    update();
  }

  void reloadHistory() {
    historyMessages = Get.find<SidebarPageController>().histories.last;
    update();
  }

  void setHistory(HistoryMessage history) {
    historyMessages = history;
    update();
  }
}
