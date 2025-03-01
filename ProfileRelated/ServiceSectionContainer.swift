//
//  ServiceSectionContainer.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

import SwiftUI

// ServiceSectionTitleView: A reusable component for displaying the service section title
struct ServiceSectionTitleView: View {
    var title: String
    var subtitle: String
    var subtitleColor: Color

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .padding(.top)
            
            Spacer() // This spacer will push the next text to the right side
            
            VStack(alignment: .trailing) {
                Text(subtitle)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("16項特權")
                    .font(.subheadline)
                    .foregroundColor(subtitleColor)
            }
        }
        .padding(.horizontal)
    }
}

struct ServiceSectionContainer: View {
    @Binding var isSupreme: Bool
    
    var body: some View {
        if isSupreme {
            // 服務項目
            VStack(alignment: .leading, spacing: 10) {
                // Service Section Title
                // Using the new ServiceSectionTitleView
                ServiceSectionTitleView(
                    title: "服務項目",
                    subtitle: "Supreme",
                    subtitleColor: .gray
                )
                
                // Section 1: 更快篩選對的人
                ServiceSectionView(
                    sectionTitle: "更快篩選對的人",
                    totalItems: 4,
                    services: [
                        ("附近的人", true, nil, false, 0),
                        ("高級篩選", true, nil, false, 0),
                        ("每日精選", true, nil, false, 0),
                        ("額外的喜歡次數", false, nil, true, 0) // Display infinity icon
                    ],
                    hasMultipleIcons: false,
                    isSupremeUser: true
                )
                
                // Section 2: 獲取更多配對
                ServiceSectionView(
                    sectionTitle: "獲取更多配對",
                    totalItems: 7,
                    services: [
                        ("免費讚美", true, "3/天", false, 0),
                        ("免費的Crush", true, "5/天", false, 0),
                        ("免費Turbo", true, "1/月", false, 0),
                        ("看看誰喜歡你", true, nil, false, 0),
                        ("開啟心動列表", true, nil, false, 0),
                        ("免費的反悔機會", false, nil, true, 0), // Display infinity icon
                        ("找回已解除的配對", true, nil, false, 0)
                    ],
                    hasMultipleIcons: false,
                    isSupremeUser: true
                )
                
                // Section 3: 升級體驗
                ServiceSectionView(
                    sectionTitle: "升級體驗",
                    totalItems: 5,
                    services: [
                        ("隱身模式", true, nil, false, 0),
                        ("24小時專屬客服", true, nil, false, 0),
                        ("已讀回執", true, nil, false, 0),
                        ("專屬會員標誌", true, nil, false, 0),
                        ("不限次數的「緣分合盤」解讀", true, nil, false, 0)
                    ],
                    hasMultipleIcons: false,
                    isSupremeUser: true
                )
            }
            .padding(.horizontal)
        } else {
            // 服務項目
            VStack(alignment: .leading, spacing: 10) {
                // Service Section Title
                HStack {
                    Text("服務項目")
                        .font(.headline)
                        .padding(.top)
                    
                    Spacer() // This spacer will push the next text to the right side
                    
                    VStack {
                        Text("你")
                            .font(.headline)
                            .italic() // 使文字變成斜體
                        
                        Text("無任何特權")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .trailing) {
                        Text("Premium")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.gold)
                        
                        Text("10項特權")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                
                // Section 1: 更快篩選對的人
                ServiceSectionView(
                    sectionTitle: "更快篩選對的人",
                    totalItems: 0,
                    additionalTotalItems: 1,
                    services: [
                        ("附近的人", false, nil, false, 90),
                        ("高級篩選", false, nil, false, 90),
                        ("每日精選", false, nil, false, 90),
                        ("額外的喜歡次數", true, nil, true, 85) // Display infinity icon
                    ],
                    hasMultipleIcons: true,
                    isSupremeUser: false,
                    titleSpacerWidth: 70
                )
                
                // Section 2: 獲取更多配對
                ServiceSectionView(
                    sectionTitle: "獲取更多配對",
                    totalItems: 0,
                    additionalTotalItems: 6,
                    services: [
                        ("免費讚美", false, "3/天", false, 95),
                        ("免費的Crush", true, "5/天", false, 85),
                        ("免費Turbo", true, "1/月", false, 88),
                        ("看看誰喜歡你", true, nil, false, 95),
                        ("開啟心動列表", true, nil, false, 95),
                        ("免費的反悔機會", true, nil, true, 90), // Display infinity icon
                        ("找回已解除的配對", true, nil, false, 95)
                    ],
                    hasMultipleIcons: true,
                    isSupremeUser: false,
                    titleSpacerWidth: 70
                )
                
                // Section 3: 升級體驗
                ServiceSectionView(
                    sectionTitle: "升級體驗",
                    totalItems: 0,
                    additionalTotalItems: 3,
                    services: [
                        ("隱身模式", false, nil, false, 95),
                        ("24小時專屬客服", false, nil, false, 95),
                        ("已讀回執", true, nil, false, 95),
                        ("專屬會員標誌", true, nil, false, 95),
                    ],
                    hasMultipleIcons: true,
                    isSupremeUser: false,
                    titleSpacerWidth: 70
                )
            }
            .padding(.horizontal)
        }
        
        Spacer()
    }
}

struct ServiceSectionView: View {
    var sectionTitle: String
    var totalItems: Int
    var additionalTotalItems: Int? // Optional parameter for a second total item count
    var services: [(name: String, isAvailable: Bool, count: String?, isInfinity: Bool, spacerWidth: CGFloat)] // Added spacerWidth to the tuple
    var hasMultipleIcons: Bool
    var isSupremeUser: Bool // New variable to indicate if the user is a Supreme user
    var titleSpacerWidth: CGFloat? // Optional spacer width for the title

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            HStack {
                Text(sectionTitle)
                    .font(.headline)

                Spacer()

                Text("\(totalItems)項")
                    .font(.subheadline)
                    .padding(5)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(5)
                
                if hasMultipleIcons {
                    Spacer()
                        .frame(width: titleSpacerWidth) // Apply the optional spacer width for the title

                    if let additionalItems = additionalTotalItems {
                        Text("\(additionalItems)項")
                            .font(.subheadline)
                            .padding(5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                    }
                }
            }

            // Service items
            ForEach(services, id: \.name) { service in
                HStack {
                    Text(service.name)
                        .font(.subheadline)
                        .foregroundColor(.black)

                    Spacer()

                    if isSupremeUser {
                        if let count = service.count {
                            Text(count)
                                .font(.subheadline)
                        } else if service.isAvailable {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName: "infinity") // Use infinity icon here
                        }
                    } else {
                        Image(systemName: "nosign")
                    }
                    
                    if hasMultipleIcons {
                        Spacer()
                            .frame(width: service.spacerWidth) // Apply the spacer width
                        
                        if !service.isAvailable {
                            Image(systemName: "nosign")
                        } else if let count = service.count {
                            Text(count)
                                .font(.subheadline)
                                .foregroundColor(.gold)
                        } else if service.isInfinity {
                            Image(systemName: "infinity") // Use infinity icon here
                                .foregroundColor(.gold) // Set gold for infinity icon
                        } else {
                            Image(systemName: "checkmark")
                                .foregroundColor(.gold) // Set gold for checkmark icon
                        }
                    }
                }
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}

struct ServiceSectionContainer_Previews: PreviewProvider {
    static var previews: some View {
        ServiceSectionContainer(isSupreme: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
