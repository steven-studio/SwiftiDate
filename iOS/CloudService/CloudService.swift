//
//  CloudService.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/26.
//

/// 抽象化的雲端介面，定義你的 App 需要的雲端操作。
protocol CloudService {
    /// 一般初始化流程，例如 FirebaseApp.configure() 或阿里雲初始化
    func initialize()
    
    // ---- 以下只是舉例，你可以依照需求擴充 ----
    
    /// 取得並更新最新照片列表
    func fetchPhotos(completion: @escaping ([String]) -> Void)
    
    /// 上傳所有本地照片
    func uploadAllPhotos(completion: @escaping (Bool) -> Void)
    
    /// 使用者資料讀寫
    func saveUserData(userID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void)
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void)
    
    /// OTP 或其他登入方式
    func sendOTP(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void)
    func signInWithOTP(verificationID: String, verificationCode: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    // ...
}
