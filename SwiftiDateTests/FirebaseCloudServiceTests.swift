//
//  FirebaseCloudServiceTests.swift
//  SwiftiDateTests
//
//  Created by 游哲維 on 2025/2/27.
//

import XCTest
import FirebaseCore // 若要使用 FirebaseApp.app() 等，需要 import FirebaseCore
@testable import SwiftiDate // 引入主程式專案

final class FirebaseCloudServiceTests: XCTestCase {
    
    private var firebaseCloudService: FirebaseCloudService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // 初始化要測試的 Service
        firebaseCloudService = FirebaseCloudService()
    }
    
    override func tearDownWithError() throws {
        // 清除
        firebaseCloudService = nil
        try super.tearDownWithError()
    }
    
    // MARK: - 1) 測試 Firebase 初始化
    func testInitialization() throws {
        // 若 FirebaseApp 已配置，則視為測試失敗（防止重複 configure）
        if FirebaseApp.app() != nil {
            XCTFail("""
            [TEST FAILED] - Default Firebase app已被重複初始化 (com.firebase.core)
            建議：在測試前先檢查  FirebaseApp.app() == nil  才呼叫 configure()。
            """)
            return
        }
        
        // 呼叫雲端服務的初始化方法
        firebaseCloudService.initialize()
        
        // 若沒拋錯就當作通過
        XCTAssertTrue(true, "Firebase 初始化不應該拋出錯誤")
    }
    
    // MARK: - 2) 測試 fetchPhotos
    func testFetchPhotos() {
        let expectation = self.expectation(description: "fetchPhotos")
        
        firebaseCloudService.fetchPhotos { photos in
            print("Fetched photos: \(photos)")
            
            // 例如只檢查不為 nil
            XCTAssertNotNil(photos, "Photos 不應該是 nil")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    // MARK: - 3) 測試 uploadAllPhotos
    func testUploadAllPhotos() {
        let expectation = self.expectation(description: "uploadAllPhotos")
        
        firebaseCloudService.uploadAllPhotos { success in
            XCTAssertTrue(success, "上傳照片應該回傳 true (成功)")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    // MARK: - 4) 測試 saveUserData / fetchUserData
    func testSaveAndFetchUserData() {
        let saveExp = expectation(description: "saveUserData")
        let fetchExp = expectation(description: "fetchUserData")
        
        let userID = "testUser123"
        let testData: [String: Any] = ["nickname": "Yoyo", "age": 25]
        
        // 先測試存
        firebaseCloudService.saveUserData(userID: userID, data: testData) { result in
            switch result {
            case .success():
                print("User data saved")
                saveExp.fulfill()
            case .failure(let error):
                XCTFail("saveUserData 失敗: \(error.localizedDescription)")
            }
        }
        
        wait(for: [saveExp], timeout: 5.0)
        
        // 再測試取
        firebaseCloudService.fetchUserData(userID: userID) { result in
            switch result {
            case .success(let dict):
                print("Fetch user data: \(dict)")
                // 假設要檢查資料是否跟存的相符
                XCTAssertEqual(dict["nickname"] as? String, "Yoyo")
                XCTAssertEqual(dict["age"] as? Int, 25)
                fetchExp.fulfill()
            case .failure(let error):
                XCTFail("fetchUserData 失敗: \(error.localizedDescription)")
            }
        }
        
        wait(for: [fetchExp], timeout: 5.0)
    }
    
    // MARK: - 5) 測試 sendOTP / signInWithOTP
    func testSendAndSignInWithOTP() {
        let sendExp = expectation(description: "sendOTP")
        let signInExp = expectation(description: "signInWithOTP")
        
        let dummyPhone = "0972516868"
        
        // 先測試 sendOTP
        firebaseCloudService.sendOTP(to: dummyPhone) { result in
            switch result {
            case .success(let verificationID):
                print("取得驗證 ID: \(verificationID)")
                XCTAssertFalse(verificationID.isEmpty, "verificationID 不應該是空")
                sendExp.fulfill()
                
                // 緊接著 signIn
                self.firebaseCloudService.signInWithOTP(verificationID: verificationID, verificationCode: "123456") { signInResult in
                    switch signInResult {
                    case .success():
                        print("SignInWithOTP 成功！")
                        signInExp.fulfill()
                    case .failure(let error):
                        XCTFail("signInWithOTP 失敗: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                XCTFail("sendOTP 失敗: \(error.localizedDescription)")
            }
        }
        
        // 等待兩個步驟都結束
        wait(for: [sendExp, signInExp], timeout: 10.0)
    }
}
