import 'dart:async';

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
  Future<void> streamChat(
      {required List<Message> messages,
      required String model,
      required double temperature,
      required double topP,
      required double presencePenalty,
      required double frequencyPenalty,
      required Function onDone,
      Function? onError,
      required ValueChanged resultBack}) async {
    var chatMessages = transformMessage(messages);
    final chatStream = OpenAI.instance.chat.createStream(
        model: model,
        messages: chatMessages,
        temperature: temperature,
        topP: topP,
        presencePenalty: presencePenalty,
        frequencyPenalty: frequencyPenalty);
    final completer = Completer<bool>();

    var assistantMessage = "";
    chatStream.listen((event) {
      var content = event.choices.first.delta.content;
      if (content != null && !completer.isCompleted) {
        String subText = content.first!.text!;
        assistantMessage = assistantMessage + subText;
        resultBack(assistantMessage);
      } else {
        if(!completer.isCompleted){
          completer.complete(true);
          assistantMessage = "";
        }
      }
    }, onDone: () {
      onDone();
      if(!completer.isCompleted){
        completer.complete(true);
        assistantMessage = "";
      }
    }, onError: (err) {
      resultBack(err.toString());
      if(!completer.isCompleted){
        completer.complete(true);
        assistantMessage = "";
      }
    });
    await completer.future;
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
