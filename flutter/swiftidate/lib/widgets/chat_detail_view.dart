// Models
import '../models/chat.dart';
import '../models/message.dart';

// Providers
import '../providers/user_settings.dart';

// Analytics
import '../analytics/analytics_manager.dart';

// Widgets
import 'chat_row.dart';
import 'chat_suggestion_view.dart';
import 'message_bubble_view.dart';

// 其他外部套件
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

// 請確保 Chat、Message 模型已定義，並實作 fromJson/toJson
class ChatDetailView extends StatefulWidget {
  final Chat chat;
  final List<Message> messages;
  final VoidCallback onBack;

  const ChatDetailView({
    Key? key,
    required this.chat,
    required this.messages,
    required this.onBack,
  }) : super(key: key);

  @override
  State<ChatDetailView> createState() => _ChatDetailViewState();
}

class _ChatDetailViewState extends State<ChatDetailView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isShowingCallView = false;
  bool showChatGPTModal = false;
  // 以下 alert 控制變數
  bool showWarnConfirmation = false;
  String? pendingWarnMessage;

  @override
  void initState() {
    super.initState();
    // 模擬畫面曝光埋點
    AnalyticsManager.shared.trackEvent("chat_detail_view_appear", parameters: {
      "chat_id": widget.chat.id,
      "chat_name": widget.chat.name,
    });
    // 延遲滾動到最後一筆訊息
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 模擬發送訊息的方法，實際上你可能要呼叫 API 或更新狀態
  void sendMessage() {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    // 假設我們有一個 RuleChecker.checkMessage 類似的邏輯
    // 此處簡單模擬，直接允許送出
    setState(() {
      widget.messages.add(Message(
        id: UniqueKey().toString(),
        content: TextMessageType(text),
        isSender: true,
        time: _getCurrentTime(),
        isCompliment: false,
      ));
      _messageController.clear();
    });
    AnalyticsManager.shared.trackEvent("message_sent", parameters: {
      "message_length": text.length,
    });
    // 模擬截圖上傳 (略)
    _captureScreenshotAndUpload();
    // 滾動到最新訊息
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    return TimeOfDay.now().format(context);
  }

  void _captureScreenshotAndUpload() async {
    // 這裡僅作示範：在 Flutter 中截圖上傳通常需使用第三方套件
    AnalyticsManager.shared.trackEvent("screenshot_captured");
    // 呼叫 Firebase Storage 上傳邏輯 (略)
  }

  // 模擬開始通話
  void startWebRTCCall() {
    AnalyticsManager.shared.trackEvent("phone_call_pressed", parameters: {
      "phone_number": Provider.of<UserSettings>(context, listen: false).globalPhoneNumber,
    });
    setState(() {
      isShowingCallView = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.grey),
          onPressed: () {
            AnalyticsManager.shared.trackEvent("chat_detail_back_pressed");
            widget.onBack();
          },
        ),
        title: Row(
          children: [
            // 替換成真實用戶頭像
            const CircleAvatar(
              backgroundImage: AssetImage('assets/avatar_placeholder.png'),
              radius: 20,
            ),
            const SizedBox(width: 8),
            Text(
              widget.chat.name,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.pink),
            onPressed: () {
              // 例如：顯示通知設定
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.green),
            onPressed: startWebRTCCall,
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              // 使用底部彈出選單實現 ActionSheet
              _showActionSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(),
          // 消息列表
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: widget.messages.length,
                itemBuilder: (context, index) {
                  final message = widget.messages[index];
                  // 判斷是否需要顯示時間
                  bool showTime = index == 0 ||
                      widget.messages[index].time != widget.messages[index - 1].time;
                  // 這裡使用一個自訂 MessageBubbleView 來展示訊息
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: MessageBubbleView(
                      message: message,
                      isCurrentUser: message.isSender, // 根據訊息是否由當前使用者發送來決定
                      showTime: showTime,
                    ),
                  );
                },
              ),
            ),
          ),
          // 訊息輸入區與聊天建議
          _buildInputArea(),
        ],
      ),
      // 如果需要全屏通話畫面
      // 當 isShowingCallView 為 true 時，使用 Navigator.push 或全屏 Cover
      // 這裡簡單模擬
      floatingActionButton: isShowingCallView
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  isShowingCallView = false;
                });
              },
              child: const Icon(Icons.call_end),
            )
          : null,
    );
  }

  Widget _buildInputArea() {
    return Column(
      children: [
        // 聊天建議
        ChatSuggestionView(
          suggestions: const [
            "嗨，你好嗎？",
            "今天過得怎麼樣？",
            "最近有什麼好玩的事？",
            "你喜歡旅遊嗎？",
          ],
          onSelect: (suggestion) {
            _messageController.text = suggestion;
          },
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.green),
                onPressed: () {
                  AnalyticsManager.shared.trackEvent("camera_button_pressed");
                  setState(() {
                    showChatGPTModal = true;
                  });
                },
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "輸入聊天內容",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              _messageController.text.isEmpty
                  ? const Icon(Icons.mic, color: Colors.black)
                  : IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: sendMessage,
                    ),
            ],
          ),
        ),
        // 底部功能列
        Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("GIF", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Icon(Icons.photo, size: 24, color: Colors.black),
              Icon(Icons.location_on, size: 24, color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }

  void _showActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              title: const Text("修改備註名稱"),
              onTap: () {
                Navigator.pop(context);
                // 埋點：點擊修改備註名稱
                AnalyticsManager.shared.trackEvent("chat_rename_tapped");
              },
            ),
            ListTile(
              title: const Text("匿名檢舉和封鎖"),
              onTap: () {
                Navigator.pop(context);
                AnalyticsManager.shared.trackEvent("chat_report_block_tapped");
              },
            ),
            ListTile(
              title: const Text("安全中心"),
              onTap: () {
                Navigator.pop(context);
                AnalyticsManager.shared.trackEvent("safety_center_tapped");
              },
            ),
            ListTile(
              title: const Text("刪除聊天記錄"),
              onTap: () {
                Navigator.pop(context);
                AnalyticsManager.shared.trackEvent("delete_chat_tapped");
              },
            ),
            ListTile(
              title: const Text("解除配對"),
              onTap: () {
                Navigator.pop(context);
                AnalyticsManager.shared.trackEvent("unmatch_tapped");
              },
            ),
            ListTile(
              title: const Text("取消"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
