/// 抽象化的雲端介面，定義你的 App 需要的雲端操作。
abstract class CloudService {
  /// 初始化，例如 Firebase.initializeApp() 或其他雲端服務初始化
  Future<void> initialize();

  /// 取得並更新最新照片列表
  Future<List<String>> fetchPhotos();

  /// 上傳所有本地照片，返回一個布林值表示成功與否
  Future<bool> uploadAllPhotos();

  /// 儲存使用者資料
  Future<void> saveUserData(String userID, Map<String, dynamic> data);

  /// 取得使用者資料
  Future<Map<String, dynamic>> fetchUserData(String userID);

  /// 傳送 OTP 到指定電話號碼，返回驗證 ID 或錯誤
  Future<String> sendOTP(String phoneNumber);

  /// 使用 OTP 登入
  Future<void> signInWithOTP(String verificationID, String verificationCode);
}
