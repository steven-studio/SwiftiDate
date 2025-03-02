//
//  ProfileTabPickerUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

// Extend ProfileTabPicker to make it inspectable.
extension ProfileTabPicker: Inspectable {}

final class ProfileTabPickerUITests: XCTestCase {
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
    
    // Test that onAppear fires the "profile_tab_picker_view_appear" event.
    func testOnAppear() throws {
        let selectedTab = Binding<ProfileTab>(
            get: { .edit },
            set: { _ in }
        )
        let view = ProfileTabPicker(selectedTab: selectedTab)
        ViewHosting.host(view: view)
        
        // Wait briefly for onAppear to trigger
        let exp = expectation(description: "Wait for onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { exp.fulfill() }
        wait(for: [exp], timeout: 1)
        
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { $0.event == "profile_tab_picker_view_appear" },
                      "ProfileTabPicker should trigger profile_tab_picker_view_appear event on appear")
    }
    
    // Test that changing the tab triggers the "profile_tab_changed" event with the correct parameter.
    func testTabChangeEvent() throws {
        // Use a mutable variable to track the selected tab.
        var tab: ProfileTab = .edit
        let selectedTab = Binding<ProfileTab>(
            get: { tab },
            set: { tab = $0 }
        )
        let view = ProfileTabPicker(selectedTab: selectedTab)
        ViewHosting.host(view: view)
        
        XCTAssertEqual(tab, ProfileTab.edit, "The binding value should be updated to .preview")
        
        // Change the tab value to .preview.
//        selectedTab.wrappedValue = .preview
        
        // Since onChange is attached to the Binding, we need to trigger an inspection to simulate the change.
        // For example, by accessing the picker:
        let picker = try view.inspect().find(ViewType.Picker.self)
        // Call onChange (if needed, ViewInspector automatically triggers onChange when the binding changes).
        try picker.select(value: ProfileTab.preview)
        
//        selectedTab.wrappedValue = .preview
        
        // 檢查綁定變數是否更新
        XCTAssertEqual(tab, ProfileTab.preview, "The binding value should be updated to .preview")
        
        // 延遲 0.2 秒以等待 onChange 被觸發
        let exp = expectation(description: "等待 onChange 執行")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
        
        // Verify that the analytics event "profile_tab_changed" is fired with parameter "preview".
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "profile_tab_changed" &&
            (event.parameters?["selected_tab"] as? String) == ProfileTab.preview.rawValue
        }, "Changing the tab should trigger profile_tab_changed event with the correct parameter")
    }
}
