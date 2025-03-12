//
//  TurboPurchaseFlowUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/12.
//

import Foundation
import XCTest

class TurboPurchaseFlowUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }

    func testTurboPurchaseFlow() {
        // 1. 等待並點擊「以此帳號登錄」按鈕以跳過登入畫面
        let continueButton = app.buttons["以此帳號登錄"]
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: continueButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        continueButton.tap()
        
        let tabBarButtons = app.tabBars.buttons.allElementsBoundByIndex
        for button in tabBarButtons {
            print("Tab button label: \(button.label)")
        }
        
        // 假設進入 MainView 時預設的 selectedTab 為 0
        // 先等待 MainView 載入完畢
        let profileTabButton = app.tabBars.buttons["person.fill"]
        expectation(for: existsPredicate, evaluatedWith: profileTabButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)

        // 模擬點擊 Profile 頁籤
        profileTabButton.tap()
        
        // 模擬用戶進入 Turbo Purchase 頁面
        app.buttons["AdaptiveAchievementCard_GetMoreButton_TURBO"].tap() // 假設你的導覽按鈕標題為 "Turbo"
        
        let optionButton = app.buttons["TurboOption_5 Turbo"]
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: optionButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        optionButton.tap()
        
        // 模擬點擊立即獲取按鈕
        app.buttons["立即獲取"].tap()
        
        // 驗證在 StoreKit 測試環境中，購買流程是否正確處理
        // 例如，檢查是否出現了購買成功或交易狀態更新的提示訊息
        // 這邊可以用 app.staticTexts["購買成功"] 或其他標識進行驗證
        let successLabel = app.staticTexts["購買成功"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: successLabel, handler: nil)
        waitForExpectations(timeout: 10, handler: nil)
        
        XCTAssertTrue(successLabel.exists, "Turbo 購買流程應該顯示成功提示")
    }
}
