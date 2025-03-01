//
//  BasicInfoUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// 4) 撰寫測試
class BasicInfoUITests: XCTestCase {

    func testTapEditHometown() throws {
        // 準備 mock
        let mock = MockAnalyticsManager()
        
        // 準備 Binding (初始值)
        var mockHometown: String? = nil
        var showHometownInput = false
        
        let hometownBinding = Binding<String?>(
            get: { mockHometown },
            set: { mockHometown = $0 }
        )
        let showHometownBinding = Binding<Bool>(
            get: { showHometownInput },
            set: { showHometownInput = $0 }
        )

        // 其他 Binding 可以先填空或給個假值
        var selectedLanguages: [String] = []
        var showLanguageSelection = false
        var selectedHeight: Int? = nil
        var showHeightPicker = false
        var selectedZodiac: String = ""
        var showZodiacPicker = false
        var selectedBloodType: String? = nil
        var showBloodTypePicker = false

        // 建立 BasicInfoView，並傳入 mock analyticsManager
        let view = BasicInfoView(
            analyticsManager: mock,
            selectedHometown: hometownBinding,
            showHometownInput: showHometownBinding,
            selectedLanguages: .constant(selectedLanguages),
            showLanguageSelection: .constant(showLanguageSelection),
            selectedHeight: .constant(selectedHeight),
            showHeightPicker: .constant(showHeightPicker),
            selectedZodiac: .constant(selectedZodiac),
            showZodiacPicker: .constant(showZodiacPicker),
            selectedBloodType: .constant(selectedBloodType),
            showBloodTypePicker: .constant(showBloodTypePicker)
        )
        
        // 5) 用 ViewInspector 找到對應的 Row
        //    這裡 "來自" 是在 BasicInfoRowView
        //    看程式碼可知 "來自" 這行是一個 HStack
        //    你可以用 .findViewContaining("來自") 或 find(Text("來自")) ...
        let inspectedView = try view.inspect()
        let row = try inspectedView
            .find(viewWithId: "來自") // 這裡要在 BasicInfoRowView 裡自訂 .id("來自") 或 find(Text("來自"))
            .view(BasicInfoRowView<Image>.self)
        
        // 6) 對該 Row 做 tap 手勢
        let hStack = try inspectedView.find(ViewType.HStack.self)
        try hStack.callOnTapGesture()
        
        // 7) 驗證 Mock analytics
        XCTAssertEqual(mock.trackedEvents.count, 1, "應該要觸發一次 analytics 事件")
        XCTAssertEqual(mock.trackedEvents.first?.event, "tap_edit_hometown")

        // 8) 驗證 showHometownInput 是否被設為 true
        XCTAssertTrue(showHometownInput, "點擊之後應該顯示 hometown 輸入頁面")
    }
    
    // 測試「語言」 row
    func testTapEditLanguage() throws {
        let mock = MockAnalyticsManager()
        var selectedLanguages: [String] = []
        var showLanguageSelection = false
        
        let languagesBinding = Binding<[String]>(
            get: { selectedLanguages },
            set: { selectedLanguages = $0 }
        )
        let showLanguageBinding = Binding<Bool>(
            get: { showLanguageSelection },
            set: { showLanguageSelection = $0 }
        )
        
        let view = BasicInfoView(
            analyticsManager: mock,
            selectedHometown: .constant(nil),
            showHometownInput: .constant(false),
            selectedLanguages: languagesBinding,
            showLanguageSelection: showLanguageBinding,
            selectedHeight: .constant(nil),
            showHeightPicker: .constant(false),
            selectedZodiac: .constant(""),
            showZodiacPicker: .constant(false),
            selectedBloodType: .constant(nil),
            showBloodTypePicker: .constant(false)
        )
        
        let inspectedView = try view.inspect()
        let row = try inspectedView
            .find(viewWithId: "語言")
            .view(BasicInfoRowView<Image>.self)
        let hStack = try row.anyView().hStack()
        try hStack.callOnTapGesture()
        
        XCTAssertEqual(mock.trackedEvents.first?.event, "tap_edit_language")
        XCTAssertTrue(showLanguageSelection, "點擊『語言』 row 後，應該將 showLanguageSelection 設為 true")
    }

