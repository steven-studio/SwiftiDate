//
//  AchievementSectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class AchievementSectionViewUITests: XCTestCase {

    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        // 如果您的專案用 AnalyticsManager + Spy 來觀察事件
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testAchievementSectionView() throws {
        // 1) 建立 EnvironmentObject: UserSettings
        let userSettings = UserSettings()
        userSettings.globalTurboCount = 10   // 範例
        userSettings.globalCrushCount = 5    // 範例
        userSettings.globalPraiseCount = 3   // 範例
        
        // 2) 建立 @State 變數，綁定給測試中的 View
        @State var showTurbo = false
        @State var showCrush = false
        @State var showPraise = false
        
        // 3) 建立要測試的 View，並注入 EnvironmentObject + Binding
        let view = AchievementSectionView(
            isShowingTurboPurchaseView: $showTurbo,
            isShowingCrushPurchaseView: $showCrush,
            isShowingPraisePurchaseView: $showPraise
        )
        .environmentObject(userSettings) // 注入
        
        // 4) 佈署到測試環境
        ViewHosting.host(view: view)
        
        // 5) 先拿到 HStack 裏的三個 AchievementCardView
        let inspectedView = try view.inspect()
        
        //  AchievementSectionView -> HStack(spacing:20)
        let hstack = try inspectedView.anyView().hStack()
        
        // 裡面有 3 個 AchievementCardView
        // 若階層有padding之類，需要先 .view(AchievementCardView.self, index)
        // 或用 findAll(AchievementCardView.self)
        let cards = try hstack.findAll(AchievementCardView.self)
        XCTAssertEqual(cards.count, 3, "應該有三個卡片 (Turbo/Crush/讚美)")
        
        // 檢查一下它們顯示的 title
        // 0: TURBO, 1: CRUSH, 2: 讚美
        let turboCard = cards[0]
        let crushCard = cards[1]
        let praiseCard = cards[2]
        
        // 5) **找到該視圖內的 Button，執行 .tap()**
        let turboButton = try turboCard.find(ViewType.Button.self)
        try turboButton.tap()
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "achievement_card_turbo_tapped" }),
            "點擊 TURBO 卡片後，應觸發 'achievement_card_turbo_tapped'"
        )
        XCTAssertTrue(showTurbo, "點擊 TURBO 卡片後，isShowingTurboPurchaseView 應該變 true")
        
        // 7) 測試點擊 CrushCard => "achievement_card_crush_tapped", showCrush = true
        let crushButton = try crushCard.find(ViewType.Button.self)
        try crushButton.tap()
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "achievement_card_crush_tapped" }),
            "點擊 CRUSH 卡片後，應觸發 'achievement_card_crush_tapped'"
        )
        XCTAssertTrue(showCrush, "點擊 CRUSH 卡片後，isShowingCrushPurchaseView 應該變 true")
        
        // 8) 測試點擊 讚美卡片 => "achievement_card_praise_tapped", showPraise = true
        try praiseCard.callOnTapGesture()
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "achievement_card_praise_tapped" }),
            "點擊 讚美 卡片後，應觸發 'achievement_card_praise_tapped'"
        )
        XCTAssertTrue(showPraise, "點擊 讚美 卡片後，isShowingPraisePurchaseView 應該變 true")
        
        // 如果還想測試 sheet 內的內容 (TurboPurchaseView / CrushPurchaseView / PraisePurchaseView)
        // 可以透過 ViewInspector 的 sheet() 取出對應子視圖做進一步測試
        // 不過由於 SwiftUI 同時只能顯示一個 .sheet
        // 建議分開測或在每次點擊前把另外兩個關掉 (showX = false)，否則sheet可能覆蓋。
    }
}
