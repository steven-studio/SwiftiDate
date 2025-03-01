//
//  JobInputViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

extension JobInputView: Inspectable {}

final class JobInputViewUITests: XCTestCase {
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
    
    func testJobInputViewAnalyticsAndBinding() throws {
        // Initialize binding for selectedJob, initially nil.
        var selectedJob: String? = nil
        let binding = Binding<String?>(
            get: { selectedJob },
            set: { selectedJob = $0 }
        )
        
        // Create JobInputView and host it.
        let view = JobInputView(selectedJob: binding)
        ViewHosting.host(view: view)
        
        // Wait a short while to allow onAppear to fire.
        let appearExp = expectation(description: "Wait for onAppear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { appearExp.fulfill() }
        wait(for: [appearExp], timeout: 1)
        
        // Verify onAppear event triggered "job_input_view_appear"
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "job_input_view_appear" }),
                      "OnAppear should trigger job_input_view_appear event")
        
        // Simulate text input: set job to "軟體工程師"
        let textField = try view.inspect().find(ViewType.TextField.self)
        try textField.setInput("軟體工程師")
        XCTAssertEqual(selectedJob, "軟體工程師", "Binding should update to '軟體工程師'")
        
        // Simulate tapping the "清空" button.
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedJob, "After tapping 清空, binding should be nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "job_input_cleared" }),
                      "Tapping 清空 should trigger job_input_cleared event")
        
        // Set binding again before confirming.
        selectedJob = "軟體工程師"
        
        // Simulate tapping the "確定" button.
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "job_input_confirmed" &&
            ($0.parameters?["job"] as? String) == "軟體工程師"
        }), "Tapping 確定 should trigger job_input_confirmed event with job '軟體工程師'")
    }
}
