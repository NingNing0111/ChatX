import 'package:chat_all/controller/sidebar.dart';
import 'package:get/get.dart';

import '../model/message.dart';

class ChatPageController extends GetxController {
  HistoryMessage currHistoryMessage = Get.find<SidebarPageController>().histories.last;
  void updateMessageContent(int index, String content) {
    currHistoryMessage.messages[index].content = content;
    update();
  }

  void addMessage(Message message) {
    currHistoryMessage.messages.add(message);
    update();
  }

  void reloadHistory() {
    currHistoryMessage = Get.find<SidebarPageController>().histories.last;
    update();
  }
  void setHistory(HistoryMessage history) {
    currHistoryMessage = history;
    update();
  }

  @override
  void onClose() {
    Get.find<SidebarPageController>().saveAll();
    super.onClose();
  }
}
