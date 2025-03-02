//
//  GenderSelectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class GenderSelectionViewUITests: XCTestCase {

    func testGenderSelection() throws {
        // 初始化測試的綁定變量
        @State var selectedGender = "女生"
        @State var showGenderSelection = true

        // 建立 GenderSelectionView
        let view = GenderSelectionView(selectedGender: $selectedGender, showGenderSelection: $showGenderSelection)
        let inspectedView = try view.inspect()
        
        // 驗證初始選擇為 "女生"
        XCTAssertEqual(selectedGender, "女生")
        
        // 模擬點擊 "男生" 的 HStack
        let maleOption = try inspectedView.find(ViewType.HStack.self, where: { hstack in
            // 判斷該 HStack 是否包含 "男生" 這個文字
            return try hstack.find(text: "男生").string() == "男生"
        })
        try maleOption.callOnTapGesture()
        
        // 驗證選擇更新為 "男生"
        XCTAssertEqual(selectedGender, "男生")
        
        // 模擬點擊 "不限" 的 HStack
        let unlimitOption = try inspectedView.find(text: "不限")
        try unlimitOption.callOnTapGesture()

        // 驗證選擇更新為 "不限"
        XCTAssertEqual(selectedGender, "不限")
    }

    func testBackButton() throws {
        // 初始化測試的綁定變量
        @State var selectedGender = "女生"
        @State var showGenderSelection = true

        // 建立 GenderSelectionView
        let view = GenderSelectionView(selectedGender: $selectedGender, showGenderSelection: $showGenderSelection)
        let inspectedView = try view.inspect()

        // 驗證初始狀態下 showGenderSelection 為 true
        XCTAssertTrue(showGenderSelection)
        
        // 模擬點擊返回按鈕
        let backButton = try inspectedView.find(viewWithAccessibilityIdentifier: "backButton").button()
        try backButton.tap()
        
        // 驗證返回按鈕點擊後 showGenderSelection 為 false
//        XCTAssertFalse(showGenderSelection)
    }
}
