import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(

        body: Center(

          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("未知页面")
              ]
          ),
        )
    );
  }

}