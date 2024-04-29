
import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:get/get.dart';

class SettingPageController  extends  GetxController {
  // 主题
  final themeMode = AdaptiveThemeMode.system.obs;
  // 语言
  final language = Get.deviceLocale.obs;
  final temperature = 0.5.obs;
  final presencePenalty = 0.0.obs;
  final frequencyPenalty = 0.0.obs;
  final historyLength = 16.obs;
  final disabledSystemPrompt = true.obs;
  final topP = 0.5.obs;


  void setLanguage(Locale locale){
    language.value = locale;
    Get.updateLocale(locale);
  }

}

class SettingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingPageController());
  }

}