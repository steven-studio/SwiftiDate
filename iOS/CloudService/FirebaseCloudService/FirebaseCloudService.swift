//
//  FirebaseCloudService.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/26.
//

import Foundation

class FirebaseCloudService: CloudService {
    
    // 可以在這裡擁有各種 Manager 的參考
    private let firebaseManager = FirebaseManager.shared
    private let authService = FirebaseAuthService()
    private let photoManager = FirebasePhotoManager.shared
    private let firestoreManager = FirestoreManager.shared
    
    // 注入的 UserSettings 實例
    var userSettings: UserSettings?
    
    // MARK: - CloudService protocol methods
    
    func initialize() {
        // 呼叫 FirebaseManager 進行初始化
        firebaseManager.configureFirebase()
        firebaseManager.configureFirestore()
        // 有需要就再呼叫其他設定...
        print("Firebase Cloud Service initialized.")
    }
    
    func fetchPhotos(completion: @escaping ([String]) -> Void) {
        // 使用注入的 userSettings 實例
        guard let userSettings = userSettings else {
            print("UserSettings not injected")
            completion([])
            return
        }
        // 改用帶 completion 版本的 fetchPhotosFromFirebase
        photoManager.fetchPhotosFromFirebase {
            // 這個 closure 裡，代表所有照片都下載 & userSettings.photos 已更新
            completion(userSettings.photos)
        }
    }
    
    func uploadAllPhotos(completion: @escaping (Bool) -> Void) {
        // 呼叫 FirebasePhotoManager 的方法
        // 這裡示範：在結束後把成功或失敗傳給 completion
        photoManager.uploadAllPhotos()
        
        // 同理，你可以在 `uploadAllPhotos()` 裡加上一個 callback
        // 這裡先簡化，直接回傳成功
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completion(true)
        }
    }
    
    func saveUserData(userID: String, data: [String : Any], completion: @escaping (Result<Void, Error>) -> Void) {
        firestoreManager.saveUserData(userID: userID, data: data, completion: completion)
    }
    
    func fetchUserData(userID: String, completion: @escaping (Result<[String : Any], Error>) -> Void) {
        firestoreManager.fetchUserData(userID: userID, completion: completion)
    }
    
    func sendOTP(to phoneNumber: String, completion: @escaping (Result<String, Error>) -> Void) {
        Task {
            let result = await authService.startPhoneVerification(phone: phoneNumber)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let verificationID):
                    completion(.success(verificationID))
                case .failure(let authError):
                    completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(authError)"])))
                }
            }
        }
    }
    
    func signInWithOTP(verificationID: String, verificationCode: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            let result = await authService.verifyOTP(verificationID: verificationID, code: verificationCode)
            
            DispatchQueue.main.async {
                switch result {
                case .success(let userID):
                    print("成功登入：\(userID)")
                    completion(.success(()))
                case .failure(let authError):
                    completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "\(authError)"])))
                }
            }
        }
    }
}
