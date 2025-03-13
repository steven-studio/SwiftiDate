//
//  FirestoreManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager()
    private init() {}
    
    private var db: Firestore {
        return Firestore.firestore()
        // 或者：return Firestore.firestore(app: someSpecificApp, database: "swiftidate-database")
    }
    
    /// 新增或更新使用者資料
    func saveUserData(userID: String, data: [String: Any], completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("users").document(userID).setData(data, merge: true) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// 讀取使用者資料
    func fetchUserData(userID: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = snapshot?.data() else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data found"])))
                return
            }
            completion(.success(data))
        }
    }
    
    /// 觀察（listen）使用者資料
    func listenUserData(userID: String, listener: @escaping (Result<[String: Any], Error>) -> Void) -> ListenerRegistration {
        return db.collection("users").document(userID).addSnapshotListener { snapshot, error in
            if let error = error {
                listener(.failure(error))
            } else if let data = snapshot?.data() {
                listener(.success(data))
            } else {
                listener(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data"])))
            }
        }
    }
    
    // ... 你可以繼續加入更多 Firestore 操作，按照需求劃分
}
