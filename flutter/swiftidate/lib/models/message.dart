// lib/models/message.dart

import 'dart:convert';
import 'dart:typed_data';

/// MessageType 抽象類別，代表訊息的內容類型。
abstract class MessageType {
  const MessageType();
  String get type;
  /// 將內容轉換成 JSON 格式
  Map<String, dynamic> toJson();

  /// 從 JSON 中建立對應的 MessageType 物件
  static MessageType fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final value = json['value'];
    switch (type) {
      case 'text':
        return TextMessageType(value as String);
      case 'image':
        // 假設圖片數據以 Base64 編碼後的字串形式存儲
        return ImageMessageType(base64Decode(value as String));
      case 'audio':
        return AudioMessageType(value as String);
      default:
        throw Exception("Unknown MessageType: $type");
    }
  }
}

/// 文字訊息類型
class TextMessageType extends MessageType {
  final String text;
  const TextMessageType(this.text);

  @override
  String get type => 'text';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'text',
      'value': text,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextMessageType && runtimeType == other.runtimeType && text == other.text;

  @override
  int get hashCode => text.hashCode;

  @override
  String toString() => 'TextMessageType(text: $text)';
}

/// 圖片訊息類型
class ImageMessageType extends MessageType {
  final Uint8List imageData;
  const ImageMessageType(this.imageData);

  @override
  String get type => 'image';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'image',
      // 將圖片數據編碼為 Base64 字串
      'value': base64Encode(imageData),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageMessageType &&
          runtimeType == other.runtimeType &&
          imageData.length == other.imageData.length &&
          imageData.every((byte) => other.imageData.contains(byte));

  @override
  int get hashCode => imageData.hashCode;

  @override
  String toString() => 'ImageMessageType(imageData: ${imageData.length} bytes)';
}

/// 音訊訊息類型
class AudioMessageType extends MessageType {
  final String audioPath;
  const AudioMessageType(this.audioPath);

  @override
  String get type => 'audio';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'audio',
      'value': audioPath,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioMessageType && runtimeType == other.runtimeType && audioPath == other.audioPath;

  @override
  int get hashCode => audioPath.hashCode;

  @override
  String toString() => 'AudioMessageType(audioPath: $audioPath)';
}

/// 訊息模型
class Message {
  final String id;
  final MessageType content;
  final bool isSender;
  final String time;
  final bool isCompliment;

  Message({
    required this.id,
    required this.content,
    required this.isSender,
    required this.time,
    this.isCompliment = false,
  });

  /// 從 JSON 建立 Message 物件
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: MessageType.fromJson(json['content'] as Map<String, dynamic>),
      isSender: json['isSender'] as bool,
      time: json['time'] as String,
      isCompliment: json['isCompliment'] as bool? ?? false,
    );
  }

  /// 將 Message 物件轉換成 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content.toJson(),
      'isSender': isSender,
      'time': time,
      'isCompliment': isCompliment,
    };
  }

  @override
  String toString() {
    return 'Message(id: $id, content: $content, isSender: $isSender, time: $time, isCompliment: $isCompliment)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          content == other.content &&
          isSender == other.isSender &&
          time == other.time &&
          isCompliment == other.isCompliment;

  @override
  int get hashCode =>
      id.hashCode ^ content.hashCode ^ isSender.hashCode ^ time.hashCode ^ isCompliment.hashCode;
}
