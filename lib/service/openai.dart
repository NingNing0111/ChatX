import 'dart:async';
import 'dart:developer';

import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';

import '../model/message.dart';

class OpenAIService {

  void init({required String api, required String key}) {
    OpenAI.apiKey = key;
    OpenAI.baseUrl = api;
  }

  // 综合绘图+对话
  Future<void> chat(
      {required List<Message> messages,
      required String model,
      required String drawModel,
      required double temperature,
      required double topP,
      required double presencePenalty,
      required double frequencyPenalty,
      required Function onDone,
      Function? onError,
      required ValueChanged resultBack}) async {


    List<Message> requestMessages = List.from(messages);

    // 获取用户问题
    int len = requestMessages.length-1;

    var prompt = "";
    while(len >= 0){
      if(requestMessages[len].role == OpenAIChatMessageRole.user){
        prompt = requestMessages[len].content;
        break;
      }
      len--;
    }
    // 判断结果
    bool judgeResult = await judgeDraw(model, prompt);
    log("画图判断：$prompt，判断结果:$judgeResult",);

    if (judgeResult) {
      resultBack("图片生成中...");
      var imageUrl = await generateImage(drawModel, prompt);
      if(!imageUrl.startsWith("http")){
        resultBack(imageUrl);
        return;
      }
      log(imageUrl);// 小狗狗照片
      String response = "![]($imageUrl)";
      resultBack(response);
      // var promptTemplate =
      //     """
      //     我已经为你提供了图片信息：
      //     ---
      //     图片描述：$prompt
      //     图片地址：$imageUrl
      //     ---
      //     你可以使用MarkDown格式回复图片的URL，例如:![]($imageUrl)。
      //     注意，你的回复内容需要表现得天生就知道这些图片信息一样并且你需要保证图片能够根据Markdown语法正常渲染，例如你在给出图片时，需要换行。
      //     以下是你回复时的参考案例(图片描述：请给我一张小狗狗的图片，图片地址：https://img.example.com/dog.png)：
      //     -----
      //     小狗狗是人类的好朋友，并且非常可爱，我现在为你提供小狗狗的图片：
      //
      //     ![请给我一张小狗狗的图片](https://img.example.com/dog.png)
      //     -----
      //     你在给出图片前，需要对图片描述进行一些扩展说明并且一定不要把图片地址弄错，必须提供的地址保持一致。
      //     """;
      // print("图片地址：$imageUrl");
      // requestMessages.insert(requestMessages.length-2,Message(content: promptTemplate, role: OpenAIChatMessageRole.system, historyId: ""));
      // // 金发女郎的图片
      // await streamChat(
      //     messages: requestMessages,
      //     model: model,
      //     temperature: temperature,
      //     topP: topP,
      //     presencePenalty: presencePenalty,
      //     frequencyPenalty: frequencyPenalty,
      //     onDone: onDone,
      //     resultBack: resultBack);
    } else {
      await streamChat(
          messages: requestMessages,
          model: model,
          temperature: temperature,
          topP: topP,
          presencePenalty: presencePenalty,
          frequencyPenalty: frequencyPenalty,
          onDone: onDone,
          resultBack: resultBack);
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
  }

  // 绘图
  Future<String> generateImage(String model, String prompt) async {
    try {
      var imageResponse =
          await OpenAI.instance.image.create(prompt: prompt, model: model,n: 1,size: OpenAIImageSize.size1024,responseFormat: OpenAIImageResponseFormat.url);
      var imageUrl = imageResponse.data.first.url;
      if (imageUrl != null) {
        return imageUrl;
      }
      return imageResponse.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // 画图判断
  Future<bool> judgeDraw(String model, String prompt) async {
    final judgeDrawPrompt =
        """Does this message want to generate an AI picture, image, art or anything similar? $prompt . Simply answer with a yes or no.""";
    var message = OpenAIChatCompletionChoiceMessageModel(role: OpenAIChatMessageRole.user, content: [OpenAIChatCompletionChoiceMessageContentItemModel.text(judgeDrawPrompt)]);
    var judgeResponse = await OpenAI.instance.chat.create(model: model, messages: [message]);
    var judgeResult = judgeResponse.choices.first.message.content?.first.text;
    switch (judgeResult?.toLowerCase()) {
      case "yes":
        return true;
      case "yes.":
        return true;
    }
    return false;
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
