import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  final int contentSelectedTab;
  final dynamic userSettings; // 請根據你的定義替換型別

  const ChatView({
    Key? key,
    required this.contentSelectedTab,
    required this.userSettings,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ChatView\ncontentSelectedTab: $contentSelectedTab'),
      ),
    );
  }
}
