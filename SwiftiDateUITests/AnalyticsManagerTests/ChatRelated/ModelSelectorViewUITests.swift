//
//  ModelSelectorViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class ModelSelectorViewUITests: XCTestCase {
    
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testModelSelectorView_AppearEventTracked() throws {
        // 建立測試視圖
        let view = ModelSelectorView(messages: .constant([]))
        ViewHosting.host(view: view)
        
        // 等待 UI 顯示
        let exp = expectation(description: "等待 UI 載入")
        DispatchQueue.main.async {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        
        // 檢查畫面加載是否記錄事件
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "model_selector_view_appear" }),
            "畫面顯示時應觸發 model_selector_view_appear 事件"
        )
    }
    
    func testModelSelection_TracksEventAndUpdatesUI() throws {
        let view = ModelSelectorView(messages: .constant([]))
        ViewHosting.host(view: view)
        
        // 取得所有按鈕 (LLM 模型選項)
        let buttons = try view.inspect().findAll(ViewType.Button.self)
        XCTAssertGreaterThan(buttons.count, 0, "應該至少有一個 LLM 模型按鈕")
        
        // 點擊第一個按鈕（例如 ChatGPT）
        let firstModelButton = buttons.first!
        try firstModelButton.tap()
        
        // 檢查是否記錄埋點事件
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains { $0.event == "model_selected" },
            "點擊模型應觸發 model_selected 事件"
        )
        
        // 檢查 UI 是否更新
        let selectedText = try view.inspect().find(text: "當前選擇的模型是：")
        XCTAssertNotNil(selectedText, "UI 應該更新顯示已選擇的模型")
    }
    
    func testContinueButton_NavigatesAndTracksEvent() throws {
        let view = ModelSelectorView(messages: .constant([]))
        ViewHosting.host(view: view)
        
        // 取得「繼續」按鈕
        let continueButton = try view.inspect().find(ViewType.Button.self, where: { try $0.labelView().text().string() == "繼續" })
        XCTAssertNotNil(continueButton, "應該有一個『繼續』按鈕")
        
        try continueButton.tap()
        
        // 檢查是否記錄 "continue_button_pressed" 事件
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains { $0.event == "continue_button_pressed" },
            "點擊『繼續』應觸發 continue_button_pressed 事件"
        )
        
        // 獲取 `ModelSelectorView` 本身
        let inspectedModelSelectorView = try view.inspect().find(ModelSelectorView.self).actualView()
        
        // 確認 NavigationLink 是否觸發
        XCTAssertTrue(
            inspectedModelSelectorView.navigateToChatGPT ||
            inspectedModelSelectorView.navigateToGemini ||
            inspectedModelSelectorView.navigateToClaude ||
            inspectedModelSelectorView.navigateToDeepSeek ||
            inspectedModelSelectorView.navigateToCustom,
            "點擊『繼續』應觸發 NavigationLink，導航至對應的 AI 模型畫面"
        )
    }
    
    func testRegionBasedModelFiltering() throws {
        let view = ModelSelectorView(messages: .constant([]))
        ViewHosting.host(view: view)
        
        // 取得地區篩選結果
        let region = detectRegion()
        let expectedModels = LLMModel.availableModels(for: region)
        
        // 取得篩選後的模型按鈕
        let buttons = try view.inspect().findAll(ViewType.Button.self)
        XCTAssertEqual(buttons.count, expectedModels.count, "應該根據地區篩選正確數量的 LLM 模型")
    }
}
