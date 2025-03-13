//
//  PetSelectionViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class PetSelectionViewUITests: XCTestCase {
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
    
    func testPetSelectionViewAnalyticsAndActions() throws {
        // Initialize binding for selectedPet (initially nil)
        var selectedPet: String? = nil
        let binding = Binding<String?>(
            get: { selectedPet },
            set: { selectedPet = $0 }
        )
        
        // Create PetSelectionView and host it
        let view = PetSelectionView(selectedPet: binding)
        ViewHosting.host(view: view)
        
        // Wait for onAppear to fire.
        let appearExp = expectation(description: "等待 onAppear 事件")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { appearExp.fulfill() }
        wait(for: [appearExp], timeout: 1)
        
        // Verify that onAppear triggers "pet_selection_view_appear"
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "pet_selection_view_appear" }),
                      "頁面曝光時應上報 pet_selection_view_appear 事件")
        
        // --- Test selecting an option (e.g., "養貓") ---
        let catButton = try view.inspect().find(button: "養貓")
        try catButton.tap()
        
        XCTAssertEqual(selectedPet, "養貓", "點擊 '養貓' 後 selectedPet 應更新為 '養貓'")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "pet_option_selected" &&
            ($0.parameters?["option"] as? String) == "養貓"
        }), "點擊 '養貓' 應上報 pet_option_selected 事件")
        
        // --- Test clearing selection ---
        let clearButton = try view.inspect().find(button: "清空")
        try clearButton.tap()
        XCTAssertNil(selectedPet, "點擊 '清空' 後 selectedPet 應為 nil")
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "pet_selection_cleared" }),
                      "點擊 '清空' 應上報 pet_selection_cleared 事件")
        
        // --- Test confirming selection ---
        // Manually set a selection before confirming
        selectedPet = "養狗"
        let confirmButton = try view.inspect().find(button: "確定")
        try confirmButton.tap()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "pet_selection_confirmed" &&
            ($0.parameters?["selected"] as? String) == "養狗"
        }), "點擊 '確定' 應上報 pet_selection_confirmed 事件，並傳入 '養狗'")
    }
}
