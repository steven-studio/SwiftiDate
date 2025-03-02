//
//  CrushPurchaseViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class CrushPurchaseViewUITests: XCTestCase {
    
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        // 若您的專案有 AnalyticsManager，需要 swizzle（Mock/Spy）來擷取事件
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        // 解除 swizzle
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testCrushPurchaseViewFlow() throws {
        // 1) 建立要測試的視圖
        let view = CrushPurchaseView()
        
        // 2) 佈署到測試環境
        ViewHosting.host(view: view)
        
        // （若要測試 onAppear => "crush_purchase_view_appear"，先在 CrushPurchaseView 裡加上 .onAppear { AnalyticsManager.shared.trackEvent("crush_purchase_view_appear") }）
        // 不做 onAppear 測試的話，可以省略此步。
        
        // 3) 測試關閉 (右上角 X) => "crush_purchase_view_dismissed"
        //    根據 CrushPurchaseView，最外層是一個 VStack，其 child(0) 是 ZStack
        //    其中 ZStack 的 child(1) 就是那顆 Button(X)
        
        let vstack = try view.inspect().find(ViewType.VStack.self)
        let zstack = try vstack.zStack(0)          // CrushPurchaseView.body 的第一個子視圖
        let closeButton = try zstack.button(1)     // 其中第 0 個是 Image，1 是 Button
        try closeButton.tap()                      // 模擬使用者點擊 X
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "crush_purchase_view_dismissed" }),
            "點擊 X 按鈕應觸發 crush_purchase_view_dismissed 事件"
        )
        
        // 由於一旦點擊 X 按鈕，視圖通常就被關閉，後續測試可能無法繼續操作。
        // 建議將「X 按鈕測試」與「選擇方案 / 購買按鈕」分成不同測試函式。
        // 下方示範如果想先測方案與購買，再測 X 按鈕，就要調整測試順序。
    }
    
    func testCrushOptionsAndPurchaseButton() throws {
        // 如果想測試「選擇 Crush 套餐」與「立即擁有」按鈕，建議用另一個測試函式，不先點 X。
        
        // 1) 建立要測試的視圖
        let view = CrushPurchaseView()
        
        // 2) 佈署到測試環境
        ViewHosting.host(view: view)
        
        // 3) 找到 VStack → 其中包含 HStack (裡面有 3 個 CrushOptionView)
        let vstack = try view.inspect().find(ViewType.VStack.self)
        
        // 推測可能是 Spacer、Text、HStack、Button… 不同 child index 視實際結構而定
        // 您可以先用 `print(try vstack.dump())` 觀察階層
        // 或直接用 find(ViewType.HStack.self)
        
        let hstack = try vstack.find(ViewType.HStack.self)
        let crushOptions = try hstack.findAll(CrushOptionView.self)
        
        XCTAssertEqual(crushOptions.count, 3, "應該有 3 種 Crush 套餐")
        
        // 假設 0: "60 Crushes", 1: "30 Crushes", 2: "5 Crushes"
        let firstOption = crushOptions[0]

        // 先解開它內部的 VStack
        let optionVStack = try firstOption.anyView().vStack()

        // 對這個 VStack 呼叫 tap
        try optionVStack.callOnTapGesture()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "crush_option_selected"
                && ($0.parameters?["option"] as? String) == "60 Crushes"
            },
            "點擊 60 Crushes 選項應觸發 crush_option_selected 事件，參數應為 60 Crushes"
        )
        
        // 4) 測試「立即擁有」按鈕 => "crush_purchase_button_tapped"
        //    VStack 的最後一個子視圖應該是購買 Button
        //    也可用 .find(ViewType.Button.self, where: { try $0.labelView().text().string() == "立即擁有" })
        
        let purchaseButton = try vstack.findAll(ViewType.Button.self).last // 拿最後一個按鈕
        try purchaseButton?.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "crush_purchase_button_tapped"
                && ($0.parameters?["selected_option"] as? String) == "60 Crushes"
            },
            "點擊 '立即擁有' 按鈕應觸發 crush_purchase_button_tapped 事件並帶入選擇的 Crush 方案"
        )
    }
}
