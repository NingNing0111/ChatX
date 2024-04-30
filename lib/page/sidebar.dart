import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/service/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SidebarPage extends StatefulWidget {
  const SidebarPage({super.key});

  @override
  State<StatefulWidget> createState() => _SidebarPageState();
}

class _SidebarPageState extends State<SidebarPage> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AdaptiveTheme.of(context).mode.isLight
          ? const Color(0xffeaf7fe)
          : const Color(0xff1d262a),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xff4691a8), width: 2)),
                margin: const EdgeInsets.only(
                    top: 40, left: 10, right: 10, bottom: 40),
                padding: const EdgeInsets.all(5),
                height: 50,
                child: GestureDetector(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetsManage.openaiIcon,
                          width: 30,
                          height: 30,
                          color: AdaptiveTheme.of(context).mode.isLight
                              ? Colors.black
                              : Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "开启新对话",
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleLarge,
                        )
                      ],
                    ),
                    const Icon(Icons.add_circle_outline)
                  ],
                ))),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 10,right: 10,top: 5),
                    padding: const EdgeInsets.all(5),
                    height: 80,
                    decoration: BoxDecoration(
                        // color: Colors.pink,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xff4691a8), width: 2)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("新的对话",style: AdaptiveTheme.of(context).theme.textTheme.titleLarge,),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("10 条对话",style: AdaptiveTheme.of(context).theme.textTheme.titleMedium,),
                          Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),style: AdaptiveTheme.of(context).theme.textTheme.titleMedium,)
                        ],
                      )
                    ],
                  ),
                  ),



                ],
              ),
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
