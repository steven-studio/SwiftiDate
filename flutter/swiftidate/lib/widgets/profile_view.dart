import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final int contentSelectedTab;

  const ProfileView({Key? key, required this.contentSelectedTab}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ProfileView\ncontentSelectedTab: $contentSelectedTab'),
      ),
    );
  }
}
