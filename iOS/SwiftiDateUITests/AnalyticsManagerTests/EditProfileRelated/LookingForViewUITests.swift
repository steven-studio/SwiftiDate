//
//  LookingForViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class LookingForViewUITests: XCTestCase {
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
    
    func testLookingForViewAnalyticsAndActions() throws {
        // 建立 binding，初始為 nil
        var selectedLookingFor: String? = nil
        let binding = Binding<String?>(
            get: { selectedLookingFor },
            set: { selectedLookingFor = $0 }
        )
        
        // 建立 LookingForView 並上線
        let view = LookingForView(selectedLookingFor: binding)
        ViewHosting.host(view: view)
        
        // 等待 onAppear 觸發
        let exp = expectation(description: "等待 onAppear 事件")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        
        // 驗證 onAppear 是否觸發 "lookingfor_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lookingfor_view_appear" }),
                      "頁面曝光時應上報 lookingfor_view_appear 事件")
        
        // --- Test selecting an option (e.g. "終身伴侶") ---
        // 直接搜尋包含 "終身伴侶" 的 Button，然後呼叫 tap()
        let partnerButton = try view.inspect().find(button: "終身伴侶")
        try partnerButton.tap()

        XCTAssertEqual(selectedLookingFor, "終身伴侶", "點擊後 selectedLookingFor 應為 '終身伴侶'")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "lookingfor_option_selected" &&
            ($0.parameters?["option"] as? String) == "終身伴侶"
        }), "點擊 '終身伴侶' 應觸發 lookingfor_option_selected 事件")
        
        // --- Test clearing selection ---
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedLookingFor, "點擊 '清空' 後，selectedLookingFor 應為 nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lookingfor_cleared" }),
                      "點擊 '清空' 應觸發 lookingfor_cleared 事件")
        
        // --- Test confirming selection ---
        // 直接搜尋包含 "穩定的關係" 的 Button，然後呼叫 tap()
        let stableButton = try view.inspect().find(button: "穩定的關係")
        try stableButton.tap()
        XCTAssertEqual(selectedLookingFor, "穩定的關係", "點擊後 selectedLookingFor 應為 '穩定的關係'")

        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "lookingfor_confirmed" &&
            ($0.parameters?["selected"] as? String) == "穩定的關係"
        }), "點擊 '確定' 應觸發 lookingfor_confirmed 事件，並傳入 '穩定的關係'")
    }
}
