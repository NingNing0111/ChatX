import 'package:chat_all/controller/setting.dart';
import 'package:chat_all/page/chat.dart';
import 'package:chat_all/page/setting.dart';
import 'package:chat_all/page/unknow.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

final routers = [
  GetPage(name: "/", page: () => const ChatPage()),
  GetPage(name: "/chat", page: () => const ChatPage()),
  GetPage(
      name: "/setting",
      page: () => const SettingPage(),
      binding: SettingControllerBinding()),
  GetPage(name: "/unknown", page: () => const UnknownPage())
];
