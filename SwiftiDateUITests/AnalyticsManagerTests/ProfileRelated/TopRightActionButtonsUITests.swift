//
//  TopRightActionButtonsUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class TopRightActionButtonsUITests: XCTestCase {
    
    var analyticsSpy: AnalyticsSpy!
    @State private var showSettingsView = false
    @State private var showSafetyCenterView = false

    override func setUp() {
        super.setUp()
        // ✅ Swizzle AnalyticsManager 來監測事件
        analyticsSpy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testTopRightActionButtonsInteractions() throws {
        // 1️⃣ 建立要測試的視圖
        let view = TopRightActionButtons(
            showSettingsView: $showSettingsView,
            showSafetyCenterView: $showSafetyCenterView
        )
        
        // 2️⃣ 佈署到測試環境
        ViewHosting.host(view: view)

        // 3️⃣ 找到所有 Button
        let buttons = try view.inspect().findAll(ViewType.Button.self)
        XCTAssertEqual(buttons.count, 2, "應該有 2 個按鈕 (Shield + Settings)")

        // 🔹 測試「安全中心」按鈕
        let safetyButton = try buttons.first(where: {
            try $0.labelView().image().actualImage().name() == "shield.fill"
        })
        XCTAssertNotNil(safetyButton, "應該有一個 'shield.fill' 按鈕")
        
        try safetyButton?.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "top_right_safety_center_pressed"
            },
            "點擊 Safety Center 按鈕應觸發 top_right_safety_center_pressed 事件"
        )
        XCTAssertTrue(showSafetyCenterView, "點擊 Safety Center 按鈕後應設置 showSafetyCenterView = true")
        
        // 🔹 測試「設定」按鈕
        let settingsButton = try buttons.first(where: {
            try $0.labelView().image().actualImage().name() == "gearshape.fill"
        })
        XCTAssertNotNil(settingsButton, "應該有一個 'gearshape.fill' 按鈕")

        try settingsButton?.tap()
        
        XCTAssertTrue(
            analyticsSpy.trackedEvents.contains {
                $0.event == "top_right_settings_pressed"
            },
            "點擊 Settings 按鈕應觸發 top_right_settings_pressed 事件"
        )
        XCTAssertTrue(showSettingsView, "點擊 Settings 按鈕後應設置 showSettingsView = true")
    }
}
