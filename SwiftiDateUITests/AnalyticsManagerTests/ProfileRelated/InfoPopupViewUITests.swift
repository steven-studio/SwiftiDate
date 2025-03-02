//
//  InfoPopupViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class InfoPopupViewUITests: XCTestCase {
    
    var analyticsSpy: AnalyticsSpy!
    @State var isShowing = true
    
    override func setUp() {
        super.setUp()
        // Mock / Spy 用於檢測埋點
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testInfoPopupViewAppearEvent() throws {
        // 1) 建立要測試的視圖
        let view = InfoPopupView(isShowing: $isShowing, userRankPercentage: 75.4)

        // 2) 佈署到測試環境
        ViewHosting.host(view: view)

        // 3) 檢查是否有觸發 info_popup_view_appear 事件
        let appearExp = expectation(description: "等待畫面出現")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            appearExp.fulfill()
        }
        wait(for: [appearExp], timeout: 1)
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "info_popup_view_appear"
                && ($0.parameters?["user_rank_percentage"] as? Double) == 75.4
            },
            "應該觸發 info_popup_view_appear 事件，並帶有 user_rank_percentage: 75.4"
        )
    }
    
    func testCloseButtonTapped() throws {
        // 1) 建立要測試的視圖
        let view = InfoPopupView(isShowing: $isShowing, userRankPercentage: 75.4)

        // 2) 佈署到測試環境
        ViewHosting.host(view: view)

        // 3) 找到關閉按鈕（HStack 中的 Button）
        let hStack = try view.inspect().find(ViewType.HStack.self)
        let closeButton = try hStack.button(2) // 0 是標題，1 是 x 按鈕
        
        // 4) 模擬點擊關閉按鈕
        try closeButton.tap()

        // 5) 驗證 isShowing 變為 false
        XCTAssertFalse(isShowing, "點擊關閉按鈕後，isShowing 應變為 false")

        // 6) 驗證是否有埋點事件
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "info_popup_close_tapped" }),
            "點擊 X 按鈕應觸發 info_popup_close_tapped 事件"
        )
    }
    
    func testGetMoreExposureButtonTapped() throws {
        // 1) 建立要測試的視圖
        let view = InfoPopupView(isShowing: $isShowing, userRankPercentage: 75.4)

        // 2) 佈署到測試環境
        ViewHosting.host(view: view)

        // 3) 找到「獲得更多曝光的機會」按鈕
        let getMoreExposureButton = try view.inspect().find(ViewType.Button.self, where: {
            try $0.labelView().text().string() == "獲得更多曝光的機會"
        })

        // 4) 模擬點擊
        try getMoreExposureButton.tap()

        // 5) 驗證 isShowing 變為 false
        XCTAssertFalse(isShowing, "點擊『獲得更多曝光的機會』後，isShowing 應變為 false")

        // 6) 驗證是否有埋點事件
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains(where: { $0.event == "info_popup_get_more_exposure_tapped" }),
            "點擊『獲得更多曝光的機會』按鈕應觸發 info_popup_get_more_exposure_tapped 事件"
        )
    }
}
