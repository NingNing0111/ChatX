import 'package:get/get.dart';

class MessageRecord extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      "title": "Chat All",
      "setting_title": "设置中心",
      "basic_setting": "基础设置",
      "basic_setting_theme": "主题",
      "basic_setting_theme_system": "跟随系统",
      "basic_setting_theme_light": "白天模式",
      "basic_setting_theme_dark": "黑夜模式",
      "basic_setting_language": "语言",
      "api_setting": "接口设置",
      "chat_setting": "对话设置",
      "chat_setting_model": "模型",
      "chat_setting_temperature": "随机性",
      "chat_setting_top_p": "核采样",
      "chat_setting_presence_penalty": "话题新鲜度",
      "chat_setting_frequency_penalty": "频率惩罚",
      "chat_setting_history_length": "携带的历史消息数",
      "chat_setting_disabled_system_prompt": "开启系统词注入",
      "chat_other_reset_setting": "重置配置",
      "chat_other_clear_history": "清空对话",
      "chat_page_title": "聊天对话",
      "chat_page_input_hint": "请输入内容以发起对话"
    },
    'en_US': {
      "title": "Chat All",
      "setting_title": "Settings Center",
      "basic_setting": "Basic Settings",
      "basic_setting_theme": "Theme",
      "basic_setting_theme_system": "Auto",
      "basic_setting_theme_light": "Light",
      "basic_setting_theme_dark": "Dark",
      "basic_setting_language": "Language",
      "api_setting": "API Settings",
      "chat_setting": "Chat Settings",
      "chat_setting_model": "Model",
      "chat_setting_temperature": "temperature",
      "chat_setting_top_p": "top_p",
      "chat_setting_presence_penalty": "Presence Penalty",
      "chat_setting_frequency_penalty": "Frequency Penalty",
      "chat_setting_history_length": "History Length",
      "chat_setting_disabled_system_prompt": "Disabled System Prompt",
      "chat_other_reset_setting": "Reset Settings",
      "chat_other_clear_history": "Clear History",
      "chat_page_title": "Chat Conversation",
      "chat_page_input_hint": "Please enter to start a conversation"
    }
  };

}