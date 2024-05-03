import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/controller/chat.dart';
import 'package:chat_all/controller/sidebar.dart';
import 'package:chat_all/service/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<StatefulWidget> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  final _sidebarPageController = Get.find<SidebarPageController>();
  final _chatController = Get.find<ChatPageController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: !AdaptiveTheme.of(context).mode.isDark
          ? const Color(0xffeaf7fe)
          : const Color(0xff1d262a),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _sidebarPageController.newHistory();
                _chatController.reloadHistory();
              },
              child: Container(
                  decoration: BoxDecoration(
                      // color: AdaptiveTheme.of(context).theme.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: const Color(0xff4691a8), width: 2)),
                  margin: const EdgeInsets.only(
                      top: 40, left: 10, right: 10, bottom: 20),
                  padding: const EdgeInsets.all(5),
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AssetsManage.openaiIcon,
                            width: 30,
                            height: 30,
                            color: !AdaptiveTheme.of(context).mode.isDark
                                ? Colors.black
                                : Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "default_history_chat_title".tr,
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleLarge,
                          )
                        ],
                      ),
                      const Icon(Icons.add_circle_outline)
                    ],
                  )),
            ),
            GetBuilder<SidebarPageController>(
              builder: (context) => Expanded(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  final len = _sidebarPageController.histories.length;
                  final currHistory =
                      _sidebarPageController.histories[len - index - 1];
                  return Container(
                    margin:
                    const EdgeInsets.only(left: 10, right: 10, top: 10),
                    padding: const EdgeInsets.all(5),
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: _sidebarPageController.choice.value == index
                            ? Border.all(
                            color: const Color(0xff4691a8), width: 2)
                            : Border.all(
                            color: const Color(0x304691a8), width: 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: GestureDetector(
                                onTap: () {
                                  _chatController.setHistory(currHistory);
                                  _sidebarPageController.setChoice(index);
                                },
                                child: Text(
                                  currHistory.title,
                                  style: AdaptiveTheme.of(context)
                                      .theme
                                      .textTheme
                                      .titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _sidebarPageController
                                      .deleteHistory(len - index - 1);
                                  _chatController.setHistory(
                                      _sidebarPageController
                                          .histories.last);
                                  _sidebarPageController.setChoice(0);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 30,
                                ))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${currHistory.messages.length} 条对话",
                              style: AdaptiveTheme.of(context)
                                  .theme
                                  .textTheme
                                  .titleMedium,
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd HH:mm:ss')
                                  .format(currHistory.createTime),
                              style: AdaptiveTheme.of(context)
                                  .theme
                                  .textTheme
                                  .titleMedium,
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: _sidebarPageController.histories.length,
              )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.toNamed("/setting");
                      },
                      icon: const Icon(
                        Icons.settings,
                        size: 30,
                      ))
                ],
              ),
            )
          ]),
    );
  }
}
