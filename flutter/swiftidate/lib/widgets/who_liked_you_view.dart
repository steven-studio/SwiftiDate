// lib/widgets/who_liked_you_view.dart

import 'package:flutter/material.dart';
import '../analytics/analytics_manager.dart';

class WhoLikedYouView extends StatefulWidget {
  const WhoLikedYouView({Key? key}) : super(key: key);

  @override
  _WhoLikedYouViewState createState() => _WhoLikedYouViewState();
}

class _WhoLikedYouViewState extends State<WhoLikedYouView> {
  @override
  void initState() {
    super.initState();
    // 模擬 onAppear 事件追蹤
    AnalyticsManager.shared.trackEvent("who_liked_you_view_appear");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 68,
            height: 68,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 背景黃色圓形
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.yellow.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                // 中間的使用者圖示
                Center(
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
                // 外圍白色圓邊
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                ),
                // 右下角的心形圖示
                Positioned(
                  right: -4,
                  bottom: -4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.yellow,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 文字描述
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "看看誰喜歡你了！",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "立即探索",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          const Spacer(),
          // 查看按鈕
          TextButton(
            onPressed: () {
              AnalyticsManager.shared.trackEvent("who_liked_you_check_pressed");
              // 在這裡添加按鈕點擊後的具體操作
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.yellow,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              "查看",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}