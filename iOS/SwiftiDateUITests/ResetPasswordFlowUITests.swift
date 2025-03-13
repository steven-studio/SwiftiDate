//
//  ResetPasswordFlowUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest

final class ResetPasswordFlowUITests: XCTestCase {
    func testRegisterToResetPasswordFlow() throws {
        // 1. 建立並啟動應用程式
        let app = XCUIApplication()
        app.launchArguments.append("-UI_TEST_MODE")
        app.launchArguments.append("-SKIP_FIREBASE_CHECK")
        app.launch()
        
        // 2. 從註冊畫面點擊 RegisterButton
        let registerButton = app.buttons["RegisterButton"]
        XCTAssertTrue(registerButton.waitForExistence(timeout: 5), "找不到 RegisterButton")
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
        
        // 3. 假設註冊後會進入 PasswordLoginView，找到「忘記密碼？」按鈕
        let forgotPasswordButton = app.buttons["ForgotPasswordButton"]
        XCTAssertTrue(forgotPasswordButton.waitForExistence(timeout: 5), "找不到 ForgotPasswordButton")
        forgotPasswordButton.tap()
        
        // 4. 現在應該進入 OTPVerificationView，模擬輸入 6 位驗證碼
        for i in 0..<6 {
            let otpField = app.textFields["OTPTextField\(i)"]
            XCTAssertTrue(otpField.waitForExistence(timeout: 5), "找不到 OTPTextField\(i)")
            otpField.tap()
            otpField.typeText("\(i)")
        }
        
        // 5. 點擊驗證按鈕
        let verifyButton = app.buttons["VerifyOTPButton"]
        XCTAssertTrue(verifyButton.waitForExistence(timeout: 5), "找不到 VerifyOTPButton")
        verifyButton.tap()
        
        // 6. 驗證完成後，應該跳轉到 ResetPasswordView，檢查是否出現「更換新密碼」文字
        let resetPasswordTitle = app.staticTexts["更換新密碼"]
        XCTAssertTrue(resetPasswordTitle.waitForExistence(timeout: 5), "ResetPasswordView 未出現")
    }
}
