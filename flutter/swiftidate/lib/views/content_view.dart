import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/user_settings.dart';
import '../providers/consumable_store.dart';
import '../views/main_view.dart';
import '../views/login_or_register_view.dart';
// import 'photo_utility.dart';
// import 'analytics_manager.dart';

class ContentView extends StatefulWidget {
  const ContentView({Key? key}) : super(key: key);

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  // 使用 _hasCalledOnAppear 確保 onAppear 邏輯只執行一次
  bool _hasCalledOnAppear = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCalledOnAppear) {
      _hasCalledOnAppear = true;
      final userSettings = Provider.of<UserSettings>(context, listen: false);
      // 模擬 onAppear 呼叫，載入圖片
      // PhotoUtility.loadPhotosFromAppStorage(userSettings);
      final appState = Provider.of<AppState>(context, listen: false);
      // if (appState.isLoggedIn) {
      //   AnalyticsManager.shared.trackEvent(
      //     "content_view_logged_in_appear",
      //     parameters: {"user_name": userSettings.globalUserName},
      //   );
      // } else {
      //   AnalyticsManager.shared.trackEvent("content_view_logged_out_appear");
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    appState.isLoggedIn = true;
    // 根據 appState 判斷是否登入，回傳相應的畫面
    if (appState.isLoggedIn) {
      return const MainView();
    } else {
      return const LoginOrRegisterView();
    }
  }
}
