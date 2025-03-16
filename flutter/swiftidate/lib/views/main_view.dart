import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../providers/user_settings.dart';
import '../providers/consumable_store.dart';
import '../widgets/swipe_card_view.dart';
import '../widgets/turbo_view.dart';
import '../widgets/user_guide_view.dart';
import '../widgets/astrology_view.dart';
import '../widgets/chat_view.dart';
import '../widgets/profile_view.dart';
import '../analytics/analytics_manager.dart';
// import 'tab_state_machine_manager.dart'; // 假設你有這個類別
import '../utils/tab_event.dart'; // 假設定義了 TabEvent, 如：selectSwipe, selectTurbo, selectGuide, selectAstrology, selectChat, selectProfile

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  // 用於記錄目前選取的分頁
  int selectedTab = 0;
  // 如果 TurboView 有特別需求的分頁狀態，可用 selectedTurboTab 保存
  int selectedTurboTab = 0;
  
  // 用來計算狀態機事件觸發次數，供 debug 用
  int varOcg = 0;
  
  // 狀態機管理器
  // late TabStateMachineManager tabStateMachineManager;

  @override
  void initState() {
    super.initState();
    // tabStateMachineManager = TabStateMachineManager();
  }

  // 狀態機事件觸發函式
  void triggerTabEvent(TabEvent event) {
    setState(() {
      varOcg++;
    });
    print("[DEBUG] Triggering event: $event - varOcg=$varOcg");
    // try {
    //   tabStateMachineManager.stateMachine.transition(event);
    //   print("[DEBUG] New state: ${tabStateMachineManager.stateMachine.state}");
    // } catch (error) {
    //   print("[ERROR] Transition failed for event $event: $error");
    // }
  }

  // 當下方導覽列選擇改變時呼叫
  void onTabChanged(int newIndex) {
    setState(() {
      selectedTab = newIndex;
    });
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    late TabEvent newEvent;
    switch (newIndex) {
      case 0:
        newEvent = TabEvent.selectSwipe;
        break;
      case 1:
        newEvent = TabEvent.selectTurbo;
        break;
      case 2:
        // 根據性別決定事件
        newEvent = (userSettings.globalUserGender == Gender.male)
            ? TabEvent.selectGuide
            : TabEvent.selectAstrology;
        break;
      case 3:
        newEvent = TabEvent.selectChat;
        break;
      case 4:
        newEvent = TabEvent.selectProfile;
        break;
      default:
        newEvent = TabEvent.selectSwipe;
    }
    triggerTabEvent(newEvent);
    AnalyticsManager.shared.trackEvent("tab_switched", parameters: {
      "new_tab_index": newIndex,
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context);
    
    // 動態定義導覽列中第三個 tab 的 label 根據性別決定
    final String guideLabel = userSettings.globalUserGender == Gender.male ? "Guide" : "Astrology";

    // 定義各個分頁對應的 Widget，這裡直接引用各自實作的 widget
    final List<Widget> pages = [
      SwipeCardView(), // tab index 0
      TurboView(
        // 傳遞必要的參數，這裡簡化為傳遞當前選取值
        contentSelectedTab: selectedTab,
        turboSelectedTab: selectedTurboTab,
        showBackButton: false,
      ), // tab index 1
      // tab index 2 根據性別選擇不同的頁面
      userSettings.globalUserGender == Gender.male 
          ? const UserGuideView() 
          : const AstrologyView(),
      ChatView(
        contentSelectedTab: selectedTab,
        userSettings: userSettings,
      ), // tab index 3
      // ProfileView 建議包裹在 Navigator 或直接作為一個頁面使用
      ProfileView(contentSelectedTab: selectedTab),
    ];

    // 動態生成 BottomNavigationBar 的 items
    final List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Swipe',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.star),
        label: 'Turbo',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.help_outline),
        label: guideLabel,
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: 'Chat',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
    
    return Scaffold(
      body: IndexedStack(
        index: selectedTab,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedTab,
        onTap: onTabChanged,
        items: items,
      ),
    );
  }
}
