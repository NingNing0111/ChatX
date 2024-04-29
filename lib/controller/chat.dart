import 'package:dart_openai/dart_openai.dart';
import 'package:get/get.dart';

import '../model/message.dart';

class ChatPageController extends GetxController {
  final messages = <Message>[].obs;
  final historyId = "1";

  @override
  void onInit() {
    super.onInit();
  }

  void updateMessage(int index, String content){
    messages[index].content = content;
    update();
  }

  void addMessage(Message message){
    messages.add(message);
    update();
  }
}


