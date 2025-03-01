//
//  LifestyleViewUITests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class LifestyleViewUITests: XCTestCase {
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
    
    func testLifestyleViewAnalytics() throws {
        // 建立綁定與初始狀態
        var selectedLookingFor: String? = nil
        var showLookingForView: Bool = false
        var selectedPet: String? = nil
        var showPetSelectionView: Bool = false
        var selectedFitnessOption: String? = nil
        var showFitnessOptions: Bool = false
        var selectedSmokingOption: String? = nil
        var showSmokingOptions: Bool = false
        var selectedDrinkOption: String? = nil
        var showDrinkOptions: Bool = false
        var selectedVacationOption: String? = nil
        var showVacationOptions: Bool = false
        var selectedDietPreference: String? = nil
        var showDietPreferences: Bool = false
        
        let bindingLookingFor = Binding<String?>(get: { selectedLookingFor }, set: { selectedLookingFor = $0 })
        let bindingShowLookingFor = Binding<Bool>(get: { showLookingForView }, set: { showLookingForView = $0 })
        let bindingSelectedPet = Binding<String?>(get: { selectedPet }, set: { selectedPet = $0 })
        let bindingShowPet = Binding<Bool>(get: { showPetSelectionView }, set: { showPetSelectionView = $0 })
        let bindingFitnessOption = Binding<String?>(get: { selectedFitnessOption }, set: { selectedFitnessOption = $0 })
        let bindingShowFitness = Binding<Bool>(get: { showFitnessOptions }, set: { showFitnessOptions = $0 })
        let bindingSmokingOption = Binding<String?>(get: { selectedSmokingOption }, set: { selectedSmokingOption = $0 })
        let bindingShowSmoking = Binding<Bool>(get: { showSmokingOptions }, set: { showSmokingOptions = $0 })
        let bindingDrinkOption = Binding<String?>(get: { selectedDrinkOption }, set: { selectedDrinkOption = $0 })
        let bindingShowDrink = Binding<Bool>(get: { showDrinkOptions }, set: { showDrinkOptions = $0 })
        let bindingVacationOption = Binding<String?>(get: { selectedVacationOption }, set: { selectedVacationOption = $0 })
        let bindingShowVacation = Binding<Bool>(get: { showVacationOptions }, set: { showVacationOptions = $0 })
        let bindingDietPreference = Binding<String?>(get: { selectedDietPreference }, set: { selectedDietPreference = $0 })
        let bindingShowDiet = Binding<Bool>(get: { showDietPreferences }, set: { showDietPreferences = $0 })
        
        // 建立 LifestyleView 並上線
        let view = LifestyleView(
            selectedLookingFor: bindingLookingFor,
            showLookingForView: bindingShowLookingFor,
            selectedPet: bindingSelectedPet,
            showPetSelectionView: bindingShowPet,
            selectedFitnessOption: bindingFitnessOption,
            showFitnessOptions: bindingShowFitness,
            selectedSmokingOption: bindingSmokingOption,
            showSmokingOptions: bindingShowSmoking,
            selectedDrinkOption: bindingDrinkOption,
            showDrinkOptions: bindingShowDrink,
            selectedVacationOption: bindingVacationOption,
            showVacationOptions: bindingShowVacation,
            selectedDietPreference: bindingDietPreference,
            showDietPreferences: bindingShowDiet
        )
        ViewHosting.host(view: view)
        
        // 驗證 onAppear 觸發 "lifestyle_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_view_appear" }),
                      "頁面曝光時應上報 lifestyle_view_appear 事件")
        
        // 模擬點擊各個 LifestyleRowView：
        // 1. "想找" 行
        let lookingForRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "想找") != nil
        }
        try lookingForRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_lookingfor_tapped" }),
                      "點擊 '想找' 應上報 lifestyle_lookingfor_tapped 事件")
        
        // 2. "寵物" 行
        let petRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "寵物") != nil
        }
        try petRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_pet_tapped" }),
                      "點擊 '寵物' 應上報 lifestyle_pet_tapped 事件")
        
        // 3. "健身" 行
        let fitnessRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "健身") != nil
        }
        try fitnessRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_fitness_tapped" }),
                      "點擊 '健身' 應上報 lifestyle_fitness_tapped 事件")
        
        // 4. "抽煙" 行
        let smokingRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "抽煙") != nil
        }
        try smokingRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_smoking_tapped" }),
                      "點擊 '抽煙' 應上報 lifestyle_smoking_tapped 事件")
        
        // 5. "喝酒" 行
        let drinkRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "喝酒") != nil
        }
        try drinkRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_drink_tapped" }),
                      "點擊 '喝酒' 應上報 lifestyle_drink_tapped 事件")
        
        // 6. "休假日" 行
        let vacationRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "休假日") != nil
        }
        try vacationRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_vacation_tapped" }),
                      "點擊 '休假日' 應上報 lifestyle_vacation_tapped 事件")
        
        // 7. "飲食習慣" 行
        let dietRow = try view.inspect().find(ViewType.HStack.self) { hStack in
            return try hStack.find(text: "飲食習慣") != nil
        }
        try dietRow.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "lifestyle_diet_tapped" }),
                      "點擊 '飲食習慣' 應上報 lifestyle_diet_tapped 事件")
    }
}
