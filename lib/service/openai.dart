import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';

import '../model/message.dart';

class OpenAIService {
  OpenAIService() {
    // OpenAI.showLogs = true;
    OpenAI.showResponsesLogs = true;
  }

  void init({required String api, required String key}) {
    OpenAI.apiKey = key;
    OpenAI.baseUrl = api;
  }

  // 流式对话
  void streamChat(
      {required List<Message> messages,
      required String model,
      required double temperature,
      required double topP,
      required double presencePenalty,
      required double frequencyPenalty,
      required Function onDone,
      Function? onError,
      required ValueChanged resultBack}) {
    var chatMessages = transformMessage(messages);
    var assistantMessage = <String>{};
    final chatStream = OpenAI.instance.chat.createStream(
        model: model,
        messages: chatMessages,
        temperature: temperature,
        topP: topP,
        presencePenalty: presencePenalty,
        frequencyPenalty: frequencyPenalty);
    chatStream.listen((event) async {
      var content = event.choices.first.delta.content;
      if(content != null){
        String subText = content.first!.text!;
        if(!assistantMessage.contains(subText)){
          assistantMessage.add(subText);
          resultBack(assistantMessage.join());
        }
      }

    }, onDone: (){
      assistantMessage.clear();
    });
  }

  // 将Message List转换为
  List<OpenAIChatCompletionChoiceMessageModel> transformMessage(
      List<Message> messages) {
    List<OpenAIChatCompletionChoiceMessageModel> chatMessages = [];
    for (Message message in messages) {
      var curChatMessage = OpenAIChatCompletionChoiceMessageModel(content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(message.content)
      ], role: message.role);
      chatMessages.add(curChatMessage);
    }
    return chatMessages;
  }
}
