import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// 假設這些模型已實作，包含 fromJson/toJson 方法
import '../models/message.dart';
import '../providers/user_settings.dart';
import '../analytics/analytics_manager.dart';
// 假設你也有自訂的 ChatSuggestionView 與 MessageBubbleView
import 'chat_suggestion_view.dart';
import 'message_bubble_view.dart';

class InteractiveContentView extends StatefulWidget {
  final VoidCallback onBack;
  final List<Message> messages; // 傳入訊息列表，修改時需要透過 setState 更新
  const InteractiveContentView({
    Key? key,
    required this.onBack,
    required this.messages,
  }) : super(key: key);

  @override
  _InteractiveContentViewState createState() => _InteractiveContentViewState();
}

class _InteractiveContentViewState extends State<InteractiveContentView> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 埋點：頁面曝光
    AnalyticsManager.shared.trackEvent("interactive_content_view_appear", parameters: {
      "message_count": widget.messages.length,
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    AnalyticsManager.shared.trackEvent("interactive_message_send", parameters: {
      "message_length": text.length,
    });

    // 建立新的 Message 物件
    Message newMessage = Message(
      id: UniqueKey().toString(),
      content: TextMessageType(text), // 假設 MessageContent.text(String) 的實作
      isSender: true,
      time: getCurrentTime(),
      isCompliment: false,
    );

    setState(() {
      widget.messages.add(newMessage);
      _messageController.clear();
    });

    // 上傳訊息至本機伺服器
    uploadMessageToLocalServer(newMessage);
    // 上傳訊息至 Firebase
    uploadMessageToFirebase(newMessage);
  }

  String getCurrentTime() {
    return TimeOfDay.now().format(context);
  }

  void uploadMessageToLocalServer(Message message) async {
    // 只針對文字訊息處理
    if (message.content is! TextMessageType) return;
    String txt = (message.content as TextMessageType).text;

    // 以 isSender 判斷發送人
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    String senderName = message.isSender ? userSettings.globalUserName : "Other";
    String senderID = userSettings.globalUserID;

    Map<String, dynamic> jsonData = {
      "content": txt,
      "senderName": senderName,
      "senderID": senderID,
      "time": message.time,
    };

    final url = Uri.parse("https://your-server-url.example.com/saveMessage");
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(jsonData));
      if (response.statusCode == 200) {
        print("Message uploaded successfully to local server.");
      } else {
        print("Local server responded with status: ${response.statusCode}");
      }
    } catch (error) {
      print("Error uploading message: $error");
    }
  }

  void uploadMessageToFirebase(Message message) {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    // 儲存於 "messages" 節點下自動產生 id
    DatabaseReference messagesRef = ref.child("messages").push();

    if (message.content is! TextMessageType) return;
    String txt = (message.content as TextMessageType).text;

    Map<String, dynamic> data = {
      "content": txt,
      "isSender": message.isSender,
      "time": message.time,
    };

    messagesRef.set(data).then((_) {
      print("Message successfully stored in Firebase.");
    }).catchError((error) {
      print("Firebase upload error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    // 這裡使用 Scaffold 並隱藏預設導航列
    return Scaffold(
      body: Column(
        children: [
          // 自訂導航列
          Container(
            height: 60,
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.grey),
                  onPressed: () {
                    AnalyticsManager.shared.trackEvent("interactive_content_back_pressed");
                    widget.onBack();
                  },
                ),
                const Spacer(),
                const Text(
                  "戀人卡指南",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // 可根據需求在右側加其他按鈕
              ],
            ),
          ),
          Divider(),
          // 主內容 ScrollView
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 文本說明區塊
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      "戀人卡每天都會有不同的題目等你來回答！選擇相同答案的兩個人即可直接配對成功～",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 示範圖片區
                  Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage("assets/exampleImage.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 資訊區塊
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("《滑卡指南》",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                        SizedBox(height: 4),
                        Text("👉 點擊卡片可以看到更多資訊哦～",
                            style: TextStyle(fontSize: 16, color: Colors.green)),
                        SizedBox(height: 4),
                        Text("❤️ @玩玩，來找到真正適合自己的配對！",
                            style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // "繼續" 按鈕
                  ElevatedButton(
                    onPressed: widget.onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Center(
                      child: Text("繼續", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 輸入區與底部工具列
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                // 輸入框與發送按鈕
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "輸入聊天內容",
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                    _messageController.text.isEmpty
                        ? const Icon(Icons.mic, color: Colors.black, size: 24)
                        : IconButton(
                            icon: const Icon(Icons.send, color: Colors.blue, size: 24),
                            onPressed: sendMessage,
                          ),
                  ],
                ),
                const SizedBox(height: 8),
                // 底部功能列
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 這裡假設 GIF 為本地資源，否則可用 NetworkImage
                    Image.asset("assets/gif.png", width: 24, height: 24, color: Colors.blue),
                    const Icon(Icons.photo, size: 24, color: Colors.blue),
                    const Icon(Icons.map, size: 24, color: Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // 使用 showModalBottomSheet 或 Navigator.push 實現其他全屏覆蓋
    );
  }
}
