import 'dart:async';
import 'dart:developer';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';

import '../model/message.dart';

class OpenAIService {
  void init({required String api, required String key}) {
    OpenAI.apiKey = key;
    OpenAI.baseUrl = api;
    // OpenAI.showLogs = true;
    // OpenAI.showResponsesLogs = true;
    OpenAI.requestsTimeOut = const Duration(seconds: 60);
  }

  // 综合绘图+对话
  Future<void> chat(
      {required List<Message> messages,
      required String chatModel,
      required String imageModel,
      required bool isImageChat,
      required double temperature,
      required double topP,
      required double presencePenalty,
      required double frequencyPenalty,
      required Function onDone,
      Function? onError,
      required ValueChanged resultBack}) async {
    // 拷贝一份
    List<Message> requestMessages = List.from(messages);
    // 根据是否开启了图片生成对话来执行
    if (!isImageChat) {
      await streamChat(
          messages: requestMessages,
          model: chatModel,
          temperature: temperature,
          topP: topP,
          presencePenalty: presencePenalty,
          frequencyPenalty: frequencyPenalty,
          onDone: onDone,
          resultBack: resultBack);
    } else {
      // 获取用户问题
      int len = requestMessages.length - 1;
      var prompt = "";
      while (len >= 0) {
        if (requestMessages[len].role == OpenAIChatMessageRole.user) {
          prompt = requestMessages[len].content;
          break;
        }
        len--;
      }
      // 判断结果
      bool judgeResult = await judgeDraw(chatModel, prompt);
      log(
        "画图判断：$prompt，判断结果:$judgeResult",
      );

      if (judgeResult) {
        resultBack("图片生成中...");
        var image = await generateImage(imageModel, prompt);
        if (image.startsWith("ERR")) {
          resultBack(image);
          return;
        }
        log(image);

        String response = "### 图片生成成功\n\n![$prompt]($image)\n\n- 图片地址:[$image]($image)";
        resultBack(response);

      } else {
        await streamChat(
            messages: requestMessages,
            model: chatModel,
            temperature: temperature,
            topP: topP,
            presencePenalty: presencePenalty,
            frequencyPenalty: frequencyPenalty,
            onDone: onDone,
            resultBack: resultBack);
      }
    }
  }

  // 对话
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
    log("请求列表：${chatMessages.toString()}");
    try {
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
          if (!completer.isCompleted) {
            completer.complete(true);
            assistantMessage = "";
          }
        }
      }, onDone: () {
        onDone();
        if (!completer.isCompleted) {
          completer.complete(true);
          assistantMessage = "";
        }
      }, onError: (err) {
        resultBack(err.toString());
        if (!completer.isCompleted) {
          completer.complete(true);
          assistantMessage = "";
        }
      });
      await completer.future;
    } catch (e) {
      resultBack(e.toString());
      return;
    }
  }

  // 绘图
  Future<String> generateImage(String model, String prompt) async {
    log(model);
    try {
      var imageResponse = await OpenAI.instance.image.create(
          prompt: prompt,
          model: model,
          n: 1,
          size: OpenAIImageSize.size1024,
          responseFormat: OpenAIImageResponseFormat.url);
      log(imageResponse.toString());
      var image = imageResponse.data.first.url;
      if (image != null) {
        return image;
      }
      return "ERR:${imageResponse.toString()}";
    } catch (e) {
      return "ERR:${e.toString()}";
    }
  }

  // 画图判断
  Future<bool> judgeDraw(String model, String prompt) async {
    final judgeDrawPrompt =
        """Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.""";
    var message = OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              judgeDrawPrompt)
        ]);
    var judgeResponse =
        await OpenAI.instance.chat.create(model: model, messages: [message]);
    var judgeResult = judgeResponse.choices.first.message.content?.first.text;
    switch (judgeResult?.toLowerCase()) {
      case "yes":
        return true;
      case "yes.":
        return true;
    }
    return false;
  }

  // 将Message List转换
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
