import 'dart:developer';

import 'package:chat_all/db/message_database.dart';
import 'package:chat_all/model/message.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SidebarPageController extends GetxController {

  final histories = <HistoryMessage>[HistoryMessage(id: Uuid().v1(), title: "default_history_chat_overview".tr, messages: [], createTime: DateTime.now())].obs;

  final choice = 0.obs;

  final db = MessageDatabase();

  @override
  void onInit() {
    super.onInit();
    var storeHistories = db.readAll();
    histories.clear();
    histories.addAll(storeHistories);
    if(histories.isEmpty){
      newHistory();
    }
    update();
  }

  void setChoice(int index){
    choice.value = index;
    update();
  }

  void addHistory(HistoryMessage historyMessage) {
    histories.add(historyMessage);
    db.addHistoryMessage(historyMessage);
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
    db.updateHistoryMessage(historyMessage);
    update();
  }

  void deleteHistory(int index) {
    db.deleteHistoryMessage(histories[index].id);
    histories.removeAt(index);
    if (histories.isEmpty) {
      newHistory();
    }
    update();
  }

  void newHistory() {
    choice.value = 0;
    addHistory(HistoryMessage(
        id: const Uuid().v1(), title: "default_history_chat_overview".tr, messages: [], createTime: DateTime.now()));
    update();
  }

  void clearHistory() {
    histories.clear();
    newHistory();
    choice.value = 0;
    db.clearHistoryMessage();
    update();
  }

  @override
  void onClose() {
    saveAll();
    super.onClose();
  }

  void saveAll() {
    log("聊天数据保存成功");
    db.saveHistory(histories);
  }

}
