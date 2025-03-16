import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/chat_view_model.dart'; // 請確保你的 ChatViewModel 放在 view_models 資料夾中
import '../analytics/analytics_manager.dart';
import 'chat_row.dart';
import 'who_liked_you_view.dart';

class ChatListContainerView extends StatefulWidget {
  final ChatViewModel viewModel;
  final bool showTurboView;
  final ValueChanged<bool>? onShowTurboViewChanged; // 當需要更新 showTurboView 時

  const ChatListContainerView({
    Key? key,
    required this.viewModel,
    required this.showTurboView,
    this.onShowTurboViewChanged,
  }) : super(key: key);

  @override
  _ChatListContainerViewState createState() => _ChatListContainerViewState();
}

class _ChatListContainerViewState extends State<ChatListContainerView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // 使用 PlainListStyle 的效果可用去掉分隔線，Flutter ListView 本身不會自動產生分隔線
      padding: EdgeInsets.zero,
      children: [
        // 新配對標題
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            "新配對",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // 配對用戶的水平滾動列表
        SizedBox(
          height: 100,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // "更多配對" 按鈕
                GestureDetector(
                  onTap: () {
                    AnalyticsManager.shared.trackEvent("more_matches_tapped");
                    // 更新 viewModel 中的狀態
                    setState(() {
                      widget.viewModel.showTurboPurchaseView = true;
                    });
                  },
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.purple.withOpacity(0.1),
                          ),
                          Positioned(
                            left: 18,
                            top: 18,
                            child: Icon(
                              Icons.bolt,
                              size: 24,
                              color: Colors.purple,
                            ),
                          ),
                          Positioned(
                            left: 43,
                            top: 43,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.purple,
                              ),
                              child: const Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "更多配對",
                        style: TextStyle(fontSize: 12, color: Colors.purple),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // 根據 searchField 狀態顯示不同的匹配資料
                if (widget.viewModel.showSearchField)
                  ...widget.viewModel.filteredMatches.map((user) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(user.imageName),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList()
                else
                  ...widget.viewModel.userMatches.map((user) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(user.imageName),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
        // "聊天" 標題
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(
            "聊天",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        // WhoLikedYouView 按鈕
        GestureDetector(
          onTap: () {
            AnalyticsManager.shared.trackEvent("who_liked_you_tapped");
            if (widget.onShowTurboViewChanged != null) {
              widget.onShowTurboViewChanged!(true);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: WhoLikedYouView(),
          ),
        ),
        // 聊天列表部分
        if (widget.viewModel.showSearchField)
          ...widget.viewModel.filteredChats.map((chat) {
            final messages = widget.viewModel.chatMessages[chat.id] ?? [];
            return ChatRow(
              chat: chat,
              messages: messages,
              onTap: () {
                // 這裡可以根據需求處理點擊事件
                print("Tapped on filtered chat: ${chat.name}");
              },
              onRename: () {
                // 修改備註的邏輯
              },
              onUnmatch: () {
                // 解除配對的邏輯
              },
            );
          }).toList()
        else
          ...widget.viewModel.chatData.map((chat) {
            final messages = widget.viewModel.chatMessages[chat.id] ?? [];
            return ChatRow(
              chat: chat,
              messages: messages,
              onTap: () {
                print("Tapped on chat: ${chat.name}");
              },
            );
          }).toList(),
      ],
    );
  }
}
