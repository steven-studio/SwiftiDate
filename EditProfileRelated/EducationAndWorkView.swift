//
//  EducationAndWorkView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/16.
//

import Foundation
import SwiftUI

// Reusable row view for the education and work items
struct EducationWorkRowView<Icon: View>: View {
    let label: String
    let value: String
    let icon: Icon
    let isValueEmpty: Bool
    let onTap: () -> Void
    
    var body: some View {
        HStack {
            icon
                .foregroundColor(.gray)
                .frame(width: 24, height: 24) // Adjust size to fit the design
            Text(label)
                .font(.headline)
                .padding(.bottom, 5)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(isValueEmpty ? .green : .gray)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture {
            onTap()
        }
    }
}

// 教育與工作子視圖
struct EducationAndWorkView: View {
    @Binding var selectedDegree: String?
    @Binding var selectedSchool: String?
    @Binding var selectedIndustry: String?
    @Binding var selectedJob: String?
    
    @Binding var showDegreePicker: Bool
    @Binding var showSchoolInput: Bool
    @Binding var showIndustryPicker: Bool
    @Binding var showJobInput: Bool
    
    let degrees: [String]
    let industries: [String]
    
    var body: some View {
        // 工作與學歷
        VStack(alignment: .leading) {
            Text("工作與學歷")
                .font(.headline)
                .padding(.bottom, 5)

            // Education and Work sections using the reusable row component
            EducationWorkRowView(
                label: "學歷",
                value: selectedDegree ?? "新增",
                icon: Image(systemName: "graduationcap.fill"),
                isValueEmpty: selectedDegree == nil,
                onTap: {
                    // 埋點：點擊學歷 row
                    AnalyticsManager.shared.trackEvent("education_row_tapped", parameters: [
                        "row": "degree"
                    ])
                    showDegreePicker = true
                }
            )
            .sheet(isPresented: $showDegreePicker) {
                DegreePicker(selectedDegree: $selectedDegree, degrees: degrees)
            }
            
            EducationWorkRowView(
                label: "學校",
                value: selectedSchool ?? "新增",
                icon: Image("school_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit),
                isValueEmpty: selectedSchool == nil,
                onTap: {
                    // 埋點：點擊學校 row
                    AnalyticsManager.shared.trackEvent("education_row_tapped", parameters: [
                        "row": "school"
                    ])
                    showSchoolInput = true
                }
            )
            .sheet(isPresented: $showSchoolInput) {
                SchoolInputView(selectedSchool: $selectedSchool)
            }
            
            EducationWorkRowView(
                label: "工作行業",
                value: selectedIndustry ?? "未選擇",
                icon: Image(systemName: "building.fill"),
                isValueEmpty: selectedIndustry == nil,
                onTap: {
                    // 埋點：點擊工作行業 row
                    AnalyticsManager.shared.trackEvent("education_row_tapped", parameters: [
                        "row": "industry"
                    ])
                    showIndustryPicker = true
                }
            )
            .sheet(isPresented: $showIndustryPicker) {
                IndustryPicker(selectedIndustry: $selectedIndustry, industries: industries)
            }
            
            EducationWorkRowView(
                label: "職業",
                value: selectedJob ?? "新增",
                icon: Image(systemName: "building.fill"),
                isValueEmpty: selectedJob == nil,
                onTap: {
                    // 埋點：點擊職業 row
                    AnalyticsManager.shared.trackEvent("education_row_tapped", parameters: [
                        "row": "job"
                    ])
                    showJobInput = true
                }
            )
            .sheet(isPresented: $showJobInput) {
                JobInputView(selectedJob: $selectedJob)
            }
        }
        .padding(.horizontal)
        // 可選：當整個畫面出現時上報事件
        .onAppear {
            AnalyticsManager.shared.trackEvent("education_and_work_view_appear")
        }
    }
}

struct EducationAndWorkView_Previews: PreviewProvider {
    @State static var mockSelectedDegree: String? = "碩士及以上"
    @State static var mockSelectedSchool: String? = "台灣大學"
    @State static var mockSelectedIndustry: String? = "學生"
    @State static var mockSelectedJob: String? = "自由接案者"
    
    @State static var mockShowDegreePicker = false
    @State static var mockShowSchoolInput = false
    @State static var mockShowIndustryPicker = false
    @State static var mockShowJobInput = false
    
    static var mockDegrees = ["高中", "職校/專科", "學士", "碩士及以上", "其他學歷"]
    static var mockIndustries = [
        "藝術/設計", "建築", "航空/交通運輸", "商業/金融", "傳播/媒體", "文創產業",
        "時尚/模特", "健身/體育", "自由業", "教育培訓", "工程技術", "政府機關",
        "醫療/醫藥", "律政行業", "市場營銷", "製造業", "NGO/慈善事業", "公眾關係",
        "銷售/零售業", "媒體傳播/自媒體", "社會工作者", "學生", "科技行業/科學研究",
        "旅遊業", "其他：新創/創業", "其他：自營企業", "其他行業"
    ]
    
    static var previews: some View {
        EducationAndWorkView(
            selectedDegree: $mockSelectedDegree,
            selectedSchool: $mockSelectedSchool,
            selectedIndustry: $mockSelectedIndustry,
            selectedJob: $mockSelectedJob,
            showDegreePicker: $mockShowDegreePicker,
            showSchoolInput: $mockShowSchoolInput,
            showIndustryPicker: $mockShowIndustryPicker,
            showJobInput: $mockShowJobInput,
            degrees: mockDegrees,
            industries: mockIndustries
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
