//
//  AboutMeSectionUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// 測試替身
class MockAnalyticsManager: AnalyticsManagerProtocol {
    var trackedEvents: [(event: String, parameters: [String: Any]?)] = []
    
    func trackEvent(_ event: String, parameters: [String: Any]?) {
        trackedEvents.append((event: event, parameters: parameters))
    }
}

// 擴展 AboutMeSection 讓它可被 ViewInspector 測試
extension AboutMeSection: Inspectable {}

class AboutMeSectionTests: XCTestCase {
    
    func testAboutMeChangeTriggersAnalyticsEvent() throws {
        // 建立 mock 替身
        let mock = MockAnalyticsManager()

        // 準備一個 Binding
        var aboutMeValue = ""
        let aboutMeBinding = Binding<String>(
            get: { aboutMeValue },
            set: { aboutMeValue = $0 }
        )
        
        // 傳入 mock analyticsManager
        let view = AboutMeSection(aboutMe: aboutMeBinding, analyticsManager: mock)
        
        // 使用 ViewInspector 取得 TextEditor 並模擬文字變化
        let vstack = try view.inspect().find(ViewType.VStack.self)
        let textEditor = try vstack.textEditor(1) // 根據你的 VStack 結構，索引可能需要調整
        try textEditor.callOnChange(newValue: "Hello, world!")

        // 檢查 mock 是否收到了正確的事件
        XCTAssertEqual(mock.trackedEvents.count, 1)
        let event = mock.trackedEvents.first!
        XCTAssertEqual(event.event, "aboutme_changed")
        if let length = event.parameters?["length"] as? Int {
            XCTAssertEqual(length, "Hello, world!".count)
        } else {
            XCTFail("缺少 'length' 參數")
        }
    }
}
