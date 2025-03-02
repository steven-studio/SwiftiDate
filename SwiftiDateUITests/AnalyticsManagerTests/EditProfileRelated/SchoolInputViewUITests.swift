//
//  SchoolInputViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class SchoolInputViewUITests: XCTestCase {
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
    
    func testSchoolInputViewAnalyticsAndActions() throws {
        // Initialize the binding for selectedSchool (initially nil)
        var selectedSchool: String? = nil
        let binding = Binding<String?>(
            get: { selectedSchool },
            set: { selectedSchool = $0 }
        )
        
        // Create the SchoolInputView and host it
        let view = SchoolInputView(selectedSchool: binding)
        ViewHosting.host(view: view)
        
        // Wait briefly for onAppear to trigger
        let appearExp = expectation(description: "Wait for onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { appearExp.fulfill() }
        wait(for: [appearExp], timeout: 1)
        
        // Verify that onAppear triggers "school_input_view_appear" event
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { $0.event == "school_input_view_appear" },
                      "SchoolInputView should trigger school_input_view_appear on appear")
        
        // --- Test updating the text field ---
        // Find the TextField and simulate user input "Test School"
        let textField = try view.inspect().find(ViewType.TextField.self)
        try textField.setInput("Test School")
        
        // Verify that the binding has been updated
        XCTAssertEqual(selectedSchool, "Test School", "Binding should update to 'Test School'")
        
        // --- Test confirming the input ---
        // Find and tap the "確定" button
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        
        // Verify that the analytics event "school_input_confirmed" is fired with the correct parameter
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "school_input_confirmed" &&
            (event.parameters?["school"] as? String) == "Test School"
        }, "Tapping '確定' should trigger school_input_confirmed event with correct school value")
        
        // --- Test clearing the input ---
        // Reset the binding to simulate existing input before clearing
        selectedSchool = "Another School"
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        
        // Verify that the binding is cleared (i.e., nil)
        XCTAssertNil(selectedSchool, "Tapping '清空' should clear selectedSchool")
        
        // Verify that the analytics event "school_input_cleared" is fired
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "school_input_cleared"
        }, "Tapping '清空' should trigger school_input_cleared event")
    }
}
