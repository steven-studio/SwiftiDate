//
//  LocalStorageManagerTests.swift
//  SwiftiDateTests
//
//  Created by 游哲維 on 2025/2/27.
//

import XCTest
@testable import SwiftiDate  // ★ 新增這行

final class LocalStorageManagerTests: XCTestCase {
    
    var localStorage: LocalStorageManager!
    
    override func setUpWithError() throws {
        localStorage = LocalStorageManager.shared
        localStorage.clearAll() // 清空
    }
    
    override func tearDownWithError() throws {
        localStorage.clearAll() // 再清空
    }
    
    func testSaveAndLoadUserSettings() {
        let userSettings = UserSettings()
        userSettings.globalPhoneNumber = "0900123456"
        userSettings.globalUserName = "Alice"
        userSettings.globalUserGender = .female
        
        // 存
        LocalStorageManager.shared.saveUserSettings(userSettings)
        
        // 再建個空的 target
        let loadTarget = UserSettings()
        LocalStorageManager.shared.loadUserSettings(into: loadTarget)
        
        // 斷言
        XCTAssertEqual(loadTarget.globalPhoneNumber, "0900123456")
        XCTAssertEqual(loadTarget.globalUserName, "Alice")
        XCTAssertEqual(loadTarget.globalUserGender, .female)
    }
    
    func testClearAll() {
        // 先存 key
        UserDefaults.standard.set("HELLO", forKey: "someTestKey")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "someTestKey"), "HELLO")

        LocalStorageManager.shared.clearAll()
        // 再檢查
        XCTAssertNil(UserDefaults.standard.string(forKey: "someTestKey"))
    }
    
    func testSaveVerificationID() {
        LocalStorageManager.shared.saveVerificationID("VerificationABC123")
        XCTAssertEqual(UserDefaults.standard.string(forKey: "FirebaseVerificationID"), "VerificationABC123")
    }
}
