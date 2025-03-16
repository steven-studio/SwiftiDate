import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Models
import '../models/chat.dart'; // Chat 模型
import '../models/message.dart';

// Providers
import '../providers/user_settings.dart';
import '../providers/app_state.dart';

// ViewModels
import '../view_models/chat_view_model.dart'; // ChatViewModel 必須實作 ChangeNotifier

// Widgets
import 'chat_detail_view.dart';
import 'interactive_content_view.dart';
import 'chat_list_container_view.dart';
import 'chat_row.dart';
import 'turbo_view.dart';
// import 'safety_center_view.dart';
import 'turbo_purchase_view.dart';

class ChatView extends StatefulWidget {
  final int contentSelectedTab;
  final UserSettings userSettings; // 新增的參數

  const ChatView({
    Key? key,
    required this.contentSelectedTab,
    required this.userSettings,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late ChatViewModel viewModel;

  @override
  void initState() {
    super.initState();
    // 使用從建構子傳入的 userSettings
    viewModel = ChatViewModel(userSettings: widget.userSettings);
    // 延後初始化資料
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.chatDataString.isEmpty ||
          viewModel.chatMessagesString.isEmpty ||
          viewModel.userMatches.isEmpty) {
        // 從 Firebase 讀取數據
        print("Loading data from Firebase as local storage is empty");
        viewModel.readDataFromFirebase();
      } else {
        // 從本地載入數據
        viewModel.loadUserMatchesFromAppStorage();
        viewModel.loadChatDataFromAppStorage();
        viewModel.loadChatMessagesFromAppStorage();
        print("Loaded data from local storage");
      }
      // 檢查 widget.userSettings.newMatchedChatID
      if (widget.userSettings.newMatchedChatID != null) {
        // 模擬一個新的聊天對象
        final newChat = Chat(
          id: UniqueKey().toString(),
          name: "對方暱稱",
          time: "00:00",
          unreadCount: 0,
          phoneNumber: "xxx",
          photoURLs: [],
        );
        viewModel.selectedChat = newChat;
        widget.userSettings.newMatchedChatID = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用 ChangeNotifierProvider 包裹 viewModel
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<ChatViewModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: model.showSearchField
                  ? _buildSearchBar()
                  : const Text(
                      "聊天",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
              // leading: model.showSearchField
              //     ? null
              //     : IconButton(
              //         icon: const Icon(Icons.shield, color: Colors.grey),
              //         onPressed: () {
              //           model.showSafetyCenterView = true;
              //         },
              //       ),
              leading: model.showSearchField ? null : Container(),
              actions: model.showSearchField
                  ? []
                  : [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            model.showSearchField = true;
                          });
                        },
                      ),
                    ],
            ),
            body: _buildBody(),
            // 以下展示 TurboView、SafetyCenterView、TurboPurchaseView 可透過 Navigator.push 等方式實現全屏覆蓋
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: viewModel.searchController,
                    decoration:
                        const InputDecoration.collapsed(hintText: "搜尋配對好友"),
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              viewModel.searchText = "";
              viewModel.showSearchField = false;
            });
          },
          child: const Text("取消", style: TextStyle(color: Colors.green)),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (viewModel.selectedChat != null) {
      // 顯示聊天詳情頁
      return ChatDetailView(
        chat: viewModel.selectedChat!,
        messages: viewModel.chatMessages[viewModel.selectedChat!.id] ?? <Message>[],
        onBack: () {
          // 例如：記錄事件後返回聊天列表
          viewModel.selectedChat = null;
        },
      );
    } else if (viewModel.showInteractiveContent) {
      // 顯示互動內容頁
      return InteractiveContentView(
        onBack: () {
          viewModel.showInteractiveContent = false;
        },
        messages: viewModel.interactiveMessage,
      );
    } else if (viewModel.showSearchField &&
        viewModel.filteredMatches.isEmpty) {
      // 顯示搜尋結果列表
      return ListView.builder(
        itemCount: viewModel.filteredChats.length,
        itemBuilder: (context, index) {
          final chat = viewModel.filteredChats[index];
          final messages = viewModel.chatMessages[chat.id] ?? [];
          return ChatRow(
            chat: chat,
            messages: messages,
            onTap: () {
              if (chat.name == "SwiftiDate") {
                viewModel.showInteractiveContent = true;
                viewModel.selectedChat = null;
              } else {
                viewModel.showInteractiveContent = false;
                viewModel.selectedChat = chat;
              }
            },
            onRename: () {
              // 修改備註的邏輯
            },
            onUnmatch: () {
              // 解除配對的邏輯
            },
          );
        },
      );
    } else {
      // 顯示聊天列表容器
      return ChatListContainerView(
        viewModel: viewModel,
        showTurboView: viewModel.showTurboView,
      );
    }
  }
}