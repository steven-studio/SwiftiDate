import 'dart:math';
import 'package:flutter/material.dart';

class AstrologyView extends StatelessWidget {
  const AstrologyView({Key? key}) : super(key: key);

  // 定義所有星座
  final List<String> zodiacSigns = const [
    "♈️ 牡羊座",
    "♉️ 金牛座",
    "♊️ 雙子座",
    "♋️ 巨蟹座",
    "♌️ 獅子座",
    "♍️ 處女座",
    "♎️ 天秤座",
    "♏️ 天蠍座",
    "♐️ 射手座",
    "♑️ 摩羯座",
    "♒️ 水瓶座",
    "♓️ 雙魚座",
  ];

  // 隨機產生幸運指數，介於 50% ~ 100%
  int getRandomLuck() {
    return 50 + Random().nextInt(51);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("星座占卜"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 標題
            Text(
              "🔮 今日星座運勢",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // 依序顯示每個星座的運勢
            ...zodiacSigns.map((sign) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sign,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.purple),
                      ),
                      const SizedBox(height: 5),
                      Text("✨ 今日幸運指數：${getRandomLuck()}%"),
                      const SizedBox(height: 5),
                      const Text("💡 感情運：適合認識新朋友，試著打開心扉！"),
                      const SizedBox(height: 5),
                      const Text("🎭 事業運：適合嘗試新的挑戰，今天充滿機會！"),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}