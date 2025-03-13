//
//  HometownInputUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// 讓 HometownInputView 符合 Inspectable 協議
extension HometownInputView: Inspectable {}

final class HometownInputUITests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        // 使用 swizzling 攔截 AnalyticsManager.shared.trackEvent 呼叫
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testHometownInputViewAnalytics() throws {
        // 建立 binding，初始為 nil
        var selectedHometown: String? = nil
        let binding = Binding<String?>(
            get: { selectedHometown },
            set: { selectedHometown = $0 }
        )
        
        // 建立 HometownInputView 並上線
        let view = HometownInputView(selectedHometown: binding)
        ViewHosting.host(view: view)
        
        // 驗證 onAppear 觸發 "hometown_input_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "hometown_input_view_appear" }),
                      "頁面曝光時應上報 hometown_input_view_appear 事件")
        
        // 模擬使用者在文字欄位中輸入 "Taipei"
        let textField = try view.inspect().find(ViewType.TextField.self)
        try textField.setInput("Taipei")
        XCTAssertEqual(selectedHometown, "Taipei", "輸入後，binding 應更新為 'Taipei'")
        
        // 模擬點擊「確定」按鈕
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "hometown_confirmed" &&
            ($0.parameters?["hometown"] as? String) == "Taipei"
        }), "點擊確定後應上報 hometown_confirmed 事件，並傳入 'Taipei'")
        
        // 模擬點擊「清空」按鈕：
        // 先將 binding 設為 "Taipei"
        selectedHometown = "Taipei"
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedHometown, "點擊清空後，binding 應變為 nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "hometown_cleared" }),
                      "點擊清空後應上報 hometown_cleared 事件")
    }
}
