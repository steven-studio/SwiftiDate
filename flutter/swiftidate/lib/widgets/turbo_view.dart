import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../analytics/analytics_manager.dart';
import '../providers/user_settings.dart';

/// FeaturedCardView 的占位元件
class FeaturedCardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.blue[100],
      alignment: Alignment.center,
      child: Text("每日精選", style: TextStyle(fontSize: 20)),
    );
  }
}

/// TurboView Flutter 版
class TurboView extends StatefulWidget {
  /// 這裡模擬了兩個外部可修改的 Tab 狀態
  final int contentSelectedTab;
  final int turboSelectedTab;
  final bool showBackButton;
  final VoidCallback? onBack;
  final ValueChanged<int>? onContentTabChange;
  final ValueChanged<int>? onTurboTabChange;

  const TurboView({
    Key? key,
    required this.contentSelectedTab,
    required this.turboSelectedTab,
    this.showBackButton = false,
    this.onBack,
    this.onContentTabChange,
    this.onTurboTabChange,
  }) : super(key: key);

  @override
  _TurboViewState createState() => _TurboViewState();
}

class _TurboViewState extends State<TurboView> {
  late int _turboSelectedTab;
  late int _contentSelectedTab;
  bool _showConfirmationPopup = false;

  @override
  void initState() {
    super.initState();
    _turboSelectedTab = widget.turboSelectedTab;
    _contentSelectedTab = widget.contentSelectedTab;
  }

  void _updateTurboTab(int index) {
    setState(() {
      _turboSelectedTab = index;
    });
    AnalyticsManager.shared.trackEvent("turbo_tab_changed", parameters: {
      "tab": index == 0 ? "喜歡我的人" : "我的心動對象"
    });
    if (widget.onTurboTabChange != null) {
      widget.onTurboTabChange!(index);
    }
  }

  void _triggerTurboAction(UserSettings userSettings) {
    if (userSettings.globalTurboCount > 0) {
      AnalyticsManager.shared.trackEvent("turbo_start_button_pressed", parameters: {
        "globalTurboCount": userSettings.globalTurboCount
      });
      setState(() {
        _showConfirmationPopup = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // 主內容區
          Column(
            children: [
              // 自訂的導航列與頂部 Tab
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
                child: Stack(
                  children: [
                    // 返回按鈕
                    if (widget.showBackButton)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: Icon(Icons.chevron_left, color: Colors.grey),
                          onPressed: () {
                            AnalyticsManager.shared
                                .trackEvent("turbo_view_back_pressed");
                            if (widget.onBack != null) widget.onBack!();
                          },
                        ),
                      ),
                    // 中間的 Tab 按鈕
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => _updateTurboTab(0),
                            child: Text(
                              "喜歡我的人",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: _turboSelectedTab == 0
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () => _updateTurboTab(1),
                            child: Text(
                              "我的心動對象",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: _turboSelectedTab == 1
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 選中的指示線
              Stack(
                children: [
                  Container(
                    width: screenWidth,
                    height: 2,
                    color: Colors.grey[300],
                  ),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    left: _turboSelectedTab == 0 ? 0 : screenWidth / 2,
                    child: Container(
                      width: screenWidth / 2,
                      height: 2,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // 根據選擇的 Tab 顯示不同內容
              Expanded(
                child: _turboSelectedTab == 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            // 每日精選卡片
                            FeaturedCardView(),
                            SizedBox(height: 20),
                            // 主圖像
                            Container(
                              height: 250,
                              child: Image.asset(
                                'assets/turbo_view_image.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 20),
                            // 描述文字
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                "開啟Turbo，將你直接置頂到所有人的前面！輕鬆提升10倍配對成功率",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // 動作按鈕：馬上開始
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60.0),
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.bolt),
                                label: Text(
                                  "馬上開始",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink, // 使用漸層可用 Container 包覆
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () => _triggerTurboAction(userSettings),
                              ),
                            ),
                            SizedBox(height: 40),
                            // 底部的圖標按鈕
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 20.0, bottom: 20.0),
                                child: IconButton(
                                  iconSize: 40,
                                  icon: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Colors.pink, Colors.purple],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 5,
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.bolt,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _triggerTurboAction(userSettings),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : // 第二個分頁
                    userSettings.globalLikeCount == 0
                        ? Column(
                            children: [
                              Spacer(),
                              Icon(
                                Icons.all_inbox, // 你可以改成其他圖示或自訂圖片
                                size: 100,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "你還沒有送出喜歡，快去滑動吧",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 16),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    AnalyticsManager.shared.trackEvent(
                                        "turbo_go_to_swipe_pressed");
                                    if (widget.onBack != null) widget.onBack!();
                                    // 通知父層切換 ContentView 的 tab
                                    if (widget.onContentTabChange != null)
                                      widget.onContentTabChange!(0);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    "去滑卡",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          )
                        : Container(),
              ),
            ],
          ),
          // 確認彈跳視窗 overlay
          if (_showConfirmationPopup)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 個人頭像，可用 CircleAvatar
                        CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              AssetImage('assets/photo1.png'), // 替換為實際圖片
                        ),
                        SizedBox(height: 20),
                        Text(
                          "確認要立即使用Turbo嗎？",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        // 確認使用按鈕
                        ElevatedButton(
                          onPressed: () {
                            AnalyticsManager.shared.trackEvent(
                                "turbo_confirmation_accepted",
                                parameters: {
                                  "globalTurboCount": userSettings.globalTurboCount
                                });
                            setState(() {
                              _showConfirmationPopup = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              "確認使用",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // 取消按鈕
                        TextButton(
                          onPressed: () {
                            AnalyticsManager.shared
                                .trackEvent("turbo_confirmation_cancelled");
                            setState(() {
                              _showConfirmationPopup = false;
                            });
                          },
                          child: Text(
                            "取消",
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}