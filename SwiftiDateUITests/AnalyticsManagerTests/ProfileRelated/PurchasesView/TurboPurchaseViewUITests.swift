//
//  TurboPurchaseViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// 若有 AnalyticsManager 需要替換或觀察事件，可使用 Mock / Spy
// 假設這裡已有一個 AnalyticsSpy 搭配 swizzleTrackEvent() / unswizzleTrackEvent() 做事件檢測

final class TurboPurchaseViewUITests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        // 建立 Spy 以便觀察事件
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testTurboPurchaseViewFlow() throws {
        // 建立要測試的視圖
        let view = TurboPurchaseView()
        
        // 佈署到測試環境
        ViewHosting.host(view: view)

        // 1. 驗證 onAppear => "turbo_purchase_view_appear"
        let appearExp = expectation(description: "等待畫面出現")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appearExp.fulfill()
        }
        wait(for: [appearExp], timeout: 1)
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains { $0.event == "turbo_purchase_view_appear" },
            "畫面出現時應上報 turbo_purchase_view_appear 事件"
        )
        
        // 2. 測試關閉 (右上角 X) => "turbo_purchase_view_dismissed"
        //   TurboPurchaseView 中最上層是一個 ZStack(alignment: .topLeading)
        //   其中包含一個 Button(action: ...) 來關閉
        // TurboPurchaseView 最外層是一個 VStack
        let vstack = try view.inspect().find(ViewType.VStack.self)
        
        // VStack 的第一個 child 是 ZStack (假設索引為 0)
        let zstack = try vstack.zStack(0)

        // 取得 ZStack 的第一個 Button (就是 X 按鈕)
        let closeButton = try zstack.button(1)

        // 點擊
        try closeButton.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains { $0.event == "turbo_purchase_view_dismissed" },
            "點擊 X 按鈕應觸發 turbo_purchase_view_dismissed 事件"
        )
        
        // 由於點擊後視圖可能被關閉，若要測試後續行為，需在關閉前先進行測試
        // 或採用另外一個測試函式，或移除 X 按鈕部份測試
        //
        // 以下示範：不先測 X 按鈕，而是在同一個測試中先測 Turbo 選項、再測關閉。
        
        // -----------------------------------------------------------
        // 如果想測試「選擇 Turbo 選項」與「立即獲取」按鈕：
        // 先不要馬上點擊 X 而是在點擊 X 前執行下列流程
        // -----------------------------------------------------------
        
        /*
        // 重新建立 View (因為剛剛已被關閉)
        let view = TurboPurchaseView()
        ViewHosting.host(view: view)

        let newAppearExp = expectation(description: "等待畫面再次出現")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            newAppearExp.fulfill()
        }
        wait(for: [newAppearExp], timeout: 1)

        // 驗證某個 TurboOptionView => 例如 "10 Turbo"
        // TurboPurchaseView 內有個 HStack 包了 3 個 TurboOptionView
        let hStack = try view.inspect().vStack().hStack(4) // 第四個 child 可能是 HStack, 具體索引可依實際階層
        let turboOptions = try hStack.findAll(TurboOptionView.self)
        
        // 假設第 0 個是 "10 Turbo"，第 1 個是 "5 Turbo"，第 2 個是 "1 Turbo"
        let firstOption = turboOptions[0]
        try firstOption.callOnTapGesture() // 模擬使用者點擊選擇 10 Turbo
        
        // 驗證事件 "turbo_option_selected" 並包含對應參數 "10 Turbo"
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "turbo_option_selected"
                && ($0.parameters?["option"] as? String) == "10 Turbo"
            },
            "點擊 10 Turbo 選項應觸發 turbo_option_selected 事件，參數應為 10 Turbo"
        )
        
        // 測試「立即獲取」按鈕 => "turbo_purchase_button_tapped"
        // 先尋找該按鈕
        let purchaseButton = try view.inspect().vStack().button(6) // 可能是第 6 個 child, 視結構而定
        try purchaseButton.tap()

        // 驗證事件 "turbo_purchase_button_tapped" => 參數 selected_option = "10 Turbo"
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "turbo_purchase_button_tapped"
                && ($0.parameters?["selected_option"] as? String) == "10 Turbo"
            },
            "點擊 '立即獲取' 按鈕應觸發 turbo_purchase_button_tapped 事件並帶入選擇的 Turbo 方案"
        )
        */

    }
}
