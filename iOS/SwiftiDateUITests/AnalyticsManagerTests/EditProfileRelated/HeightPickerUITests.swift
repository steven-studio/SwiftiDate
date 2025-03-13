//
//  HeightPickerUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// 讓 HeightPickerView 符合 Inspectable 協議
extension HeightPickerView: Inspectable {}

final class HeightPickerUITests: XCTestCase {
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
    
    func testHeightPickerViewAnalytics() throws {
        // 建立 binding，初始為 nil
        var selectedHeight: Int? = nil
        let binding = Binding<Int?>(
            get: { selectedHeight },
            set: { selectedHeight = $0 }
        )
        
        // 建立 HeightPickerView 並上線
        let view = HeightPickerView(selectedHeight: binding)
        ViewHosting.host(view: view)
        
        // 模擬設定身高，假設用戶選擇 180 cm
        selectedHeight = 180
        
        // 模擬點擊「確定」按鈕
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        
        // 驗證 Analytics 是否上報 "update_height" 事件，且傳入身高為 180
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "update_height" &&
            ($0.parameters?["height"] as? Int) == 180
        }), "點擊『確定』後應上報 update_height 事件，並傳入身高 180")
        
        // 模擬點擊「清空」按鈕：先將 selectedHeight 設為其他值
        selectedHeight = 175
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        
        // 驗證點擊「清空」後 binding 是否變為 nil
        XCTAssertNil(selectedHeight, "點擊『清空』後，binding 應變為 nil")
    }
}
