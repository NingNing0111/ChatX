import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/component/role_home.dart';
import 'package:chat_all/model/message.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat.dart';
import '../controller/sidebar.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<StatefulWidget> createState() => _RolesPageState();

}

class _RolesPageState extends State<RolesPage>{
  final _sidebarController = Get.find<SidebarPageController>();
  final _chatController = Get.find<ChatPageController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("角色列表"),
        centerTitle: true,
        backgroundColor: AdaptiveTheme.of(context).theme.primaryColor,
      ),
      body: RoleHome(setPrompt: setPrompt,),
    );
  }

  void setPrompt(String prompt){

    _sidebarController.newHistory();
    _chatController.reloadHistory();
    _chatController.currHistoryMessage.messages.add(
      Message(content: prompt, role: OpenAIChatMessageRole.system, historyId: _chatController.currHistoryMessage.id)
    );
    Get.toNamed("/chat");
  }

}