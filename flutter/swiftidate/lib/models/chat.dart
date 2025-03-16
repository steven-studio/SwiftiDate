// lib/models/chat.dart

import 'dart:convert';

/// 聊天模型
class Chat {
  /// 使用 [String] 作為 id，若需要可以使用第三方 package 處理 UUID。
  final String id;
  final String name;
  final String time;
  final int unreadCount;
  final String? phoneNumber;
  final List<String>? photoURLs;

  Chat({
    required this.id,
    required this.name,
    required this.time,
    required this.unreadCount,
    this.phoneNumber,
    this.photoURLs,
  });

  /// 從 JSON 建立 Chat 物件
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] as String,
      name: json['name'] as String,
      time: json['time'] as String,
      unreadCount: json['unreadCount'] as int,
      phoneNumber: json['phoneNumber'] as String?,
      photoURLs: json['photoURLs'] != null
          ? List<String>.from(json['photoURLs'])
          : null,
    );
  }

  /// 將 Chat 物件轉換成 JSON 格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'unreadCount': unreadCount,
      'phoneNumber': phoneNumber,
      'photoURLs': photoURLs,
    };
  }

  @override
  String toString() {
    return 'Chat(id: $id, name: $name, time: $time, unreadCount: $unreadCount, phoneNumber: $phoneNumber, photoURLs: $photoURLs)';
  }
}
