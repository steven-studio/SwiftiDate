//
//  FirebaseManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseCrashlytics
import FirebaseAppCheck
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    private init() {}

    func configureFirebase() {
        FirebaseApp.configure()
        print("Firebase configured successfully")
        
        // 啟用 Crashlytics
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        print("Crashlytics initialized successfully")
        // 以及 App Check、Firestore 等相關邏輯都放在這裡
        
        // 註冊未捕獲異常處理程序
        NSSetUncaughtExceptionHandler(uncaughtExceptionHandler)
        print("Uncaught Exception Handler registered")
    }

    func configureFirestore() {
        // 初始化 Firestore 並指定資料庫名稱
        let settings = FirestoreSettings()
        settings.host = "firestore.googleapis.com"
        settings.isPersistenceEnabled = true // 開啟本地資料緩存
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        
        // Use Mirror to reflect on the FirestoreSettings object
        let mirror = Mirror(reflecting: settings)
        print("Firestore Settings Properties:")
        for child in mirror.children {
            if let propertyName = child.label {
                print("\(propertyName): \(child.value)")
            }
        }
        
        var db = Firestore.firestore() // 使用 var 來讓 db 可以重新指派
        db.settings = settings
        
        // 如果需要指定資料庫ID
        if let app = FirebaseApp.app() {
            db = Firestore.firestore(app: app, database: "swiftidate-database")
        }
        
        print("Firestore initialized: \(db)")
    }
}
