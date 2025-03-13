//
//  OTPVerificationUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/2/26.
//

import XCTest

final class OTPVerificationUITests: XCTestCase {
    func testOTPFlow() throws {
        // 1) 建立 XCUIApplication
        let app = XCUIApplication()
        app.launchArguments.append("-UI_TEST_MODE")
        app.launchArguments.append("-RESET_STATE") // 這行代表要重置狀態
        app.launch()
        
        // 透過 accessibilityIdentifier 找到註冊按鈕
        let registerButton = app.buttons["RegisterButton"]
        XCTAssertTrue(registerButton.exists, "找不到 RegisterButton")
        
        // 模擬點擊註冊按鈕的操作
        registerButton.tap()
        
        // 確認是否成功切換到電話號碼輸入頁面
        // 例如可以檢查該頁面的某個元素：
        let phoneEntryField = app.textFields["PhoneNumberTextField"]
        XCTAssertTrue(phoneEntryField.waitForExistence(timeout: 5), "電話號碼輸入頁面未出現")
        
        // 2) 點擊並輸入完整電話號碼
        phoneEntryField.tap()
        phoneEntryField.typeText("0972516868")
        
        // 4) 找到「繼續」按鈕並點擊
        let continueButton = app.buttons["ContinueButton"]
        XCTAssertTrue(continueButton.exists, "找不到 ContinueButton")
        continueButton.tap()
        
        // 5) 等待 Alert 出現後，點擊「確定」以進入 OTP 驗證頁面
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "沒有找到任何 Alert")

        alert.buttons["確定"].tap()
        
        print(app.debugDescription)

        // 6) 進入 OTP 驗證畫面 → 找到 6 個輸入框依序輸入數字
        for i in 0..<6 {
            let digitField = app.textFields["OTPTextField\(i)"]
            XCTAssertTrue(digitField.exists, "找不到 OTPTextField\(i)")
            digitField.tap()
            digitField.typeText("\(i)")  // 輸入 i
        }

        // 7) 驗證是否有成功跳轉或顯示某個元素
        XCTAssertTrue(app.staticTexts["Welcome"].exists)
    }
}
