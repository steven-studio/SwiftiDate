//
//  ZodiacPickerViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class ZodiacPickerViewUITests: XCTestCase {
    // 我們會用到一個模擬的 analytics manager（或 spy）來確認事件是否有被上報
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        // 將 AnalyticsManager 的 trackEvent 函式動態替換成 spy
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        // 測試結束時，將 trackEvent 還原
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testZodiacPickerViewOnAppear() throws {
        // 建立一個綁定的星座變數（預設空字串或任何值）
        var selectedZodiac: String = ""
        let binding = Binding<String>(
            get: { selectedZodiac },
            set: { selectedZodiac = $0 }
        )
        
        // 建立並顯示 ZodiacPickerView
        let view = ZodiacPickerView(selectedZodiac: binding)
        ViewHosting.host(view: view)
        
        // 等待 onAppear 執行
        let exp = expectation(description: "等待 onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        // 驗證 onAppear 是否有上報事件 "zodiac_picker_view_appear"
        XCTAssertTrue(analyticsSpy.trackedEvents.contains {
            $0.event == "zodiac_picker_view_appear"
        }, "進入頁面時，應該上報 'zodiac_picker_view_appear' 事件")
    }
    
    func testZodiacSelected() throws {
        var selectedZodiac: String = ""
        let binding = Binding<String>(
            get: { selectedZodiac },
            set: { selectedZodiac = $0 }
        )
        
        let view = ZodiacPickerView(selectedZodiac: binding)
        ViewHosting.host(view: view)
        
        // 測試用戶點擊某個星座（以 "巨蟹座" 為例）
        let button = try view.inspect().find(
            // 找到包含「巨蟹座」文字的 Button
            ViewType.Button.self, where: {
                // 透過檢查 button 的 text 是否為「巨蟹座」
                let text = try? $0.labelView().find(ViewType.Text.self).string()
                return text == "巨蟹座"
            }
        )
        // 模擬點擊
        try button.tap()
        
        // 驗證 selectedZodiac 是否更新為 "巨蟹座"
        XCTAssertEqual(selectedZodiac, "巨蟹座", "點擊「巨蟹座」後，selectedZodiac 應更新為「巨蟹座」")
        
        // 驗證是否上報 "zodiac_selected" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains {
            $0.event == "zodiac_selected" &&
            ($0.parameters?["zodiac"] as? String) == "巨蟹座"
        }, "選擇「巨蟹座」後，應該上報 'zodiac_selected' 事件並包含該星座參數")
    }
    
    func testClearZodiac() throws {
        var selectedZodiac: String = "獅子座"
        let binding = Binding<String>(
            get: { selectedZodiac },
            set: { selectedZodiac = $0 }
        )
        
        let view = ZodiacPickerView(selectedZodiac: binding)
        ViewHosting.host(view: view)
        
        // 找到「清空」按鈕
        let clearButton = try view.inspect().find(
            ViewType.Button.self, where: {
                let text = try? $0.labelView().find(ViewType.Text.self).string()
                return text == "清空"
            }
        )
        try clearButton.tap()
        
        // 驗證 selectedZodiac 是否被清空
        XCTAssertEqual(selectedZodiac, "", "點擊『清空』後，selectedZodiac 應被設為空字串")
        
        // 驗證是否上報 "zodiac_cleared" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains {
            $0.event == "zodiac_cleared"
        }, "清空星座後應上報 'zodiac_cleared' 事件")
    }
    
    func testConfirmZodiac() throws {
        var selectedZodiac: String = "雙魚座"
        let binding = Binding<String>(
            get: { selectedZodiac },
            set: { selectedZodiac = $0 }
        )
        
        let view = ZodiacPickerView(selectedZodiac: binding)
        ViewHosting.host(view: view)
        
        // 找到「確定」按鈕
        let confirmButton = try view.inspect().find(
            ViewType.Button.self, where: {
                let text = try? $0.labelView().find(ViewType.Text.self).string()
                return text == "確定"
            }
        )
        try confirmButton.tap()
        
        // 驗證事件 "zodiac_picker_confirm" 是否被上報
        XCTAssertTrue(analyticsSpy.trackedEvents.contains {
            $0.event == "zodiac_picker_confirm"
        }, "點擊『確定』後應上報 'zodiac_picker_confirm' 事件")
    }
}
