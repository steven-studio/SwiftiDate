//
//  SmokingOptionsViewUITests.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class SmokingOptionsViewUITests: XCTestCase {
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
    
    // Test selecting a smoking option.
    func testSmokingOptionSelection() throws {
        // Initialize binding (initially nil)
        var selectedOption: String? = nil
        let binding = Binding<String?>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        let view = SmokingOptionsView(selectedSmokingOption: binding)
        ViewHosting.host(view: view)
        
        // Simulate tapping the "不抽煙" button.
        let optionButton = try view.inspect().find(button: "不抽煙")
        try optionButton.tap()
        
        // Verify that the binding is updated and analytics event is fired.
        XCTAssertEqual(selectedOption, "不抽煙", "Tapping '不抽煙' should update selectedSmokingOption binding")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "smoking_option_selected" &&
            (event.parameters?["option"] as? String) == "不抽煙"
        }, "Tapping '不抽煙' should trigger smoking_option_selected event")
    }
    
    // Test the clear button functionality.
    func testClearButton() throws {
        // Start with a non-nil binding value.
        var selectedOption: String? = "經常"
        let binding = Binding<String?>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        let view = SmokingOptionsView(selectedSmokingOption: binding)
        ViewHosting.host(view: view)
        
        // Find and tap the "清空" button.
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        
        // Verify that the binding is cleared and the correct event is fired.
        XCTAssertNil(selectedOption, "Tapping '清空' should clear the selectedSmokingOption binding")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "smoking_option_cleared"
        }, "Tapping '清空' should trigger smoking_option_cleared event")
    }
    
    // Test the confirm button functionality.
    func testConfirmButton() throws {
        // Set a sample value.
        var selectedOption: String? = "在喝酒時抽煙"
        let binding = Binding<String?>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        let view = SmokingOptionsView(selectedSmokingOption: binding)
        ViewHosting.host(view: view)
        
        // Find and tap the "確定" button.
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        
        // Verify that the correct analytics event is fired with the expected parameter.
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "smoking_option_confirmed" &&
            (event.parameters?["option"] as? String) == "在喝酒時抽煙"
        }, "Tapping '確定' should trigger smoking_option_confirmed event with the correct parameter")
    }
}
