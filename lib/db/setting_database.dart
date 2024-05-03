import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/db/boxes.dart';
import 'package:get/get.dart';

class SettingDatabase {

  // 单例对象
  static final SettingDatabase _instance = SettingDatabase._internal();

  // 私有构造函数
  SettingDatabase._internal();

  // 工厂构造函数，用于返回单例对象
  factory SettingDatabase() {
    return _instance;
  }

  // 保存主题
  void saveThemeMode(AdaptiveThemeMode themeMode) {
    settingBox.put("key_setting_themeMode", themeMode.modeName);
  }

  // 获取主题
  AdaptiveThemeMode getThemeMode(){
    var modeName = settingBox.get("key_setting_themeMode");
    switch(modeName){
      case "System": return AdaptiveThemeMode.system;
      case "Light": return AdaptiveThemeMode.light;
      case "Dark": return AdaptiveThemeMode.dark;
    }
    return AdaptiveThemeMode.system;
  }

  // 保存语言配置
  void saveLanguage(Locale locale){
    var languageTag = locale.toLanguageTag();
    settingBox.put("key_setting_language", languageTag);
  }

  // 获取语言配置
  Locale? getLanguage(){
    var languageTag = settingBox.get("key_setting_language");
    if (languageTag != null && languageTag.isNotEmpty) {
      var tagList = languageTag.split("-");
      return Locale(tagList[0],tagList[1]);
    }
    // 如果没有保存过语言配置，则
    return Get.deviceLocale;
  }

  // API和Key配置
  void saveApi(String api){
    settingBox.put("key_setting_api", api);
  }
  String? getApi(){
    return settingBox.get("key_setting_api");
  }

  void saveKey(String key){
    settingBox.put("key_setting_key", key);
  }
  String? getKey(){
    return settingBox.get("key_setting_key");
  }

  // 对话配置
  void saveChatModel(String chatModel){
    settingBox.put("key_setting_chatModel", chatModel);
  }
  String? getChatModel(){
    return settingBox.get("key_setting_chatModel");
  }

  void saveTemperature(double temperature){
    settingBox.put("key_setting_temperature", temperature);
  }
  double? getTemperature() {
    var temperature = settingBox.get("key_setting_temperature");
    return temperature == null ? null : double.parse(temperature.toString());
  }

  void savePresencePenalty(double presencePenalty){
    settingBox.put("key_setting_presencePenalty", presencePenalty);
  }
  double? getPresencePenalty(){
    var presencePenalty  = settingBox.get("key_setting_presencePenalty");
    return presencePenalty == null ? null : double.parse(presencePenalty.toString());
  }

  void saveFrequencyPenalty(double frequencyPenalty){
    settingBox.put("key_setting_frequencyPenalty", frequencyPenalty);
  }
  double? getFrequencyPenalty(){
    var frequencyPenalty = settingBox.get("key_setting_frequencyPenalty");
    return frequencyPenalty == null ? null : double.parse(frequencyPenalty.toString());
  }

  void saveHistoryLength(int historyLength){
    settingBox.put("key_setting_historyLength", historyLength);
  }
  int? getHistoryLength(){
    var historyLength = settingBox.get("key_setting_historyLength");
    return historyLength == null ? null : int.parse(historyLength.toString());
  }

  void saveDisabledSystemPrompt(bool disabledSystemPrompt){
    settingBox.put("key_setting_disabledSystemPrompt", disabledSystemPrompt);
  }

  bool? getDisabledSystemPrompt() {
    return settingBox.get("key_setting_disabledSystemPrompt");
  }

  void saveTopP(double topP){
    settingBox.put("key_setting_topP", topP);
  }
  double? getTopP(){
    var topP = settingBox.get("key_setting_topP");
    return topP == null ? null : double.parse(topP.toString());
  }

}