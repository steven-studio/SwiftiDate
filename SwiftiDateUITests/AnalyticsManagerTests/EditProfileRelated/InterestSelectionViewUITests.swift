//
//  InterestSelectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class InterestSelectionViewUITests: XCTestCase {
    
    var selectedInterests: Set<String>!
    var interestColors: [String: Color]!
    
    override func setUp() {
        super.setUp()
        // 初始測試用的資料
        selectedInterests = []
        interestColors = [:]
    }
    
    override func tearDown() {
        selectedInterests = nil
        interestColors = nil
        super.tearDown()
    }
    
    func testTagSelection() throws {
        // 建立 InterestSelectionView 並上線
        let view = InterestSelectionView(
            selectedInterests: Binding<Set<String>>(
                get: { self.selectedInterests },
                set: { self.selectedInterests = $0 }
            ),
            interestColors: Binding<[String: Color]>(
                get: { self.interestColors },
                set: { self.interestColors = $0 }
            )
        )
        ViewHosting.host(view: view)
        
        // 假設 InterestSelectionView 中的 SectionView 會呈現 "閱讀" 這個標籤
        let tagText = try view.inspect().find(text: "閱讀")
        // 模擬點擊該標籤
        try tagText.callOnTapGesture()
        
        // 驗證點擊後，selectedInterests 應包含 "閱讀"
        XCTAssertTrue(selectedInterests.contains("閱讀"), "點擊後應選中 '閱讀'")
        
        // 驗證 interestColors 中對應 "閱讀" 的顏色有被設置
        XCTAssertNotNil(interestColors["閱讀"], "選中 '閱讀' 後，interestColors 應有對應顏色")
    }
    
    func testOnAppearAnalytics() throws {
        // 建立 AnalyticsSpy 並透過 swizzling 擷取事件
        let spy = AnalyticsSpy()
        AnalyticsManager.swizzleTrackEvent(with: spy)
        
        let view = InterestSelectionView(
            selectedInterests: Binding<Set<String>>(
                get: { self.selectedInterests },
                set: { self.selectedInterests = $0 }
            ),
            interestColors: Binding<[String: Color]>(
                get: { self.interestColors },
                set: { self.interestColors = $0 }
            )
        )
        ViewHosting.host(view: view)
        
        // 等待 onAppear 事件觸發
        let exp = expectation(description: "等待 onAppear 事件")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        // 驗證 onAppear 是否上報 "interest_selection_view_appear" 事件
        XCTAssertTrue(spy.trackedEvents.contains(where: { $0.event == "interest_selection_view_appear" }),
                      "onAppear 應上報 interest_selection_view_appear 事件")
        
        AnalyticsManager.unswizzleTrackEvent()
    }
}
