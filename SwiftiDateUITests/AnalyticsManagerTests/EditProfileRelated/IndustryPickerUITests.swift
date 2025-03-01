//
//  IndustryPickerUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class IndustryPickerUITests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        // 利用 swizzling 攔截 AnalyticsManager.shared.trackEvent 呼叫
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testIndustryPickerAnalytics() throws {
        // 建立 binding，初始為 nil
        var selectedIndustry: String? = nil
        let binding = Binding<String?>(
            get: { selectedIndustry },
            set: { selectedIndustry = $0 }
        )
        
        // 定義測試用的行業選項
        let industries = ["科技", "醫療", "教育"]
        
        // 建立 IndustryPicker 並上線
        let view = IndustryPicker(selectedIndustry: binding, industries: industries)
        ViewHosting.host(view: view)
        
        // 驗證 onAppear 是否觸發 "industry_picker_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "industry_picker_view_appear" }),
                      "頁面曝光時應上報 industry_picker_view_appear 事件")
        
        // 模擬點擊「醫療」按鈕
        let medicalButton = try view.inspect().find(button: "醫療")
        try medicalButton.tap()
        XCTAssertEqual(selectedIndustry, "醫療", "點擊後，binding 應更新為 '醫療'")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "industry_selected" &&
            ($0.parameters?["industry"] as? String) == "醫療"
        }), "點擊 '醫療' 按鈕後應上報 industry_selected 事件")
        
        // 模擬點擊「清空」按鈕
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedIndustry, "點擊清空後，binding 應為 nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "industry_cleared" }),
                      "點擊清空後應上報 industry_cleared 事件")
    }
}
