//
//  LanguageSelectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class LanguageSelectionViewUITests: XCTestCase {
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
    
    func testLanguageSelectionAndActions() throws {
        // Initialize binding for selectedLanguages (initially empty)
        var selectedLanguages: [String] = []
        let binding = Binding<[String]>(
            get: { selectedLanguages },
            set: { selectedLanguages = $0 }
        )
        
        // Create LanguageSelectionView with the binding.
        let view = LanguageSelectionView(selectedLanguages: binding)
        ViewHosting.host(view: view)
        
        // --- Test selecting a language ---
        // 從 List 中取得 ForEach 內的第一個元素 (假設 "English" 是第一項)
        let englishHStack = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "English") != nil
        }
        try englishHStack.callOnTapGesture()

        XCTAssertTrue(selectedLanguages.contains("English"), "After tapping 'English', it should be selected.")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "language_selected" &&
            ($0.parameters?["language"] as? String) == "English"
        }), "Tapping 'English' should trigger language_selected event.")
        
        // --- Test deselecting the same language ---
        let englishHStack2 = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "English") != nil
        }
        try englishHStack2.callOnTapGesture()
        XCTAssertFalse(selectedLanguages.contains("English"), "Tapping 'English' again should deselect it.")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "language_deselected" &&
            ($0.parameters?["language"] as? String) == "English"
        }), "Deselecting 'English' should trigger language_deselected event.")
        
        // --- Test selecting multiple languages ---
        let chineseHStack = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "中文") != nil
        }
        try chineseHStack.callOnTapGesture()
        
        let japaneseHStack = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "日本語") != nil
        }
        try japaneseHStack.callOnTapGesture()
        
        XCTAssertTrue(selectedLanguages.contains("中文"), "After tapping '中文', it should be selected.")
        XCTAssertTrue(selectedLanguages.contains("日本語"), "After tapping '日本語', it should be selected.")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "language_selected" &&
            ($0.parameters?["language"] as? String) == "中文"
        }), "Selecting '中文' should trigger language_selected event.")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "language_selected" &&
            ($0.parameters?["language"] as? String) == "日本語"
        }), "Selecting '日本語' should trigger language_selected event.")
        
        // --- Test clearing all selections ---
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertTrue(selectedLanguages.isEmpty, "After tapping '清空', all selections should be cleared.")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "languages_cleared" }),
                      "Tapping '清空' should trigger languages_cleared event.")
        
        // --- Test confirming selections ---
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "languages_confirmed" &&
            ($0.parameters?["selected_count"] as? Int) == selectedLanguages.count
        }), "Tapping '確定' should trigger languages_confirmed event with correct selected count.")
    }
}
