//
//  FirebaseAuthManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging

/// 使用 Firebase Auth 進行各種登入驗證的管理類別
final class FirebaseAuthManager {
    
    // MARK: - Singleton
    static let shared = FirebaseAuthManager()
    private init() {
        print("🏗️ FirebaseAuthManager 正在初始化")
        // 如果這裡有耗時操作或會拋出錯誤的代碼，可能會導致問題
    }
    
    // 新增一個屬性來注入 UserSettings
    var userSettings: UserSettings?
    
    private var isVerifying = false

    // MARK: - OTP 驗證相關
    
    /// 結合 userSettings 的國碼 + 電話號碼，發送 OTP 驗證碼
    func sendOTP(completion: @escaping (Result<String, Error>) -> Void) {
        // 使用注入的 userSettings
        guard let settings = userSettings else {
            completion(.failure(NSError(domain: "FirebaseAuth", code: -999, userInfo: [NSLocalizedDescriptionKey: "Firebase not initialized"])))
            return
        }
        let fullPhoneNumber = "\(settings.globalCountryCode)\(settings.globalPhoneNumber)"
        sendFirebaseOTP(to: fullPhoneNumber) { result in
            switch result {
            case .success(let verificationID):
                LocalStorageManager.shared.saveVerificationID(verificationID)
                completion(.success(verificationID))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// 直接發送 OTP 驗證碼到指定 phoneNumber
    ///
    /// - Parameter phoneNumber: 包含國碼的完整電話號碼 (e.g. "+886912345678")
    func sendFirebaseOTP(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        // 🔴 在這裡設置 breakpoint - 檢查 Firebase Auth 是否可用
        guard Auth.auth().app != nil else {
            NSLog("❌ Firebase Auth 未初始化")
            completion(.failure(NSError(domain: "FirebaseAuth", code: -999, userInfo: [NSLocalizedDescriptionKey: "Firebase Auth 未初始化"])))
            return
        }
        guard !isVerifying else {
            print("⛔️ 已在驗證中，忽略重複呼叫")
            return
        }
        
        isVerifying = true
        let formattedPhone = phoneNumber.replacingOccurrences(of: " ", with: "")
        NSLog("🔥 開始執行 sendFirebaseOTP")
        NSLog("🔥 格式化後的電話號碼: \(formattedPhone)")

        print("🔥 檢查 Auth 實例: \(Auth.auth())")
        
        // 檢查 PhoneAuthProvider
        print("🔥 準備取得 PhoneAuthProvider")
        let provider = PhoneAuthProvider.provider()
        print("🔥 PhoneAuthProvider: \(provider)")
        
        print("🔥 即將呼叫 verifyPhoneNumber")
        
        provider.verifyPhoneNumber(formattedPhone, uiDelegate: nil) { [weak self] verificationID, error in
            defer { self?.isVerifying = false }   // ✅ 結束時釋放鎖

            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let verificationID = verificationID else {
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "verificationID 為 nil"])))
                return
            }
            
            // ✅ 新增：將verificationID 存入 UserDefaults
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            print("✅ Firebase OTP 成功發送，verificationID：\(verificationID)")
            completion(.success(verificationID))
        }
        
        print("🔥 已呼叫 verifyPhoneNumber，等待回調")
    }

    /// 以電話號碼進行登入（驗證碼流程）
    func signInWithPhoneNumber(
        phoneNumber: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        // 產生驗證碼時，需要先取得 Firebase 的驗證參數
        // 這段要在真機或有 SIM 卡的模擬器才能運作(或用測試號碼)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let verificationID = verificationID {
                completion(.success(verificationID))
            } else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No verificationID"])))
            }
        }
    }

    /// 用驗證碼（OTP）進行登入
    func signInWithOTP(
        verificationID: String,
        verificationCode: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let authResult = authResult {
                completion(.success(authResult))
            } else {
                completion(.failure(NSError(domain: "AuthError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No auth result"])))
            }
        }
    }

    /// 以 Email/Password 登入範例
    func signInWithEmail(
        email: String,
        password: String,
        completion: @escaping (Result<AuthDataResult, Error>) -> Void
    ) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let authResult = authResult {
                completion(.success(authResult))
            } else {
                completion(.failure(NSError(domain: "AuthError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No auth result"])))
            }
        }
    }
    
    /// 登出
    func signOut() -> Result<Void, Error> {
        do {
            try Auth.auth().signOut()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    /// 儲存 verificationID 到 UserDefaults
    private func storeVerificationID(_ verificationID: String) {
        UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
    }

    /// 取回 verificationID
    func getStoredVerificationID() -> String? {
        UserDefaults.standard.string(forKey: "authVerificationID")
    }
}
