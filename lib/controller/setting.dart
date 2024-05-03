
import 'dart:developer';
import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/db/setting_database.dart';
import 'package:get/get.dart';

class SettingPageController  extends  GetxController {
  // 主题
  final themeMode = AdaptiveThemeMode.system.obs;
  // 语言
  final language = Get.deviceLocale.obs;
  // api设置
  final api = "https://api.openai.com".obs;
  final key = "".obs;
  // 对话配置
  final chatModel = "gpt-3.5-turbo".obs;
  final drawModel = "dall-e-2".obs;
  final temperature = 0.5.obs;
  final presencePenalty = 0.0.obs;
  final frequencyPenalty = 0.0.obs;
  final historyLength = 16.obs;
  final disabledSystemPrompt = true.obs;
  final topP = 0.5.obs;

  final db = SettingDatabase();

  @override
  void onInit() {
    themeMode.value = db.getThemeMode();
    language.value = db.getLanguage();
    api.value = db.getApi()??api.value;
    key.value = db.getKey()??key.value;
    chatModel.value = db.getChatModel()??chatModel.value;
    temperature.value = db.getTemperature()??temperature.value;
    presencePenalty.value = db.getPresencePenalty()??presencePenalty.value;
    frequencyPenalty.value = db.getFrequencyPenalty()??frequencyPenalty.value;
    historyLength.value = db.getHistoryLength()??historyLength.value;
    disabledSystemPrompt.value = db.getDisabledSystemPrompt()??disabledSystemPrompt.value;
    topP.value = db.getTopP()??topP.value;
    setLanguage(language.value!);
    super.onInit();
  }

  void setLanguage(Locale locale){
    language.value = locale;
    Get.updateLocale(locale);
    update();
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
    super.onClose();
    saveSettingInfo();
  }

  void saveSettingInfo(){
    db.saveThemeMode(themeMode.value);
    db.saveLanguage(language.value!);
    db.saveApi(api.value);
    db.saveKey(key.value);
    db.saveChatModel(chatModel.value);
    db.saveTemperature(temperature.value);
    db.savePresencePenalty(presencePenalty.value);
    db.saveFrequencyPenalty(frequencyPenalty.value);
    db.saveHistoryLength(historyLength.value);
    db.saveDisabledSystemPrompt(disabledSystemPrompt.value);
    db.saveTopP(topP.value);
    log("配置信息存储完成");
  }
}

class SettingControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingPageController());
  }

}