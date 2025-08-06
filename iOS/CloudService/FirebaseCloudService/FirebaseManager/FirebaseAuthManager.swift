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
class FirebaseAuthManager {
    
    // MARK: - Singleton
    static let shared = FirebaseAuthManager()
    private init() {}
    
    // 新增一個屬性來注入 UserSettings
    var userSettings: UserSettings?

    // MARK: - OTP 驗證相關
    
    /// 結合 userSettings 的國碼 + 電話號碼，發送 OTP 驗證碼
    func sendOTP() {
        // 使用注入的 userSettings
        guard let settings = userSettings else {
            print("UserSettings not injected")
            return
        }
        let fullPhoneNumber = "\(settings.globalCountryCode)\(settings.globalPhoneNumber)"
        sendFirebaseOTP(to: fullPhoneNumber) { result in
            switch result {
            case .success(let verificationID):
                print("✅ 成功發送OTP, verificationID: \(verificationID)")
                // 這裡可以存入LocalStorageManager或其他暫存位置
                LocalStorageManager.shared.saveVerificationID(verificationID)

            case .failure(let error):
                print("❌ 發送OTP失敗: \(error.localizedDescription)")
            }
        }
    }

    /// 直接發送 OTP 驗證碼到指定 phoneNumber
    ///
    /// - Parameter phoneNumber: 包含國碼的完整電話號碼 (e.g. "+886912345678")
    func sendFirebaseOTP(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        let formattedPhone = phoneNumber.replacingOccurrences(of: " ", with: "")

        PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhone, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("❌ Firebase 發送 OTP 錯誤: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let verificationID = verificationID else {
                print("❌ Firebase 未提供 verificationID，錯誤不明")
                completion(.failure(NSError(domain: "FirebaseAuth", code: -1, userInfo: [NSLocalizedDescriptionKey: "verificationID 為 nil"])))
                return
            }
            
            print("✅ Firebase OTP 成功發送，verificationID：\(verificationID)")
            completion(.success(verificationID))
        }
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
}
