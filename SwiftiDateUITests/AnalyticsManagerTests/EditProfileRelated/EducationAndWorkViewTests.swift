//
//  EducationAndWorkViewTests.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/1.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import SwiftiDate

final class EducationAndWorkViewTests: XCTestCase {
    var analyticsSpy: AnalyticsSpy!
    
    override func setUp() {
        super.setUp()
        analyticsSpy = AnalyticsSpy()
        // 利用 swizzling 攔截 AnalyticsManager.shared.trackEvent 呼叫
        AnalyticsManager.swizzleTrackEvent(with: analyticsSpy)
    }
    
    override func tearDown() {
        AnalyticsManager.unswizzleTrackEvent()
        analyticsSpy = nil
        super.tearDown()
    }
    
    func testEducationAndWorkViewAnalytics() throws {
        // 建立綁定變數
        var selectedDegree: String? = nil
        var selectedSchool: String? = nil
        var selectedIndustry: String? = nil
        var selectedJob: String? = nil
        
        var showDegreePicker = false
        var showSchoolInput = false
        var showIndustryPicker = false
        var showJobInput = false
        
        // 建立 Binding
        let bindingDegree = Binding<String?>(get: { selectedDegree }, set: { selectedDegree = $0 })
        let bindingSchool = Binding<String?>(get: { selectedSchool }, set: { selectedSchool = $0 })
        let bindingIndustry = Binding<String?>(get: { selectedIndustry }, set: { selectedIndustry = $0 })
        let bindingJob = Binding<String?>(get: { selectedJob }, set: { selectedJob = $0 })
        
        let bindingShowDegree = Binding<Bool>(get: { showDegreePicker }, set: { showDegreePicker = $0 })
        let bindingShowSchool = Binding<Bool>(get: { showSchoolInput }, set: { showSchoolInput = $0 })
        let bindingShowIndustry = Binding<Bool>(get: { showIndustryPicker }, set: { showIndustryPicker = $0 })
        let bindingShowJob = Binding<Bool>(get: { showJobInput }, set: { showJobInput = $0 })
        
        let degrees = ["高中", "學士", "碩士"]
        let industries = ["科技", "醫療", "教育"]
        
        // 建立 EducationAndWorkView
        let view = EducationAndWorkView(
            selectedDegree: bindingDegree,
            selectedSchool: bindingSchool,
            selectedIndustry: bindingIndustry,
            selectedJob: bindingJob,
            showDegreePicker: bindingShowDegree,
            showSchoolInput: bindingShowSchool,
            showIndustryPicker: bindingShowIndustry,
            showJobInput: bindingShowJob,
            degrees: degrees,
            industries: industries
        )
        // 將 view 上線
        ViewHosting.host(view: view)
        
        // 驗證 onAppear 是否觸發 "education_and_work_view_appear" 事件
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: { $0.event == "education_and_work_view_appear" }),
                      "應在畫面出現時觸發 education_and_work_view_appear 事件")
        
        // 模擬點擊「學歷」 row
        let degreeRow = try view.inspect().find(viewWithAccessibilityIdentifier: "EducationWorkRow_degree")
        let hStack = try degreeRow.find(ViewType.HStack.self)
        try hStack.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "education_row_tapped" &&
            ($0.parameters?["row"] as? String) == "degree"
        }), "點擊學歷 row 應觸發 education_row_tapped 事件並傳入 row: degree")
        XCTAssertTrue(showDegreePicker, "點擊學歷 row 後，showDegreePicker 應為 true")
        
        // 模擬點擊「學校」 row
        let schoolRow = try view.inspect().find(viewWithAccessibilityIdentifier: "EducationWorkRow_school")
        let schoolHStack = try schoolRow.find(ViewType.HStack.self)
        try schoolHStack.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "education_row_tapped" &&
            ($0.parameters?["row"] as? String) == "school"
        }), "點擊學校 row 應觸發 education_row_tapped 事件並傳入 row: school")
        XCTAssertTrue(showSchoolInput, "點擊學校 row 後，showSchoolInput 應為 true")
        
        // 模擬點擊「工作行業」 row
        let industryRow = try view.inspect().find(viewWithAccessibilityIdentifier: "EducationWorkRow_industry")
        let industryHStack = try industryRow.find(ViewType.HStack.self)
        try industryHStack.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "education_row_tapped" &&
            ($0.parameters?["row"] as? String) == "industry"
        }), "點擊工作行業 row 應觸發 education_row_tapped 事件並傳入 row: industry")
        XCTAssertTrue(showIndustryPicker, "點擊工作行業 row 後，showIndustryPicker 應為 true")
        
        // 模擬點擊「職業」 row
        let jobRow = try view.inspect().find(viewWithAccessibilityIdentifier: "EducationWorkRow_job")
        let jobHStack = try jobRow.find(ViewType.HStack.self)
        try jobHStack.callOnTapGesture()
        XCTAssertTrue(analyticsSpy.trackedEvents.contains(where: {
            $0.event == "education_row_tapped" &&
            ($0.parameters?["row"] as? String) == "job"
        }), "點擊職業 row 應觸發 education_row_tapped 事件並傳入 row: job")
        XCTAssertTrue(showJobInput, "點擊職業 row 後，showJobInput 應為 true")
    }
}
