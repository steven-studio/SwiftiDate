import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart'; // 新增這行
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../providers/user_settings.dart';

class UserMatch {
  final String name;
  final String imageName; // 新增這個屬性

  UserMatch({required this.name, required this.imageName});

  factory UserMatch.fromJson(Map<String, dynamic> json) {
    return UserMatch(
      name: json['name'] ?? '',
      imageName: json['imageName'] ?? 'assets/default_avatar.png', // 提供預設圖片路徑
    );
  }

  // 添加 toJson 方法以便序列化
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageName': imageName,
    };
  }
}

class ChatViewModel extends ChangeNotifier {
  // 新增搜尋控制器
  final TextEditingController searchController = TextEditingController();

  // 主要狀態
  Chat? selectedChat;
  List<UserMatch> userMatches = [];
  List<Chat> chatData = [];
  List<Message> interactiveMessage = [];
  Map<String, List<Message>> chatMessages = {};
  bool showInteractiveContent = false;
  bool showTurboPurchaseView = false;
  bool showTurboView = false;
  int selectedTurboTab = 0;
  bool showSafetyCenterView = false;
  bool showSearchField = false;
  String searchText = '';

  // 使用 SharedPreferences 模擬 AppStorage 的行為
  String userMatchesString = '';
  String chatDataString = '';
  String chatMessagesString = '';

  // 計算過濾後的清單
  List<UserMatch> get filteredMatches {
    if (searchText.isEmpty) return userMatches;
    return userMatches.where((match) => match.name.contains(searchText)).toList();
  }

  List<Chat> get filteredChats {
    if (searchText.isEmpty) return chatData;
    return chatData.where((chat) => chat.name.contains(searchText)).toList();
  }

  final UserSettings userSettings;

  ChatViewModel({required this.userSettings});

  void loadChats() {
    readDataFromFirebase();
  }

  Future<void> readDataFromFirebase() async {
    // 初始化 FirebaseApp，如果尚未初始化
    await Firebase.initializeApp();
    final ref = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://swiftidate-cdff0-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).reference();
    final userId = userSettings.globalUserID;
    print("userSettings.globalUserID: $userId");

    // 讀取 userMatches
    DatabaseEvent eventMatches =
        await ref.child("users").child(userId).child("userMatches").once();
    final valueMatches = eventMatches.snapshot.value;
    if (valueMatches is List) {
      try {
        final jsonData = jsonEncode(valueMatches);
        List<UserMatch> matches = (jsonDecode(jsonData) as List)
            .map((item) => UserMatch.fromJson(item))
            .toList();
        // 倒序排列
        matches = matches.reversed.toList();
        userMatches = matches;
        await saveUserMatchesToAppStorage();
        notifyListeners();
      } catch (e) {
        print("Failed to decode userMatches: $e");
      }
    } else {
      print("Failed to decode userMatches data");
    }

    // 讀取 chatData
    DatabaseEvent eventChats =
        await ref.child("users").child(userId).child("chats").once();
    final valueChats = eventMatches.snapshot.value;
    if (valueChats is List) {
      try {
        final jsonData = jsonEncode(valueChats);
        List<Chat> chats = (jsonDecode(jsonData) as List)
            .map((item) => Chat.fromJson(item))
            .toList();
        if (chats.length > 1) {
          final firstChat = [chats[0]];
          final reversedChats = chats.sublist(1).reversed.toList();
          chats = firstChat + reversedChats;
        }
        chatData = chats;
        await saveChatDataToAppStorage();
        notifyListeners();
      } catch (e) {
        print("Failed to decode chats: $e");
      }
    } else {
      print("Failed to decode chats data");
    }

    // 讀取 chatMessages
    DatabaseEvent eventChatMessages =
        await ref.child("users").child(userId).child("chatMessages").once();
    final valueChatMessages = eventChatMessages.snapshot.value;
    if (valueChatMessages is Map) {
      Map<String, List<Message>> tempChatMessages = {};
      try {
        valueChatMessages.forEach((key, messagesArray) {
          if (messagesArray is List) {
            final jsonData = jsonEncode(messagesArray);
            try {
              List<Message> messages = (jsonDecode(jsonData) as List)
                  .map((item) => Message.fromJson(item))
                  .toList();
              tempChatMessages[key] = messages;
            } catch (e) {
              print("Failed to decode Messages for chat $key: $e");
            }
          }
        });
        chatMessages = tempChatMessages;
        await saveChatMessagesToAppStorage();
        notifyListeners();
      } catch (e) {
        print("Failed to decode chatMessages: $e");
      }
    } else {
      print("Failed to decode chatMessages data");
    }
  }

  // 以下方法使用 SharedPreferences 作存儲示例
  Future<void> saveUserMatchesToAppStorage() async {
    try {
      final data = jsonEncode(userMatches.map((e) => e.toJson()).toList());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userMatchesStorage', data);
      userMatchesString = data;
    } catch (e) {
      print("Failed to encode userMatches: $e");
    }
  }

  Future<void> loadUserMatchesFromAppStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userMatchesString = prefs.getString('userMatchesStorage') ?? '';
    if (userMatchesString.isNotEmpty) {
      try {
        final List decoded = jsonDecode(userMatchesString);
        userMatches = decoded.map((e) => UserMatch.fromJson(e)).toList();
        notifyListeners();
      } catch (e) {
        print("Failed to decode userMatches: $e");
      }
    }
  }

  Future<void> saveChatDataToAppStorage() async {
    try {
      final data = jsonEncode(chatData.map((e) => e.toJson()).toList());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('chatDataStorage', data);
      chatDataString = data;
    } catch (e) {
      print("Failed to encode chatData: $e");
    }
  }

  Future<void> loadChatDataFromAppStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chatDataString = prefs.getString('chatDataStorage') ?? '';
    if (chatDataString.isNotEmpty) {
      try {
        final List decoded = jsonDecode(chatDataString);
        chatData = decoded.map((e) => Chat.fromJson(e)).toList();
        notifyListeners();
      } catch (e) {
        print("Failed to decode chatData: $e");
      }
    }
  }

  Future<void> saveChatMessagesToAppStorage() async {
    try {
      // 將 Map 序列化，這裡假設 key 為 String
      final data = jsonEncode(chatMessages.map((key, value) =>
          MapEntry(key, value.map((e) => e.toJson()).toList())));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('chatMessagesStorage', data);
      chatMessagesString = data;
    } catch (e) {
      print("Failed to encode chatMessages: $e");
    }
  }

  Future<void> loadChatMessagesFromAppStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    chatMessagesString = prefs.getString('chatMessagesStorage') ?? '';
    if (chatMessagesString.isNotEmpty) {
      try {
        final Map decoded = jsonDecode(chatMessagesString);
        chatMessages = decoded.map((key, value) => MapEntry(
            key.toString(),
            (value as List)
                .map((item) => Message.fromJson(item))
                .toList()));
        notifyListeners();
      } catch (e) {
        print("Failed to decode chatMessages: $e");
      }
    }
  }

  // 更新聊天訊息的輔助方法
  void updateChatMessages(String chatID, List<Message> messages) {
    chatMessages[chatID] = messages;
    saveChatMessagesToAppStorage();
    // 此處可加入 Analytics 追蹤
    notifyListeners();
  }

  bool get isLocalStorageEmpty {
    return chatDataString.isEmpty || chatMessagesString.isEmpty;
  }
}
