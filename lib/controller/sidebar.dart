import 'package:chat_all/model/message.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SidebarPageController extends GetxController {

  final histories = <HistoryMessage>[].obs;
  final defaultOverview = "default_history_chat_overview".tr;
  final choice = 0.obs;

  @override
  void onInit() {
    super.onInit();

    histories.add(
        HistoryMessage(
            id: const Uuid().v1(), title: defaultOverview, messages: [], createTime: DateTime.now())
    );
  }

  void setChoice(int index){
    choice.value = index;
    update();
  }

  void addHistory(HistoryMessage historyMessage) {
    histories.add(historyMessage);
    update();
  }

  void updateHistory(HistoryMessage historyMessage) {
    int len = histories.length;
    bool hasHistory = false;
    for (int i = 0; i < len; i++) {
      if (histories[i].id == historyMessage.id) {
        histories[i] = historyMessage;
        hasHistory = true;
        break;
      }
    }
    if (!hasHistory) {
      histories.add(historyMessage);
    }
    update();
  }

  void deleteHistory(int index) {
    histories.removeAt(index);
    if (histories.isEmpty) {
      histories.add(HistoryMessage(
          id: const Uuid().v1(), title: defaultOverview, messages: [], createTime: DateTime.now()));
    }
    update();
  }

  void newHistory() {

    histories.add(HistoryMessage(
        id: const Uuid().v1(), title: defaultOverview, messages: [], createTime: DateTime.now()));
    update();
  }
}
