import 'package:flutter/foundation.dart';

enum Gender { male, female, other }

class UserSettings extends ChangeNotifier {
  String globalPhoneNumber = "";
  String globalUserName = "";
  Gender globalUserGender = Gender.other;
  bool globalIsUserVerified = false;
  String globalSelectedGender = "";
  String globalUserBirthday = "";
  String globalUserID = "";
  int globalLikesMeCount = 0;
  int globalLikeCount = 0;
  bool isPremiumUser = false;
  bool isSupremeUser = false;
  int globalTurboCount = 0;
  int globalCrushCount = 0;
  int globalPraiseCount = 0;
  bool isProfilePhotoVerified = false;

  // 新增 newMatchedChatID 屬性，用於儲存新的配對聊天 ID
  String? newMatchedChatID;

  // 例如，更新電話的函式：
  void updatePhoneNumber(String phone) {
    globalPhoneNumber = phone;
    notifyListeners();
  }
  
  // 你可以依需求定義更多 setter 或更新方法
}
