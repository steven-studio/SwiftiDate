//
//  UserProfileCardView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/7/30.
//

import SwiftUI

struct UserProfileCardView: View {
    let profile: UserProfile

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            // 頭像
            if let url = URL(string: profile.photoURL), !profile.photoURL.isEmpty {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.green, lineWidth: 3))
            } else {
                // 預設圖
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray)
            }

            // 姓名、年齡、性別
            Text("\(profile.name) ・ \(profile.age)")
                .font(.title2).bold()
            Text(profile.gender.capitalized)
                .font(.subheadline)
                .foregroundColor(.secondary)

            // About Me
            if !profile.aboutMe.isEmpty {
                Text(profile.aboutMe)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
            }

            // 互動按鈕 (可依需求擴充)
            HStack(spacing: 24) {
                Button {
                    // 喜歡
                } label: {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.pink)
                        .font(.title)
                }
                Button {
                    // 聊天
                } label: {
                    Image(systemName: "message.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding(.horizontal, 20)
    }
}

struct UserProfileCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileCardView(profile: UserProfile(
            id: "1",
            name: "小美",
            gender: "female",
            age: 24,
            photoURL: "https://randomuser.me/api/portraits/women/1.jpg",
            aboutMe: "嗨！我喜歡旅行和美食，期待認識有趣的朋友。"
        ))
        .background(Color.gray.opacity(0.2))
    }
}
