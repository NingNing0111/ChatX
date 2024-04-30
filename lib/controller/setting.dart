
import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:get/get.dart';

class SettingPageController  extends  GetxController {
  // 主题
  final themeMode = AdaptiveThemeMode.system.obs;
  // 语言
  final language = Get.deviceLocale.obs;
  // 对话配置
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

  void reset() {
    temperature.value = 0.5;
    presencePenalty.value = 0.0;
    frequencyPenalty.value = 0.0;
    historyLength.value = 16;
    disabledSystemPrompt(true);
    topP.value = 0.5;
    update();
  }

  @override
  void onClose() {
    // 配置存储到数据库中

  }
}

class SettingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingPageController());
  }

}