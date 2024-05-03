import 'package:chat_all/config/theme/theme.dart';
import 'package:chat_all/controller/chat.dart';
import 'package:chat_all/controller/setting.dart';
import 'package:chat_all/controller/sidebar.dart';
import 'package:chat_all/db/boxes.dart';
import 'package:chat_all/i18n/record.dart';
import 'package:chat_all/model/message.dart';
import 'package:chat_all/page/chat.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/router/router.dart';

void main() async {

  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(HistoryMessageAdapter());
  historyBox = await Hive.openBox("historyBox");
  settingBox = await Hive.openBox("settingBox");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatPageController());
    Get.lazyPut(() => SettingPageController());
    Get.lazyPut(() => SidebarPageController());


    return AdaptiveTheme(
        light: AppTheme.light,
        dark: AppTheme.dark,
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => GetMaterialApp(
          locale: Get.deviceLocale,
            translations: MessageRecord(),
            fallbackLocale: const Locale("en", "US"),
            title: 'Chat All AI',
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: darkTheme,
            initialRoute: "/",
            getPages: routers,
            unknownRoute: routers.last,
            defaultTransition: Transition.rightToLeft,
            home: const ChatPage()));
  }
}
