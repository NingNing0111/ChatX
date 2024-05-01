import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/component/chat_home.dart';
import 'package:chat_all/component/md_code_highlight_math.dart';
import 'package:chat_all/controller/chat.dart';
import 'package:chat_all/controller/setting.dart';
import 'package:chat_all/model/message.dart';
import 'package:chat_all/page/sidebar.dart';
import 'package:chat_all/service/openai.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatController = Get.find<ChatPageController>();
  final _settingController = Get.find<SettingPageController>();
  final _textEditingController = TextEditingController();
  final _chatService = OpenAIService();

  @override
  void initState() {
    super.initState();
    _chatService.init(
        api: _settingController.api.value, key: _settingController.key.value);
    sendMessage("hi");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AdaptiveTheme.of(context).theme.primaryColor,
          title: Text("chat_page_title".tr),
          centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Get.toNamed("/setting");
                },
                child: const Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
            ),
          ],
          leading: Builder(
            builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu,
                    size: 30,
                  ));
            },
          ),
        ),
        drawer: const SidebarPage(),
        body: GetBuilder<ChatPageController>(
          builder: (context) => _chatController.historyMessages.messages.isEmpty
              ? ChatHome(
                  sendMessage: sendMessage,
                )
              : ListView.builder(
                  itemCount: _chatController.historyMessages.messages.length,
                  itemBuilder: (context, index) {
                    final currMessage =
                        _chatController.historyMessages.messages[index];
                    return Column(
                      crossAxisAlignment:
                          OpenAIChatMessageRole.user == currMessage.role
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              OpenAIChatMessageRole.user == currMessage.role
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Icon(OpenAIChatMessageRole.user == currMessage.role
                                ? Icons.person
                                : Icons.ac_unit),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(currMessage.role.name)
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          mainAxisAlignment:
                              OpenAIChatMessageRole.user == currMessage.role
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Card(
                              shadowColor:
                                  AdaptiveTheme.of(context).theme.cardColor,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 20),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 1, bottom: 1, left: 4, right: 4),
                                child: MdCodeMath(currMessage.content),
                              ),
                            ))
                          ],
                        )
                      ],
                    );
                  }),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          padding: MediaQuery.of(context).viewInsets,
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                fillColor: AdaptiveTheme.of(context).theme.hoverColor,
                filled: true,
                hintText: "chat_page_input_hint".tr,
                suffixIcon: GestureDetector(
                    onTap: () async {
                      final userInputText = _textEditingController.text;
                      _textEditingController.clear();
                      await sendMessage(userInputText);
                    },
                    child: const Icon(
                      Icons.send,
                      size: 30,
                    ))),
          ),
        ));
  }

  Future<void> sendMessage(String prompt) async {
    _chatController.addMessage(Message(
        content: prompt,
        role: OpenAIChatMessageRole.user,
        historyId: _chatController.historyMessages.id));
    _chatController.addMessage(Message(
        content: "",
        role: OpenAIChatMessageRole.assistant,
        historyId: _chatController.historyMessages.id));
    _chatService.streamChat(
      messages: _chatController.historyMessages.messages,
      model: _settingController.chatModel.value,
      temperature: _settingController.temperature.value,
      topP: _settingController.topP.value,
      presencePenalty: _settingController.presencePenalty.value,
      frequencyPenalty: _settingController.frequencyPenalty.value,
      resultBack: onData,
      onDone: onDone,
    );
  }

  void onData(event) async {
    _chatController.updateMessageContent(
        _chatController.historyMessages.messages.length - 1, event);
  }

  void onDone() {
    print("done");
  }
}
