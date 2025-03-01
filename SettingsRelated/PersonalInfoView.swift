//
//  PersonalInfoView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/3.
//

import SwiftUI

struct PersonalInfoView: View {
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 存取 UserSettings
    
    @Binding var isPersonalInfoView: Bool // Binding variable to control the view dismissal

    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    AnalyticsManager.shared.trackEvent("PersonalInfoView_BackTapped", parameters: nil)
                    isPersonalInfoView = false // Dismiss the view when back is tapped
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("個人資料")
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                // Optional placeholder for right-side content, if needed
                Spacer().frame(width: 44) // To balance the chevron size
            }
            .padding()
            
            Divider()

            // List with personal info
            List {
                HStack {
                    Text("姓名")
                    Spacer()
                    Text(userSettings.globalUserName) // 使用 userSettings 來存取 globalUserName
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)

                HStack {
                    Text("生日")
                    Spacer()
                    Text(userSettings.globalUserBirthday) // 使用 userSettings 來存取 globalUserBirthday
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 10)
            }
            .listStyle(GroupedListStyle()) // Optional: Set the list style to match the look
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("PersonalInfoView_Appeared", parameters: nil)
        }
    }
    
    func calculateAge(birthday: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        guard let birthDate = dateFormatter.date(from: birthday) else { return 0 }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year ?? 0
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    @State static var isPersonalInfoView = true

    static var previews: some View {
        PersonalInfoView(isPersonalInfoView: $isPersonalInfoView)
    }
}
