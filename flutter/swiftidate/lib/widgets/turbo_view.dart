import 'package:flutter/material.dart';

class TurboView extends StatelessWidget {
  final int contentSelectedTab;
  final int turboSelectedTab;
  final bool showBackButton;

  const TurboView({
    Key? key,
    required this.contentSelectedTab,
    required this.turboSelectedTab,
    required this.showBackButton,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'TurboView\ncontentSelectedTab: $contentSelectedTab\n'
          'turboSelectedTab: $turboSelectedTab\n'
          'showBackButton: $showBackButton',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
