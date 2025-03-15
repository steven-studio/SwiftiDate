import 'package:flutter/material.dart';

class SocialTrainingView extends StatelessWidget {
  const SocialTrainingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Social Training"),
      ),
      body: const Center(
        child: Text("Social Training View"),
      ),
    );
  }
}
