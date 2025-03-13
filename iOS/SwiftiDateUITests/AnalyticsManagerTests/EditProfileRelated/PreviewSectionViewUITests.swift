//
//  PreviewSectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class PreviewSectionViewUITests: XCTestCase {
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
    
    func testPreviewSectionViewOnAppear() throws {
        // 設定初始測試數據
        let photos = ["photo1", "photo2", "photo3"]
        let bindingPhotos = Binding<[String]>(
            get: { photos },
            set: { _ in }
        )
        let bindingIndex = Binding<Int>(
            get: { 0 },
            set: { _ in }
        )
        let aboutMe = "測試關於我"
        let selectedZodiac = "獅子座"
        let selectedJob: String? = "軟體工程師"
        
        let view = PreviewSectionView(
            photos: bindingPhotos,
            currentPhotoIndex: bindingIndex,
            aboutMe: aboutMe,
            selectedZodiac: selectedZodiac,
            selectedJob: selectedJob
        ).environmentObject(UserSettings())
        
        ViewHosting.host(view: view)
        
        // 等待 onAppear 執行
        let exp = expectation(description: "等待 onAppear 執行")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        
        // 驗證 onAppear 上報事件，並確認照片數量參數正確
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "preview_section_view_appear" &&
            (event.parameters?["photo_count"] as? Int) == photos.count
        }, "OnAppear 應上報 preview_section_view_appear 事件且傳入正確的 photo_count")
    }
    
    func testPhotoNavigation() throws {
        // 測試左右點擊切換照片
        var currentIndex = 1
        let photos = ["photo1", "photo2", "photo3", "photo4"]
        let bindingPhotos = Binding<[String]>(
            get: { photos },
            set: { _ in }
        )
        let bindingIndex = Binding<Int>(
            get: { currentIndex },
            set: { currentIndex = $0 }
        )
        let view = PreviewSectionView(
            photos: bindingPhotos,
            currentPhotoIndex: bindingIndex,
            aboutMe: "Test AboutMe",
            selectedZodiac: "處女座",
            selectedJob: "工程師"
        ).environmentObject(UserSettings())
        ViewHosting.host(view: view)
        
        // 模擬右半部點擊：currentIndex 應增加（若未達到上限）
        let geometryReader = try view.inspect().find(ViewType.GeometryReader.self)
        // 取得 GeometryReader 內的 HStack (左右區塊)
        let hStack = try geometryReader.find(ViewType.HStack.self)
        let rightTapArea = try view.inspect().find(viewWithAccessibilityIdentifier: "rightTapArea")
        try rightTapArea.callOnTapGesture()
        XCTAssertEqual(currentIndex, 2, "點擊右側後 currentPhotoIndex 應增加")
        
        // 驗證 Analytics 是否上報 "preview_section_photo_next"
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "preview_section_photo_next" &&
            (event.parameters?["new_index"] as? Int) == currentIndex
        }, "點擊右側應上報 preview_section_photo_next 事件")
        
        // 模擬左側點擊：currentIndex 應遞減
        let leftTapArea = try view.inspect().find(viewWithAccessibilityIdentifier: "leftTapArea")
        try leftTapArea.callOnTapGesture()
        XCTAssertEqual(currentIndex, 1, "點擊左側後 currentPhotoIndex 應遞減")
        
        // 驗證 Analytics 是否上報 "preview_section_photo_previous"
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "preview_section_photo_previous" &&
            (event.parameters?["new_index"] as? Int) == currentIndex
        }, "點擊左側應上報 preview_section_photo_previous 事件")
    }
}
