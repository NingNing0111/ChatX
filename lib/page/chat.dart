import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/component/chat_home.dart';
import 'package:chat_all/component/md_code_highlight_math.dart';
import 'package:chat_all/controller/chat.dart';
import 'package:chat_all/controller/setting.dart';
import 'package:chat_all/model/message.dart';
import 'package:chat_all/page/sidebar.dart';
import 'package:chat_all/service/assets.dart';
import 'package:chat_all/service/openai.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/sidebar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _chatController = Get.find<ChatPageController>();
  final _settingController = Get.find<SettingPageController>();
  final _sidebarController = Get.find<SidebarPageController>();
  final _chatService = OpenAIService();
  final _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final isWaiting = false.obs;

  @override
  void initState() {
    super.initState();
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
          builder: (context) => _chatController.currHistoryMessage.messages.isEmpty
              ? ChatHome(
                  sendMessage: sendMessage,
                )
              : ListView.builder(
                  controller: _scrollController,
                  itemCount: _chatController.currHistoryMessage.messages.length,
                  itemBuilder: (context, index) {
                    final currMessage =
                        _chatController.currHistoryMessage.messages[index];
                    return Column(
                      crossAxisAlignment:
                          OpenAIChatMessageRole.user == currMessage.role
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          child: Row(
                            mainAxisAlignment:
                                OpenAIChatMessageRole.user == currMessage.role
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                OpenAIChatMessageRole.user == currMessage.role
                                    ? AssetsManage.userIcon
                                    : AssetsManage.robotIcon,
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                currMessage.role.name.toUpperCase(),
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .titleLarge,
                              )
                            ],
                          ),
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
                                child: currMessage.content.isEmpty
                                    ? const CircularProgressIndicator(
                                        backgroundColor: Colors.blue,
                                      )
                                    : MdCodeMath(currMessage.content),
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
                suffixIcon: Obx(() => isWaiting.value
                    ? const CircularProgressIndicator(color: Colors.blue,)
                    : GestureDetector(
                        onTap: () async {
                          final userInputText = _textEditingController.text;
                          if(userInputText.isEmpty){
                            return;
                          }
                          isWaiting(true);
                          _textEditingController.clear();

                          await sendMessage(userInputText);
                          isWaiting(false);
                        },
                        child: const Icon(
                          Icons.send,
                          size: 30,
                        )))),
          ),
        ));
  }

  Future<void> sendMessage(String prompt) async {
    if (_chatController.currHistoryMessage.messages.isEmpty) {
      _chatController.currHistoryMessage.title = prompt;
      _sidebarController.updateHistory(_chatController.currHistoryMessage);
    }

    _chatController.addMessage(Message(
        content: prompt,
        role: OpenAIChatMessageRole.user,
        historyId: _chatController.currHistoryMessage.id));

    _chatController.addMessage(Message(
        content: "",
        role: OpenAIChatMessageRole.assistant,
        historyId: _chatController.currHistoryMessage.id));
    _chatService.init(
        api: _settingController.api.value, key: _settingController.key.value);
    // 获取对话Message
    final chatMessage = getChatMessageByLen();
    await _chatService.streamChat(
        messages: chatMessage,
        model: _settingController.chatModel.value,
        temperature: _settingController.temperature.value,
        topP: _settingController.topP.value,
        presencePenalty: _settingController.presencePenalty.value,
        frequencyPenalty: _settingController.frequencyPenalty.value,
        onDone: () {
          _sidebarController.saveAll();
        },
        resultBack: (event) {
          _chatController.updateMessageContent(
              _chatController.currHistoryMessage.messages.length - 1, event);
          updateToBottom();
        }); //
  }

  void updateToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  List<Message> getChatMessageByLen() {
    // message 列表
    final chatMessage = _chatController.currHistoryMessage.messages;
    // 长度、最大长度
    final len = chatMessage.length;
    final maxLen = _settingController.historyLength.value;
    if (len > maxLen) {
      return chatMessage.sublist(len - maxLen);
    }
    return chatMessage;
  }
}
