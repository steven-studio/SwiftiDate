// lib/widgets/message_bubble_view.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/message.dart';

class MessageBubbleView extends StatefulWidget {
  final Message message;
  final bool isCurrentUser;
  final bool showTime;

  const MessageBubbleView({
    Key? key,
    required this.message,
    required this.isCurrentUser,
    required this.showTime,
  }) : super(key: key);

  @override
  _MessageBubbleViewState createState() => _MessageBubbleViewState();
}

class _MessageBubbleViewState extends State<MessageBubbleView> {
  bool isLiked = false;

  /// 模擬播放音訊，實際可使用 audioplayers 等套件來實作
  void playAudio(String audioPath) {
    print('播放音訊: $audioPath');
    // TODO: 加入真實的音訊播放邏輯
  }

  /// 文字訊息長按時的選單
  void _showTextMessageMenu(String text) async {
    final selected = await showMenu<String>(
      context: context,
      // 此處位置設定為中間，可依需求調整
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 16),
              const SizedBox(width: 8),
              const Text('拷貝'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'like',
          child: Row(
            children: [
              Icon(Icons.thumb_up, size: 16),
              const SizedBox(width: 8),
              const Text('按讚'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'reply',
          child: Row(
            children: [
              Icon(Icons.reply, size: 16),
              const SizedBox(width: 8),
              const Text('回覆'),
            ],
          ),
        ),
      ],
    );

    switch (selected) {
      case 'copy':
        Clipboard.setData(ClipboardData(text: text));
        break;
      case 'like':
        setState(() {
          isLiked = !isLiked;
        });
        print("按讚");
        break;
      case 'reply':
        print("回覆");
        break;
      default:
        break;
    }
  }

  /// 圖片訊息長按時的選單
  void _showImageMessageMenu(Uint8List imageData) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem(
          value: 'save',
          child: Row(
            children: [
              Icon(Icons.download, size: 16),
              const SizedBox(width: 8),
              const Text('保存圖片'),
            ],
          ),
        ),
      ],
    );

    if (selected == 'save') {
      // 這裡可整合 image_gallery_saver 等套件來保存圖片
      print('保存圖片');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 根據是否為當前使用者設定訊息氣泡背景與文字顏色
    Color bubbleColor;
    Color textColor;
    if (widget.isCurrentUser) {
      bubbleColor = widget.message.isCompliment ? Colors.black : Colors.green;
      textColor = Colors.white;
    } else {
      bubbleColor = Colors.grey.withOpacity(0.3);
      textColor = Colors.black;
    }

    Widget messageContent;

    // 根據 Message 的內容類型顯示不同的 Widget
    if (widget.message.content is TextMessageType) {
      final textContent = (widget.message.content as TextMessageType).text;
      messageContent = GestureDetector(
        onLongPress: () => _showTextMessageMenu(textContent),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            textContent,
            style: TextStyle(color: textColor),
          ),
        ),
      );
    } else if (widget.message.content is ImageMessageType) {
      final imageData = (widget.message.content as ImageMessageType).imageData;
      messageContent = GestureDetector(
        onLongPress: () => _showImageMessageMenu(imageData),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Image.memory(
            imageData,
            fit: BoxFit.cover,
            width: 200,
            height: 200,
          ),
        ),
      );
    } else if (widget.message.content is AudioMessageType) {
      final audioPath = (widget.message.content as AudioMessageType).audioPath;
      messageContent = Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextButton.icon(
          onPressed: () {
            playAudio(audioPath);
          },
          icon: const Icon(Icons.waves, color: Colors.blue),
          label: const Text(
            "播放語音",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      );
    } else {
      messageContent = Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showTime)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              widget.message.time,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (widget.isCurrentUser) const Spacer(),
            Flexible(
              child: Padding(
                padding: widget.isCurrentUser
                    ? const EdgeInsets.only(left: 50)
                    : const EdgeInsets.only(right: 50),
                child: messageContent,
              ),
            ),
            if (!widget.isCurrentUser)
              IconButton(
                onPressed: () {
                  setState(() {
                    isLiked = !isLiked;
                  });
                },
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey.withOpacity(0.4),
                ),
              ),
            if (!widget.isCurrentUser) const Spacer(),
          ],
        ),
      ],
    );
  }
}
