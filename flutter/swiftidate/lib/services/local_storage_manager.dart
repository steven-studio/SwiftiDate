import 'package:shared_preferences/shared_preferences.dart';
import 'user_settings.dart';

class LocalStorageManager {
  // 單例模式
  static final LocalStorageManager shared = LocalStorageManager._internal();
  LocalStorageManager._internal();

  /// 保存使用者設定到 SharedPreferences
  Future<void> saveUserSettings(UserSettings userSettings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("phoneNumber", userSettings.globalPhoneNumber);
    await prefs.setString("userName", userSettings.globalUserName);
    // 假設 Gender 有 toString 方法或另外定義轉換方法
    await prefs.setString("userGender", userSettings.globalUserGender.toString());
    await prefs.setBool("isUserVerified", userSettings.globalIsUserVerified);
    await prefs.setInt("turboCount", userSettings.globalTurboCount);
    await prefs.setInt("crushCount", userSettings.globalCrushCount);
    await prefs.setInt("praiseCount", userSettings.globalPraiseCount);
    await prefs.setInt("likesMeCount", userSettings.globalLikesMeCount);
    await prefs.setInt("likeCount", userSettings.globalLikeCount);
    await prefs.setBool("isSupremeUser", userSettings.isSupremeUser);
    print("Debug - User data has been saved to SharedPreferences.");
  }

  /// 從 SharedPreferences 讀取使用者設定並更新 userSettings 物件
  Future<void> loadUserSettings(UserSettings userSettings) async {
    final prefs = await SharedPreferences.getInstance();
    userSettings.globalPhoneNumber = prefs.getString("phoneNumber") ?? "未設定";
    userSettings.globalUserName = prefs.getString("userName") ?? "未設定";
    
    // 假設你的 Gender 列舉有一個從字串轉換的方法
    final genderString = prefs.getString("userGender");
    if (genderString != null) {
      userSettings.globalUserGender = GenderExtension.fromString(genderString);
    }
    
    userSettings.globalIsUserVerified = prefs.getBool("isUserVerified") ?? false;
    userSettings.globalTurboCount = prefs.getInt("turboCount") ?? 0;
    userSettings.globalCrushCount = prefs.getInt("crushCount") ?? 0;
    userSettings.globalPraiseCount = prefs.getInt("praiseCount") ?? 0;
    userSettings.globalLikesMeCount = prefs.getInt("likesMeCount") ?? 0;
    userSettings.globalLikeCount = prefs.getInt("likeCount") ?? 0;
    userSettings.isSupremeUser = prefs.getBool("isSupremeUser") ?? false;
  }

  /// 清除所有 SharedPreferences 中的資料
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// 保存驗證 ID
  Future<void> saveVerificationID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("FirebaseVerificationID", id);
  }
}
