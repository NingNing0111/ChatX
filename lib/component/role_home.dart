
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:chat_all/config/prompts.dart';
import 'package:flutter/material.dart';

class RoleHome extends StatelessWidget {
  final Function(String prompt) setPrompt;
  const RoleHome({super.key,required this.setPrompt});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemBuilder: (context, index) => GestureDetector(
        onTap: (){
          setPrompt(promptsCN[index]['prompt']!);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey),
          ),
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Row(
            children: [
              emojis[index],
              const SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    child: Text(
                      promptsCN[index]["act"]!,
                      style: AdaptiveTheme.of(context).theme.textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Text("你好")
                  SizedBox(
                      width: 260,
                      child: Text(
                        promptsCN[index]['prompt']!,
                        style:
                            AdaptiveTheme.of(context).theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
      itemCount: promptsCN.length,
    );
  }
}
