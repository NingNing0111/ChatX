import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/controller/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/chat.dart';
import '../controller/sidebar.dart';
import '../service/assets.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _settingController = Get.find<SettingPageController>();
  final _sidebarController = Get.find<SidebarPageController>();
  final _chatController = Get.find<ChatPageController>();

  final _apiInputController = TextEditingController();
  final _keyInputController = TextEditingController();
  final _showOpenAIKey = false.obs;

  @override
  void initState() {
    super.initState();
    _apiInputController.text = _settingController.api.value;
    _keyInputController.text = _settingController.key.value;
  }

  @override
  void dispose() {
    super.dispose();
    // 配置信息存储到数据库中
    _settingController.saveSettingInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AdaptiveTheme.of(context).theme.primaryColor,
          title: Text("setting_title".tr),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {
              Get.back(canPop: false);
            },
          ),
        ),
        body: ListView(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          children: [
            ///
            /// 基础设置：主题、语言
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "basic_setting".tr,
                  style: AdaptiveTheme.of(context).theme.textTheme.titleLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.home,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("basic_setting_theme".tr,
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleMedium)
                      ],
                    ),
                    Obx(() => DropdownButton(
                        padding: const EdgeInsets.all(5),
                        borderRadius: BorderRadius.circular(10),
                        value: _settingController.themeMode.value,
                        items: [
                          DropdownMenuItem<AdaptiveThemeMode>(
                            value: AdaptiveThemeMode.system,
                            child: Text("basic_setting_theme_system".tr),
                          ),
                          DropdownMenuItem<AdaptiveThemeMode>(
                            value: AdaptiveThemeMode.light,
                            child: Text("basic_setting_theme_light".tr),
                          ),
                          DropdownMenuItem<AdaptiveThemeMode>(
                            value: AdaptiveThemeMode.dark,
                            child: Text("basic_setting_theme_dark".tr),
                          )
                        ],
                        onChanged: (AdaptiveThemeMode? value) {
                          _settingController.themeMode.value = value!;
                          AdaptiveTheme.of(context).setThemeMode(value);
                        }))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.language,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "basic_setting_language".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => DropdownButton<Locale>(
                        padding: const EdgeInsets.all(5),
                        borderRadius: BorderRadius.circular(10),
                        value: _settingController.language.value,
                        items: const [
                          DropdownMenuItem<Locale>(
                            value: Locale("zh", "CN"),
                            child: Text("中文"),
                          ),
                          DropdownMenuItem<Locale>(
                            value: Locale("en", "US"),
                            child: Text("English"),
                          )
                        ],
                        onChanged: (Locale? value) {
                          _settingController.setLanguage(value!);
                        }))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),

            ///
            /// 接口设置：API、KEY
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "api_setting".tr,
                  style: AdaptiveTheme.of(context).theme.textTheme.titleLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.api,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "API",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 250,
                        child: TextField(
                          cursorColor: Colors.blue,
                          controller: _apiInputController,
                          onChanged: (String value) {
                            _settingController.api.value =
                                _apiInputController.text;
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "https://api.openai.com",
                          ),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.key,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Key",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 250,
                        child: Obx(() => TextField(
                              cursorColor: Colors.blue,
                              controller: _keyInputController,
                              onChanged: (String value) {
                                _settingController.key.value =
                                    _keyInputController.text;
                              },
                              obscureText: !_showOpenAIKey.value,
                              decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                hintText: "API Key",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      _showOpenAIKey.value =
                                          !_showOpenAIKey.value;
                                    },
                                    icon: Icon(_showOpenAIKey.value
                                        ? Icons.visibility
                                        : Icons.visibility_off)),
                              ),
                            )))
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),

            ///
            /// 对话设置：对话模型、图片模型、随机性、核采样、话题新鲜度、频率惩罚、是否注入系统提示词、附带的历史消息总数
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "chat_setting".tr,
                  style: AdaptiveTheme.of(context).theme.textTheme.titleLarge,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_chat_model".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    DropdownButton(
                        padding: const EdgeInsets.all(5),
                        borderRadius: BorderRadius.circular(10),
                        value: "gpt-3.5-turbo",
                        items: const [
                          DropdownMenuItem<String>(
                            value: "gpt-3.5-turbo",
                            child: Text("gpt-3.5-turbo"),
                          )
                        ],
                        onChanged: (String? value) {
                          _settingController.chatModel.value = value!;
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_image_model".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    DropdownButton(
                        padding: const EdgeInsets.all(5),
                        borderRadius: BorderRadius.circular(10),
                        value: "dall-e-2",
                        items: const [
                          DropdownMenuItem<String>(
                            value: "dall-e-2",
                            child: Text("dall-e-2"),
                          ),
                          DropdownMenuItem<String>(
                            value: "dall-e-3",
                            child: Text("dall-e-3"),
                          )
                        ],
                        onChanged: (String? value) {
                          _settingController.imageModel.value = value!;
                        })
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_temperature".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => SizedBox(
                          width: 170,
                          child: Slider(
                            value: _settingController.temperature.value,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: _settingController.temperature.value
                                .toStringAsFixed(1),
                            activeColor: Colors.blue,
                            // 设置活动部分的颜色
                            inactiveColor: Colors.grey,
                            // 设置非活动部分的颜色
                            // 设置刻度为10，对应0.0到1.0的范围
                            onChanged: (newValue) {
                              _settingController.temperature.value = newValue;
                            },
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_top_p".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => SizedBox(
                          width: 170,
                          child: Slider(
                            value: _settingController.topP.value,
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: _settingController.topP.value
                                .toStringAsFixed(1),
                            activeColor: Colors.blue,
                            // 设置活动部分的颜色
                            inactiveColor: Colors.grey,
                            // 设置非活动部分的颜色
                            // 设置刻度为10，对应0.0到1.0的范围
                            onChanged: (newValue) {
                              _settingController.topP.value = newValue;
                            },
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_presence_penalty".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => SizedBox(
                          width: 170,
                          child: Slider(
                            value: _settingController.presencePenalty.value,
                            min: -2.0,
                            max: 2.0,
                            divisions: 20,
                            label: _settingController.presencePenalty.value
                                .toStringAsFixed(1),
                            activeColor: Colors.blue,
                            // 设置活动部分的颜色
                            inactiveColor: Colors.grey,
                            // 设置非活动部分的颜色
                            // 设置刻度为10，对应0.0到1.0的范围
                            onChanged: (newValue) {
                              _settingController.presencePenalty.value =
                                  newValue;
                            },
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_frequency_penalty".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => SizedBox(
                          width: 170,
                          child: Slider(
                            value: _settingController.frequencyPenalty.value,
                            min: -2.0,
                            max: 2.0,
                            divisions: 20,
                            label: _settingController.frequencyPenalty.value
                                .toStringAsFixed(1),
                            activeColor: Colors.blue,
                            // 设置活动部分的颜色
                            inactiveColor: Colors.grey,
                            // 设置非活动部分的颜色
                            // 设置刻度为10，对应0.0到1.0的范围
                            onChanged: (newValue) {
                              _settingController.frequencyPenalty.value =
                                  newValue;
                            },
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_history_length".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => SizedBox(
                          width: 170,
                          child: Slider(
                            value: _settingController.historyLength.value
                                .toDouble(),
                            min: 0,
                            max: 32,
                            divisions: 32,
                            label: _settingController.historyLength.value
                                .toString(),
                            activeColor: Colors.blue,
                            // 设置活动部分的颜色
                            inactiveColor: Colors.grey,
                            // 设置非活动部分的颜色
                            // 设置刻度为10，对应0.0到1.0的范围
                            onChanged: (newValue) {
                              _settingController.historyLength.value =
                                  newValue.toInt();
                            },
                          ),
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_enabled_system_prompt".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => Switch(
                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.grey,
                        value: _settingController.enabledSystemPrompt.value,
                        onChanged: (value) {
                          _settingController.enabledSystemPrompt.value =
                              !_settingController.enabledSystemPrompt.value;
                        }))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 40,
                        ),
                        Text(
                          "chat_setting_enabled_image_chat".tr,
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium,
                        )
                      ],
                    ),
                    Obx(() => Switch(
                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.grey,
                        value: _settingController.enabledImageChat.value,
                        onChanged: (value) {
                          _settingController.enabledImageChat.value =
                              !_settingController.enabledImageChat.value;
                        }))
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),

            ///
            /// 其它操作
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      _settingController.reset();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AdaptiveTheme.of(context).theme.primaryColor),
                      child: Text("chat_other_reset_setting".tr,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    )),
                TextButton(
                    onPressed: () {
                      Get.defaultDialog(
                          title: "default_dialog_delete_title".tr,
                          textConfirm: "default_dialog_delete_text".tr,
                          confirmTextColor: Colors.red,
                          backgroundColor:
                              AdaptiveTheme.of(context).theme.primaryColor,
                          textCancel: "default_dialog_cancel_text".tr,
                          content: Text(
                            "default_dialog_delete_content".tr,
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleMedium,
                          ),
                          onConfirm: () {
                            _sidebarController.clearHistory();
                            _chatController.reloadHistory();
                            Get.back();
                          },
                          onCancel: () {});
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AdaptiveTheme.of(context).theme.primaryColor),
                      child: Text("chat_other_clear_history".tr,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ))
              ],
            )
          ],
        ));
  }
}
