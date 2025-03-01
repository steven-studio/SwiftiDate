//
//  DegreePickerUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

class DegreePickerUITests: XCTestCase {

    /// 測試點擊某個學歷按鈕時，binding 能正確更新
    func testDegreeSelectionUpdatesBinding() throws {
        // 建立 mock analytics 替身
        let mock = MockAnalyticsManager()
        
        // 初始狀態下未選擇學歷
        var selectedDegree: String? = nil
        let binding = Binding<String?>(
            get: { selectedDegree },
            set: { selectedDegree = $0 }
        )
        
        let degrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"]
        // 注意：此處必須確保 DegreePicker 能夠接受傳入的 analyticsManager
        let view = DegreePicker(analyticsManager: mock, selectedDegree: binding, degrees: degrees)

        // 利用 ViewHosting 將 view 上線
        ViewHosting.host(view: view)
        
        // 使用 ViewInspector 找到包含文字 "學士" 的 Button 並模擬點擊
        let button = try view.inspect().find(button: "學士")
        try button.tap()

        // 驗證 Analytics：應該觸發 "degree_selected" 事件，並傳入 "學士" 參數
        XCTAssertEqual(mock.trackedEvents.count, 2, "應該要觸發二次 analytics 事件")
        if let event = mock.trackedEvents.first(where: { $0.event == "degree_selected" }) {
            XCTAssertEqual(event.parameters?["degree"] as? String, "學士", "傳入的學歷參數錯誤")
        } else {
            XCTFail("沒有觸發 degree_selected 事件")
        }
    }
    
    /// 測試點擊取消按鈕時，清空學歷選擇
    func testCancelClearsSelection() throws {
        let mock = MockAnalyticsManager()
        
        // 初始狀態下已選擇「學士」
        var selectedDegree: String? = "學士"
        let binding = Binding<String?>(
            get: { selectedDegree },
            set: { selectedDegree = $0 }
        )
        
        let degrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"]
        let view = DegreePicker(analyticsManager: mock, selectedDegree: binding, degrees: degrees)

        ViewHosting.host(view: view)
        
        // 使用 ViewInspector 找到包含文字 "取消" 的 Button 並模擬點擊
        let cancelButton = try view.inspect().find(button: "取消")
        try cancelButton.tap()

        // 驗證 Analytics：應該觸發 "degree_selection_canceled" 事件
        XCTAssertEqual(mock.trackedEvents.count, 2, "取消操作應該觸發一次 analytics 事件")
        if let event = mock.trackedEvents.first(where: { $0.event == "degree_selection_canceled" }) {
            XCTAssertEqual(event.event, "degree_selection_canceled", "取消時觸發的事件名稱錯誤")
        }
    }
    
    // 如果需要測試關閉按鈕（右上角的 x）則需模擬 presentationMode 環境，
    // 以及注入自定義的 AnalyticsManager（或覆寫 AnalyticsManager.shared）。
}
