//
//  FitnessOptionsUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class FitnessOptionsUITests: XCTestCase {
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
    
    func testFitnessOptionsAnalytics() throws {
        // 建立 binding，初始為 nil
        var selectedOption: String? = nil
        let binding = Binding<String?>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        // 建立 FitnessOptionsView 並上線
        let view = FitnessOptionsView(selectedFitnessOption: binding)
        ViewHosting.host(view: view)
        
        // 驗證 onAppear 是否觸發 "fitness_options_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "fitness_options_view_appear" }),
                      "應在畫面出現時觸發 fitness_options_view_appear 事件")
        
        // 模擬點擊「經常健身」按鈕
        let frequentButton = try view.inspect().find(button: "經常健身")
        try frequentButton.tap()
        XCTAssertEqual(selectedOption, "經常健身", "點擊後，binding 應更新為 '經常健身'")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "fitness_option_selected" &&
            ($0.parameters?["option"] as? String) == "經常健身"
        }), "點擊『經常健身』後應上報 fitness_option_selected 事件")
        
        // 模擬點擊「清空」按鈕
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedOption, "點擊清空後，binding 應為 nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "fitness_option_cleared" }),
                      "點擊清空後應上報 fitness_option_cleared 事件")
        
        // 模擬再次點擊某個選項，例如「有時候」
        let sometimesButton = try view.inspect().find(button: "有時候")
        try sometimesButton.tap()
        XCTAssertEqual(selectedOption, "有時候", "點擊後，binding 應更新為 '有時候'")
        
        // 模擬點擊「確定」按鈕
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "fitness_option_confirmed" &&
            ($0.parameters?["option"] as? String) == "有時候"
        }), "點擊確定後應上報 fitness_option_confirmed 事件，並傳入所選選項")
        
        // 注意：因為 view.dismiss() 的行為無法在測試環境中直接驗證，
        // 這邊僅針對 Analytics 事件和 binding 的變化進行驗證。
    }
}
