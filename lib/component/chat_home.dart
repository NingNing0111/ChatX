import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/service/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatHome extends StatelessWidget {
  final Function(String text) sendMessage;

  const ChatHome({super.key, required this.sendMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AssetsManage.openaiIcon,
                width: 50,
                height: 50,
                color: AdaptiveTheme.of(context).mode.isLight
                    ? Colors.black
                    : Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "chat_page_home_center_title".tr,
                style: AdaptiveTheme.of(context).theme.textTheme.titleLarge,
              )
            ],
          )),
        ),
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  sendMessage("chat_page_home_tip_history_content".tr);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xffd9d9d9))

                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "chat_page_home_tip_history_title".tr,
                        style: AdaptiveTheme.of(context)
                            .theme
                            .textTheme
                            .titleLarge,
                      ),
                      Text(
                        "chat_page_home_tip_history_content".tr,
                        style: AdaptiveTheme.of(context)
                            .theme
                            .textTheme
                            .titleMedium,
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  sendMessage("chat_page_home_tip_tour_content".tr);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 370,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xffd9d9d9))
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "chat_page_home_tip_tour_title".tr,
                        style: AdaptiveTheme.of(context)
                            .theme
                            .textTheme
                            .titleLarge,
                      ),
                      Text(
                        "chat_page_home_tip_tour_content".tr,
                        style: AdaptiveTheme.of(context)
                            .theme
                            .textTheme
                            .titleMedium,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
