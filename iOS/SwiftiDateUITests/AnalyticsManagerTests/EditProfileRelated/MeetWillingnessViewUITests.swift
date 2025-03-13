//
//  MeetWillingnessViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class MeetWillingnessViewUITests: XCTestCase {
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
    
    func testMeetWillingnessViewActions() throws {
        // Initialize bindings
        var isPresented: Bool = true
        var selectedOption: String? = nil
        
        let bindingIsPresented = Binding<Bool>(
            get: { isPresented },
            set: { isPresented = $0 }
        )
        let bindingSelected = Binding<String?>(
            get: { selectedOption },
            set: { selectedOption = $0 }
        )
        
        // Create the view and host it.
        let view = MeetWillingnessView(isPresented: bindingIsPresented, selectedOption: bindingSelected)
        ViewHosting.host(view: view)
        
        // Wait for onAppear to fire.
        let appearExp = expectation(description: "等待 onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { appearExp.fulfill() }
        wait(for: [appearExp], timeout: 1)
        
        // Verify that onAppear triggers "meet_willingness_view_appear"
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "meet_willingness_view_appear" }),
                      "OnAppear should trigger meet_willingness_view_appear event")
        
        // --- Test selecting an option ---
        // Locate the button for "期待立刻見面"
        let optionButton = try view.inspect().find(button: "期待立刻見面")
        try optionButton.tap()
        
        XCTAssertEqual(selectedOption, "期待立刻見面", "Selecting an option should update selectedOption")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "meet_option_selected" &&
            ($0.parameters?["option"] as? String) == "期待立刻見面"
        }), "Selecting an option should trigger meet_option_selected event")
        
        // --- Test clearing selection ---
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedOption, "Tapping '清空' should clear selectedOption")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "meet_willingness_cleared" }),
                      "Tapping '清空' should trigger meet_willingness_cleared event")
        
        // --- Test dismissing the view ---
        // Find the dismiss button by searching for the image with systemName "xmark"
        let dismissButton = try view.inspect().find(ViewType.Button.self) { button in
            return try button.accessibilityIdentifier() == "dismissButton"
        }
        try dismissButton.tap()
        
        XCTAssertFalse(isPresented, "Tapping dismiss should set isPresented to false")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "meet_willingness_view_dismissed" }),
                      "Tapping dismiss should trigger meet_willingness_view_dismissed event")
    }
}
