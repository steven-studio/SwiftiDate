import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../models/message.dart';

class ChatRow extends StatelessWidget {
  final Chat chat;
  final List<Message> messages;
  final VoidCallback onTap; // 新增 onTap 參數
  final VoidCallback? onRename; // 新增回呼參數
  final VoidCallback? onUnmatch; // 新增回呼參數

  const ChatRow({
    Key? key,
    required this.chat,
    required this.messages,
    required this.onTap,
    this.onRename,
    this.onUnmatch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 取得最後一筆訊息預覽
    String preview = "";
    if (messages.isNotEmpty) {
      final lastMessage = messages.last;
      if (lastMessage.content is TextMessageType) {
        preview = (lastMessage.content as TextMessageType).text;
      } else if (lastMessage.content is ImageMessageType) {
        preview = "[圖片]";
      } else if (lastMessage.content is AudioMessageType) {
        preview = "[語音]";
      } else {
        preview = "";
      }
    }
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            // 角頭圖片
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipOval(
                child: Image.asset(
                  'assets/default_avatar.png', // 假設 Chat 模型中有 avatarAsset 屬性
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.account_circle,
                      color: Colors.grey,
                      size: 50,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 15),
            // 聊天資訊區
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preview,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // 時間與未讀數區及操作按鈕
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  chat.time,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                if (chat.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat.unreadCount}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 4),
                // 顯示操作按鈕，若對應的回呼不為 null 就顯示按鈕
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (onRename != null)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onRename,
                      ),
                    if (onUnmatch != null)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        onPressed: onUnmatch,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
