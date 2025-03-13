//
//  DataManagementView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/24.
//

import SwiftUI

struct DataManagementView: View {
    @Binding var isDataManagementView: Bool
    
    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    AnalyticsManager.shared.trackEvent("DataManagementView_BackTapped", parameters: nil)
                    isDataManagementView = false // Dismiss DataManagementView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Text("數據管理")
                    .font(.headline)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    HStack {
                        Text("快取")
                            .font(.headline)
                            .padding(.vertical, 10)
                        Spacer()
                        Text("123.7MB")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    Button(action: {
                        AnalyticsManager.shared.trackEvent("DataManagementView_ClearCacheTapped", parameters: nil)
                        // Add action to clear cache
                    }) {
                        Text("清除快取")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                    .padding()
                    
                    Text("清除快取記憶體只會刪除設備的媒體文件，釋放存儲空間。如果有需要，所有內容將在需要時再次從服務器下載。")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("DataManagementView_Appeared", parameters: nil)
        }
    }
}

// Preview for DataManagementView
struct DataManagementView_Previews: PreviewProvider {
    @State static var isDataManagementView = true

    static var previews: some View {
        DataManagementView(isDataManagementView: $isDataManagementView)
    }
}
