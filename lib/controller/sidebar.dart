import 'package:chat_all/model/message.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class SidebarPageController extends GetxController {
  final histories = <HistoryMessage>[HistoryMessage(id: Uuid().v1(), title: "新的对话", messages: [], createTime: DateTime.now())].obs;
}