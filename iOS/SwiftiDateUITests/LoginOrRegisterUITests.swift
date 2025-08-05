//
//  LoginOrRegisterUITests.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/3.
//

import XCTest

final class LoginOrRegisterUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testPhotoUploadFlow() throws {
        let app = XCUIApplication()
        app.launch()

        // 假設你的按鈕 Accessibility ID 是 "uploadPhotoButton"
        let uploadButton = app.buttons["uploadPhotoButton"]
        XCTAssertTrue(uploadButton.waitForExistence(timeout: 5))
        uploadButton.tap()

        // 處理系統權限彈窗
        addUIInterruptionMonitor(withDescription: "System Dialog") { (alert) -> Bool in
            if alert.buttons["允許"].exists {
                alert.buttons["允許"].tap()
                return true
            }
            return false
        }
        app.tap() // 強制觸發 alert 處理

        // 因為無法真實存取相簿，此處建議以「內建假資料模式」進行測試
        // 在測試模式時，建議 app 內建自動選擇一張假照片來進行流程
    }
}
