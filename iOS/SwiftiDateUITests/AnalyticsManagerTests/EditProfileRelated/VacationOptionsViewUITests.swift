//
//  VacationOptionsViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/2.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class VacationOptionsViewUITests: XCTestCase {
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
    
    func testVacationOptionsViewAnalyticsAndActions() throws {
        // Prepare initial binding (with nil selection).
        var selectedVacationOption: String? = nil
        let binding = Binding<String?>(
            get: { selectedVacationOption },
            set: { selectedVacationOption = $0 }
        )
        
        // Create the VacationOptionsView.
        let view = VacationOptionsView(selectedVacationOption: binding)
        ViewHosting.host(view: view)
        
        // Wait briefly for onAppear to trigger.
        let appearExp = expectation(description: "Wait for onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { appearExp.fulfill() }
        wait(for: [appearExp], timeout: 1)
        
        // Verify that onAppear fires "vacation_options_view_appear".
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "vacation_options_view_appear"
        }, "VacationOptionsView should trigger vacation_options_view_appear event on appear")
        
        // --- Test selecting an option (e.g. "週末休息") ---
        let weekendButton = try view.inspect().find(button: "週末休息")
        try weekendButton.tap()
        
        XCTAssertEqual(selectedVacationOption, "週末休息", "Selecting '週末休息' should update the binding")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "vacation_option_selected" &&
            (event.parameters?["option"] as? String) == "週末休息"
        }, "Selecting '週末休息' should trigger vacation_option_selected event")
        
        // --- Test clearing selection ---
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedVacationOption, "Tapping '清空' should clear the selection")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "vacation_option_cleared"
        }, "Tapping '清空' should trigger vacation_option_cleared event")
        
        // --- Test confirming selection ---
        // First, select another option (e.g. "時間自己掌控").
        let timeControlButton = try view.inspect().find(button: "時間自己掌控")
        try timeControlButton.tap()
        XCTAssertEqual(selectedVacationOption, "時間自己掌控", "Selecting '時間自己掌控' should update the binding")
        
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains { event in
            event.event == "vacation_option_confirmed" &&
            (event.parameters?["option"] as? String) == "時間自己掌控"
        }, "Tapping '確定' should trigger vacation_option_confirmed event with the selected option")
    }
}
