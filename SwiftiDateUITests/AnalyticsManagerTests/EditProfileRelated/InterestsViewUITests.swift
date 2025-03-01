//
//  InterestsViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// 只在測試環境下使用
extension InterestsView {
    var isSheetPresented: Bool {
        // 暴露 showInterestSelection 的值，僅供測試使用
        Mirror(reflecting: self).descendant("showInterestSelection") as? Bool ?? false
    }
}

final class InterestsViewUITests: XCTestCase {
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
    
    func testInterestsViewAnalytics() throws {
        // 建立 binding 與測試資料
        var selectedInterests: Set<String> = ["閱讀", "運動"]
        var interestColors: [String: Color] = [
            "閱讀": .blue,
            "運動": .green,
            "音樂": .orange
        ]
        let bindingInterests = Binding<Set<String>>(
            get: { selectedInterests },
            set: { selectedInterests = $0 }
        )
        let bindingColors = Binding<[String: Color]>(
            get: { interestColors },
            set: { interestColors = $0 }
        )
        let interests = ["閱讀", "運動", "音樂", "旅行", "攝影", "美食"]
        
        // 建立 InterestsView 並上線
        let view = InterestsView(interests: interests, selectedInterests: bindingInterests, interestColors: bindingColors)
        ViewHosting.host(view: view)
        
        // 驗證 onAppear 觸發 "interests_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "interests_view_appear" }),
                      "頁面曝光時應上報 interests_view_appear 事件")
        
        // 模擬用戶點擊興趣區（附有 accessibilityIdentifier "InterestsTapArea"）
        let tapArea = try view.inspect().find(viewWithAccessibilityIdentifier: "InterestsTapArea")
        try tapArea.callOnTapGesture()
        
        // 等待狀態更新，讓 sheet 能夠呈現
        let exp = expectation(description: "等待 sheet 呈現")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
        
        // 驗證點擊後是否上報 "interest_selection_sheet_opened" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "interest_selection_sheet_opened" }),
                      "點擊興趣區後應上報 interest_selection_sheet_opened 事件")
    }
}
