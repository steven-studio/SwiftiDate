//
//  PraisePurchaseViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class PraisePurchaseViewUITests: XCTestCase {
    
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        // 將 AnalyticsManager 以 Spy 注入 (若您的專案使用 swizzle 方式)
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testPraisePurchaseViewFlow() throws {
        // 1) 建立要測試的視圖
        let view = PraisePurchaseView()
        
        // 2) 佈署到測試環境 (由 ViewInspector 處理)
        ViewHosting.host(view: view)
        
        // 3) 驗證 onAppear => "praise_purchase_view_appear"
        //    因為 onAppear 可能是非同步呼叫，加點延遲或直接等待下一個RunLoop
        let appearExp = expectation(description: "等待畫面出現")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appearExp.fulfill()
        }
        wait(for: [appearExp], timeout: 1.0)
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "praise_purchase_view_appear" }),
            "畫面出現時應上報 praise_purchase_view_appear 事件"
        )
        
        // 4) 測試關閉 (右上角 X) => "praise_purchase_view_dismissed"
        //    PraisePurchaseView 最外層是一個 VStack，其 child(0) 是 ZStack
        //    其中 ZStack 的 child(1) 就是那顆 Button(X)
        
        let vstack = try view.inspect().find(ViewType.VStack.self)
        let zstack = try vstack.zStack(0)
        
        let closeButton = try zstack.button(1) // 第0個是Image, 第1個是Button
        try closeButton.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "praise_purchase_view_dismissed" }),
            "點擊 X 按鈕應觸發 praise_purchase_view_dismissed 事件"
        )
        
        // 由於點擊 X 之後視圖會被 dismiss，後面操作可能無法執行
        // 通常建議「測試關閉」 與 「測試選擇方案 & 購買按鈕」分成不同的 test func
    }
    
    func testPraiseOptionSelectionAndPurchase() throws {
        // 1) 重新建立 View（不要先點 X，否則視圖會關閉）
        let view = PraisePurchaseView()
        ViewHosting.host(view: view)
        
        // 2) 找到 VStack 裏面的 HStack => PraiseOptionView
        let vstack = try view.inspect().find(ViewType.VStack.self)
        let hstack = try vstack.find(ViewType.HStack.self)
        
        // 拿到所有的 PraiseOptionView
        let praiseOptions = try hstack.findAll(PraiseOptionView.self)
        XCTAssertEqual(praiseOptions.count, 3, "應該有 3 種讚美方案")
        
        // 假設 0: "60次讚美", 1: "30次讚美", 2: "5次讚美"
        let firstOption = praiseOptions[0]
        
        // 目前程式沒有在選取時發事件, 只更新 selectedOption
        // 若想測試「事件」，可在 onSelect 裡面加 trackEvent
        
        // 3) 模擬點擊 "60次讚美" => 更新父視圖的 @State
        //    同樣需要進入到實際掛 .onTapGesture 的子視圖 (VStack)
        let optionVStack = try firstOption.vStack()
        try optionVStack.callOnTapGesture()
        
        // 若您要驗證 state 真的更新為 "60次讚美"
        // 必須用 ViewInspector 的 actualView() 抓 SwiftUI 內部實例
        // 1) 在整個樹狀中尋找 PraisePurchaseView (若在外面包了一層 NavigationView 或 HostingController, 可能要多解開)
        let customView = try view.inspect().view(PraisePurchaseView.self, 0)

        // 2) 從 customView 取出真正的 SwiftUI 實例
        let actualPraiseView = try customView.actualView()

        // 確認 selectedOption 是否變成 "60次讚美"
//        XCTAssertEqual(actualPraiseView.selectedOption, "60次讚美", "點擊後 selectedOption 應為 60次讚美")
        
        // 4) 測試「立即獲取」按鈕 => "praise_purchase_button_tapped"
        //    同樣在 vstack 裡面，通常是最後一個 Button
        let allButtons = try vstack.findAll(ViewType.Button.self)
        guard let purchaseButton = allButtons.last else {
            XCTFail("未找到購買按鈕")
            return
        }
        
        try purchaseButton.tap()
        
        // 驗證是否發出了 "praise_purchase_button_tapped" 並帶正確參數
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "praise_purchase_button_tapped"
                && ($0.parameters?["selected_option"] as? String) == "60次讚美"
            },
            "點擊 '立即獲取' 按鈕應觸發 praise_purchase_button_tapped 並帶入選擇的 60次讚美"
        )
    }
}
