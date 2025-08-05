//
//  UserListSection.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/2.
//

import SwiftUI

enum UserListType {
    case likesMe
    case iLike
}

struct UserListSection: View {
    @EnvironmentObject var userSettings: UserSettings
    @Binding var contentSelectedTab: Int
    @Binding var showConfirmationPopup: Bool
    var listType: UserListType
    var onBack: (() -> Void)?

    private var isEmpty: Bool {
        switch listType {
        case .likesMe:
            return userSettings.likedMeUsers.isEmpty
        case .iLike:
            return userSettings.sentLikes.isEmpty
        }
    }

    private var users: [UserProfile] {
        switch listType {
        case .likesMe:
            return userSettings.likedMeUsers
        case .iLike:
            return userSettings.sentLikes
        }
    }

    private var emptyStateText: String {
        switch listType {
        case .likesMe:
            return "開啟Turbo，將你直接置頂到所有人的前面！輕鬆提升10倍配對成功率"
        case .iLike:
            return "你還沒有送出喜歡，快去滑動吧"
        }
    }

    private var emptyStateButtonText: String {
        switch listType {
        case .likesMe: return "馬上開始"
        case .iLike: return "去滑卡"
        }
    }
    
    private var emptyStateButtonGradient: LinearGradient {
        switch listType {
        case .likesMe:
            return LinearGradient(
                gradient: Gradient(colors: [.pink, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .iLike:
            return LinearGradient(
                gradient: Gradient(colors: [.green, .blue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func handleEmptyButtonTap() {
        switch listType {
        case .likesMe:
            if userSettings.globalTurboCount > 0 {
                AnalyticsManager.shared.trackEvent("turbo_start_button_pressed",
                    parameters: ["globalTurboCount": userSettings.globalTurboCount])
                showConfirmationPopup = true
            }
        case .iLike:
            AnalyticsManager.shared.trackEvent("turbo_go_to_swipe_pressed")
            onBack?()
            contentSelectedTab = 0
        }
    }

    var body: some View {
        VStack {
            if isEmpty {
                Spacer()
                Image(systemName: "cube.box")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text(emptyStateText)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
                    .padding(.horizontal, 30)

                Button(action: handleEmptyButtonTap) {
                    Text(emptyStateButtonText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(emptyStateButtonGradient)
                        .cornerRadius(10)
                        .padding(.horizontal, 60)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(users) { user in
                            UserProfileCardView(profile: user)
                                .aspectRatio(3/4, contentMode: .fill)
                                .clipped()
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct UserListSection_Previews: PreviewProvider {
    @State static var tab = 0
    @State static var showConfirmationPopup = false

    static var previews: some View {
        Group {
            UserListSection(
                contentSelectedTab: $tab,
                showConfirmationPopup: $showConfirmationPopup,
                listType: .likesMe,
                onBack: nil
            )
            .environmentObject(mockUserSettingsWithLikes)
            .previewDisplayName("有人喜歡我")

            UserListSection(
                contentSelectedTab: $tab,
                showConfirmationPopup: $showConfirmationPopup,
                listType: .iLike,
                onBack: nil
            )
            .environmentObject(mockUserSettingsWithoutLikes)
            .previewDisplayName("沒有人喜歡我")
        }
    }

    static var mockUserSettingsWithLikes: UserSettings {
        let settings = UserSettings()
        settings.likedMeUsers = [
            UserProfile(id: UUID().uuidString, name: "Alice", gender: "Female", age: 25, photoURL: "https://example.com/photo1.jpg", aboutMe: "喜歡旅行與美食"),
            UserProfile(id: UUID().uuidString, name: "Bella", gender: "Female", age: 23, photoURL: "https://example.com/photo2.jpg", aboutMe: "熱愛音樂和健身")
        ]
        settings.sentLikes = []
        settings.globalTurboCount = 2
        return settings
    }

    static var mockUserSettingsWithoutLikes: UserSettings {
        let settings = UserSettings()
        settings.sentLikes = []
        settings.likedMeUsers = []
        settings.globalTurboCount = 1
        return settings
    }
}
