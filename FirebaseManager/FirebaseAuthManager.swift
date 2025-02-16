//
//  FirebaseAuthManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    private init() {}

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
