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

// 讓 DegreePicker 支援 ViewInspector 測試
extension DegreePicker: Inspectable {}

class DegreePickerUITests: XCTestCase {

    /// 測試點擊某個學歷按鈕時，binding 能正確更新
    func testDegreeSelectionUpdatesBinding() throws {
        // 初始狀態下未選擇學歷
        var selectedDegree: String? = nil
        let binding = Binding<String?>(
            get: { selectedDegree },
            set: { selectedDegree = $0 }
        )
        
        let degrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"]
        let view = DegreePicker(selectedDegree: binding, degrees: degrees)
        
        // 利用 ViewHosting 將 view 上線
        ViewHosting.host(view: view)
        
        // 使用 ViewInspector 找到包含文字 "學士" 的 Button 並模擬點擊
        let button = try view.inspect().find(button: "學士")
        try button.tap()

        // 檢查 binding 是否被更新為「學士」
        XCTAssertEqual(selectedDegree, "學士", "點擊『學士』按鈕後，綁定應更新為『學士』")
    }
    
    /// 測試點擊取消按鈕時，清空學歷選擇
    func testCancelClearsSelection() throws {
        // 初始狀態下已選擇「學士」
        var selectedDegree: String? = "學士"
        let binding = Binding<String?>(
            get: { selectedDegree },
            set: { selectedDegree = $0 }
        )
        
        let degrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"]
        let view = DegreePicker(selectedDegree: binding, degrees: degrees)
        
        ViewHosting.host(view: view)
        
        // 使用 ViewInspector 找到包含文字 "取消" 的 Button 並模擬點擊
        let cancelButton = try view.inspect().find(button: "取消")
        try cancelButton.tap()

        // 檢查 binding 是否被清空（nil）
        XCTAssertNil(selectedDegree, "點擊『取消』按鈕後，綁定應清空")
    }
    
    // 如果需要測試關閉按鈕（右上角的 x）則需模擬 presentationMode 環境，
    // 以及注入自定義的 AnalyticsManager（或覆寫 AnalyticsManager.shared）。
}
