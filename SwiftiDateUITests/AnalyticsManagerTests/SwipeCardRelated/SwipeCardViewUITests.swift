//
//  SwipeCardViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class SwipeCardViewUITests: XCTestCase {
//
//    func testSwipeCardView_UIElements() throws {
//        let userSettings = UserSettings()
//        let view = SwipeCardView().environmentObject(userSettings)
//
//        let inspectedView = try view.inspect()
//        
//        // 測試是否有卡片存在
//        XCTAssertNoThrow(try inspectedView.find(SwipeCard.self), "應該找到至少一張 SwipeCard")
//
//        // 確保 UI 上有 "xmark" 按鈕 (Dislike)
//        XCTAssertNoThrow(try inspectedView.find(ViewType.Image.self, where: {
//            try $0.image().actualName() == "xmark"
//        }), "應該找到 xmark 按鈕")
//
//        // 確保 UI 上有 "heart.fill" 按鈕 (Like)
//        XCTAssertNoThrow(try inspectedView.find(ViewType.Image.self, where: {
//            try $0.image().name() == "heart.fill"
//        }), "應該找到 heart.fill 按鈕")
//    }
//
//    func testSwipeRight_Like() throws {
//        let userSettings = UserSettings()
//        let view = SwipeCardView().environmentObject(userSettings)
//
//        let inspectedView = try view.inspect()
//        
//        let firstCard = try inspectedView.find(SwipeCard.self)
//        XCTAssertNotNil(firstCard, "應該有卡片可供滑動")
//
//        // 模擬右滑 (Like)
//        try firstCard.gesture(DragGesture.self).callOnEnded(
//            DragGesture.Value(time: Date(), location: CGPoint(x: 300, y: 0), translation: CGSize(width: 200, height: 0))
//        )
//
//        // 檢查 globalLikeCount 是否遞增
//        XCTAssertTrue(userSettings.globalLikeCount > 0, "右滑後 globalLikeCount 應該遞增")
//    }
//
//    func testSwipeLeft_Dislike() throws {
//        let userSettings = UserSettings()
//        let view = SwipeCardView().environmentObject(userSettings)
//
//        let inspectedView = try view.inspect()
//        
//        let firstCard = try inspectedView.find(SwipeCard.self)
//        XCTAssertNotNil(firstCard, "應該有卡片可供滑動")
//
//        // 模擬左滑 (Dislike)
//        try firstCard.gesture(DragGesture.self).callOnEnded(
//            DragGesture.Value(time: Date(), location: CGPoint(x: -300, y: 0), translation: CGSize(width: -200, height: 0))
//        )
//
//        // 確保用戶跳到下一張卡
//        let newCard = try inspectedView.find(SwipeCard.self)
//        XCTAssertNotEqual(firstCard, newCard, "左滑後應該切換到下一張卡片")
//    }
//
//    func testUndoSwipe() throws {
//        let userSettings = UserSettings()
//        let view = SwipeCardView().environmentObject(userSettings)
//
//        let inspectedView = try view.inspect()
//        
//        let firstCard = try inspectedView.find(SwipeCard.self)
//        XCTAssertNotNil(firstCard, "應該有卡片可供滑動")
//
//        // 模擬右滑 (Like)
//        try firstCard.gesture(DragGesture.self).callOnEnded(
//            DragGesture.Value(time: Date(), location: CGPoint(x: 300, y: 0), translation: CGSize(width: 200, height: 0))
//        )
//
//        // 確保 globalLikeCount 增加
//        XCTAssertTrue(userSettings.globalLikeCount > 0, "右滑後 globalLikeCount 應該遞增")
//
//        // 模擬撤回滑動
//        NotificationCenter.default.post(name: .undoSwipeNotification, object: nil)
//
//        // 確保 globalLikeCount 變回原值
//        XCTAssertEqual(userSettings.globalLikeCount, 0, "撤回後 globalLikeCount 應該回到初始值")
//    }
//
//    func testPrivacySettingsButton() throws {
//        let userSettings = UserSettings()
//        let view = SwipeCardView().environmentObject(userSettings)
//
//        let inspectedView = try view.inspect()
//
//        // 點擊右上角 "slider.horizontal.3" 按鈕
//        let button = try inspectedView.find(ViewType.Button.self, where: {
//            try $0.labelView().image().name() == "slider.horizontal.3"
//        })
//        try button.tap()
//
//        // 檢查是否顯示 PrivacySettingsView
//        XCTAssertTrue(view.showPrivacySettings, "點擊按鈕後應該顯示 PrivacySettingsView")
//    }
}