    // 測試「身高」 row
    func testTapEditHeight() throws {
        let mock = MockAnalyticsManager()
        var selectedHeight: Int? = nil
        var showHeightPicker = false
        
        let heightBinding = Binding<Int?>(
            get: { selectedHeight },
            set: { selectedHeight = $0 }
        )
        let showHeightBinding = Binding<Bool>(
            get: { showHeightPicker },
            set: { showHeightPicker = $0 }
        )
        
        let view = BasicInfoView(
            analyticsManager: mock,
            selectedHometown: .constant(nil),
            showHometownInput: .constant(false),
            selectedLanguages: .constant([]),
            showLanguageSelection: .constant(false),
            selectedHeight: heightBinding,
            showHeightPicker: showHeightBinding,
            selectedZodiac: .constant(""),
            showZodiacPicker: .constant(false),
            selectedBloodType: .constant(nil),
            showBloodTypePicker: .constant(false)
        )
        
        let inspectedView = try view.inspect()
        let row = try inspectedView
            .find(viewWithId: "身高")
            .view(BasicInfoRowView<Image>.self)
        let hStack = try row.anyView().hStack()
        try hStack.callOnTapGesture()

        XCTAssertEqual(mock.trackedEvents.first?.event, "tap_edit_height")
        XCTAssertTrue(showHeightPicker, "點擊『身高』 row 後，應該將 showHeightPicker 設為 true")
    }

    // 測試「星座」 row
    func testTapEditZodiac() throws {
        let mock = MockAnalyticsManager()
        var selectedZodiac: String = ""
        var showZodiacPicker = false
        
        let zodiacBinding = Binding<String>(
            get: { selectedZodiac },
            set: { selectedZodiac = $0 }
        )
        let showZodiacBinding = Binding<Bool>(
            get: { showZodiacPicker },
            set: { showZodiacPicker = $0 }
        )
        
        let view = BasicInfoView(
            analyticsManager: mock,
            selectedHometown: .constant(nil),
            showHometownInput: .constant(false),
            selectedLanguages: .constant([]),
            showLanguageSelection: .constant(false),
            selectedHeight: .constant(nil),
            showHeightPicker: .constant(false),
            selectedZodiac: zodiacBinding,
            showZodiacPicker: showZodiacBinding,
            selectedBloodType: .constant(nil),
            showBloodTypePicker: .constant(false)
        )
        
        let inspectedView = try view.inspect()
        let row = try inspectedView
            .find(viewWithId: "星座")
            .view(BasicInfoRowView<Image>.self)
        let hStack = try row.anyView().hStack()
        try hStack.callOnTapGesture()

        XCTAssertEqual(mock.trackedEvents.first?.event, "tap_edit_zodiac")
        XCTAssertTrue(showZodiacPicker, "點擊『星座』 row 後，應該將 showZodiacPicker 設為 true")
    }

    // 測試「血型」 row
    func testTapEditBloodType() throws {
        let mock = MockAnalyticsManager()
        var selectedBloodType: String? = nil
        var showBloodTypePicker = false
        
        let bloodTypeBinding = Binding<String?>(
            get: { selectedBloodType },
            set: { selectedBloodType = $0 }
        )
        let showBloodTypeBinding = Binding<Bool>(
            get: { showBloodTypePicker },
            set: { showBloodTypePicker = $0 }
        )
        
        let view = BasicInfoView(
            analyticsManager: mock,
            selectedHometown: .constant(nil),
            showHometownInput: .constant(false),
            selectedLanguages: .constant([]),
            showLanguageSelection: .constant(false),
            selectedHeight: .constant(nil),
            showHeightPicker: .constant(false),
            selectedZodiac: .constant(""),
            showZodiacPicker: .constant(false),
            selectedBloodType: bloodTypeBinding,
            showBloodTypePicker: showBloodTypeBinding
        )
        
        let inspectedView = try view.inspect()
        let row = try inspectedView
            .find(viewWithId: "血型")
            .view(BasicInfoRowView<Image>.self)
        let hStack = try row.anyView().hStack()
        try hStack.callOnTapGesture()

        XCTAssertEqual(mock.trackedEvents.first?.event, "tap_edit_blood_type")
        XCTAssertTrue(showBloodTypePicker, "點擊『血型』 row 後，應該將 showBloodTypePicker 設為 true")
    }
}
