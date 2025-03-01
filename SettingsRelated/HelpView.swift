//
//  HelpView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct HelpView: View {
    @Binding var isHelpView: Bool // Binding to control the dismissal of HelpView
    @State private var isWhatIsSwiftiDate = false // State variable to control navigation to WhatIsSwiftiDateView
    @State private var isSwiftiDatePaid = false // State variable to control navigation to IsSwiftiDatePaidView
    @State private var isHowToMatchAndChat = false // State variable to control navigation to HowToMatchAndChatView
    @State private var isWhoLikedMeView = false // State variable to control navigation to WhoLikedMeView
    @State private var isWhyIsItHardToMatch = false // State variable to control navigation to WhyIsItHardTo
    @State private var isHowToUnmatchView = false // State variable to control navigation to HowToUnmatchView
    @State private var isHowToDeleteMessagesView = false // State variable to control navigation to HowToDeleteMessagesView
    @State private var isReportUserView = false // State variable to control navigation to ReportUserView
    @State private var isWhatIsSwiftiDatePremium = false // State variable to control navigation to WhatIsSwiftiDatePremium
    @State private var isHowToUseWhoLikedMeAndCrushListView = false // State variable to control navigation to HowToUseWhoLikedMeAndCrushListView
    @State private var isWhatIsCrushAndHowToUseView = false // State variable to control navigation to WhatIsCrushAndHowToUseView
    @State private var isWhatIsTurboAndHowToUseView = false // State variable to control navigation to WhatIsTurboAndHowToUseView
    @State private var isUndoSwipeView = false // State variable to control navigation to UndoSwipeView
    @State private var isHowToEnablePremiumBadgeView = false // State variable to control navigation to HowToEnablePremiumBadgeView
    @State private var isHowToPurchaseSwiftiDatePremiumView = false // State variable to control navigation to HowToPurchaseSwiftiDatePremiumView
    @State private var isHowToCancelSubscriptionView = false // State variable to control navigation to HowToCancelSubscriptionView
    @State private var isRestorePurchaseView = false // State variable to control navigation to RestorePurchaseView
    @State private var isRefundPolicyView = false // State variable to control navigation to RefundPolicyView
    @State private var isWhatIsSwiftiDatePremiumDiscountPolicyView = false // State variable to control navigation to WhatIsSwiftiDatePremiumDiscountPolicyView
    @State private var isWhatIsSwiftiDateSupremeView = false // State variable to control navigation to WhatIsSwiftiDateSupremeView
    @State private var isHowToUseDailyPraiseOpportunityView = false // State variable to control navigation to HowToUseDailyPraiseOpportunityView
    @State private var isHowToUseAdvancedFilteringView = false // State variable to control navigation to HowToUseAdvancedFilteringView
    @State private var isHowToUseIncognitoModeView = false // State variable to control navigation to HowToUseIncognitoModeView
    @State private var isHowToPurchaseSwiftiDateSupremeView = false // State variable to control navigation to HowToPurchaseSwiftiDateSupremeView
    @State private var isUpdateProfileDetailsView = false // State variable to control navigation to UpdateProfileDetailsView
    @State private var isManageProfilePhotosView = false // State variable to control navigation to ManageProfilePhotosView
    @State private var isPhotoUploadGuidelinesView = false // State variable to control navigation to PhotoUploadGuidelinesView
    @State private var isHowToEnableNotificationsView = false // State variable to control navigation to HowToEnableNotificationsView

    // Extracting the data to separate properties
    private let personalInfoTopics = [
        "如何編輯我的個人資料？",
        "如何更改我的照片？",
        "我需要上傳什麼樣的照片作為頭像？",
        "如何通過真人認證？",
        "如何更改我的搜尋偏好？",
        "如何修改備註名稱？",
        "如何搜尋配對好友？",
        "如何收到SwiftiDate的訊息提醒？",
        "如何註銷我的帳號"
    ]
    
    var body: some View {
        if isWhatIsSwiftiDate {
            WhatIsSwiftiDateView(isWhatIsSwiftiDate: $isWhatIsSwiftiDate) // Navigate to WhatIsSwiftiDateView
        } else if isSwiftiDatePaid {
            IsSwiftiDatePaidView(isSwiftiDatePaid: $isSwiftiDatePaid) // Navigate to IsSwiftiDatePaidView
        } else if isHowToMatchAndChat {
            HowToMatchAndChatView(isHowToMatchAndChat: $isHowToMatchAndChat) // Navigate to HowToMatchAndChatView
        } else if isWhoLikedMeView {
            WhoLikedMeView(isWhoLikedMeView: $isWhoLikedMeView) // Navigate to WhoLikedMeView
        } else if isWhyIsItHardToMatch {
            WhyIsItHardToMatchView(isWhyIsItHardToMatch: $isWhyIsItHardToMatch) // Navigate to WhyIsItHardToMatchView
        } else if isHowToUnmatchView {
            HowToUnmatchView(isHowToUnmatch: $isHowToUnmatchView) // Navigate to HowToUnmatchView
        } else if isHowToDeleteMessagesView {
            HowToDeleteMessagesView(isHowToDeleteMessages: $isHowToDeleteMessagesView) // Navigate to HowtoDeleteMesagesView
        } else if isReportUserView {
            ReportUserView(isReportUserView: $isReportUserView) // Navigate to ReportUserView
        } else if isWhatIsSwiftiDatePremium {
            WhatIsSwiftiDatePremiumView(isWhatIsSwiftiDatePremium: $isWhatIsSwiftiDatePremium) // Navigate to WhatIsSwiftiDatePremiumView
        } else if isHowToUseWhoLikedMeAndCrushListView {
            HowToUseWhoLikedMeAndCrushListView(isHowToUseWhoLikedMeAndCrushListView: $isHowToUseWhoLikedMeAndCrushListView) // Navigate to HowToUseWhoLikedMeAndCrushListVIew
        } else if isWhatIsCrushAndHowToUseView {
            WhatIsCrushAndHowToUseView(isWhatIsCrushAndHowToUseView: $isWhatIsCrushAndHowToUseView) // Navigate to WhatIsCrushAndHowToUseView
        } else if isWhatIsTurboAndHowToUseView {
            WhatIsTurboAndHowToUseView(isWhatIsTurboAndHowToUseView: $isWhatIsTurboAndHowToUseView) // Navigate to WhatIsTurboAndHowToUseView
        } else if isUndoSwipeView {
            UndoSwipeView(isUndoSwipeView: $isUndoSwipeView) // Navigate to UndoSwipeView
        } else if isHowToEnablePremiumBadgeView {
            HowToEnablePremiumBadgeView(isHowToEnablePremiumBadgeView: $isHowToEnablePremiumBadgeView) // Navigate to HowToEnablePremiumBadgeView
        } else if isHowToPurchaseSwiftiDatePremiumView {
            HowToPurchaseSwiftiDatePremiumView(isHowToPurchaseSwiftiDatePremium: $isHowToPurchaseSwiftiDatePremiumView) // Navigate to HowToPurchaseSwiftiDatePremiumView
        } else if isHowToCancelSubscriptionView {
            HowToCancelSubscriptionView(isHowToCancelSubscriptionView: $isHowToCancelSubscriptionView) // Navigate to HowToCancelSubscriptionView
        } else if isRestorePurchaseView {
            RestorePurchaseView(isRestorePurchaseView: $isRestorePurchaseView) // Navigate to RestorePurchaseView
        } else if isRefundPolicyView {
            RefundPolicyView(isRefundPolicyView: $isRefundPolicyView) // Navigate to RefundPolicyView
        } else if isWhatIsSwiftiDatePremiumDiscountPolicyView {
            WhatIsSwiftiDatePremiumDiscountPolicyView(isWhatIsSwiftiDatePremiumDiscountPolicyView: $isWhatIsSwiftiDatePremiumDiscountPolicyView) // Navigate to WhatIsSwiftiDatePremiumDiscountPolicyView
        } else if isWhatIsSwiftiDateSupremeView {
            WhatIsSwiftiDateSupremeView(isWhatIsSwiftiDateSupremeView: $isWhatIsSwiftiDateSupremeView) // Navigate to WhatIsSwiftiDateSupremeView
        } else if isHowToUseDailyPraiseOpportunityView {
            HowToUseDailyPraiseOpportunityView(isHowToUseDailyPraiseOpportunityView: $isHowToUseDailyPraiseOpportunityView) // Navigate to HowToUseDailyPraiseOpportunityView
        } else if isHowToUseAdvancedFilteringView {
            HowToUseAdvancedFilteringView(isHowToUseAdvancedFilteringView: $isHowToUseAdvancedFilteringView) // Navigate to HowToUseAdvancedFilteringView
        } else if isHowToUseIncognitoModeView {
            HowToUseIncognitoModeView(isHowToUseIncognitoModeView: $isHowToUseIncognitoModeView) // Navigate to HowToUseIncognitoModeView
        } else if isHowToPurchaseSwiftiDateSupremeView {
            HowToPurchaseSwiftiDateSupremeView(isHowToPurchaseSwiftiDateSupremeView: $isHowToPurchaseSwiftiDateSupremeView) // Navigate to HowToPurchaseSwiftiDateSupremeView
        } else if isUpdateProfileDetailsView {
            UpdateProfileDetailsView(isUpdateProfileDetailsView: $isUpdateProfileDetailsView) // Navigate to UpdateProfileDetailsView
        } else if isManageProfilePhotosView {
            ManageProfilePhotosView(isManageProfilePhotosView: $isManageProfilePhotosView) // Navigate to ManageProfilePhotosView
        } else if isPhotoUploadGuidelinesView {
            PhotoUploadGuidelinesView(isPhotoUploadGuidelinesView: $isPhotoUploadGuidelinesView) // Navigate to PhotoUploadGuidelinesView
        } else if isHowToEnableNotificationsView {
            HowToEnableNotificationsView(isHowToEnableNotificationsView: $isHowToEnableNotificationsView) // Navigate to HowToEnableNotificationsView
        } else {
            VStack {
                // Custom Navigation Bar
                HStack {
                    Button(action: {
                        AnalyticsManager.shared.trackEvent("HelpView_BackTapped", parameters: nil)
                        isHelpView = false // Dismiss HelpView and return to SettingsView
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title)
                    }
                    
                    Text("SwiftiDate 幫助")
                        .font(.headline)
                        .padding(.leading, 5)
                    
                    Spacer()
                }
                .padding()
                
                Divider()
                
                // Help content
                List {
                    Section(header: Text("SwiftiDate 概覽")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)) {
                        // Convert HStack to Button
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhatIsSwiftiDateTapped", parameters: nil)
                            isWhatIsSwiftiDate = true // Set the state variable to true
                        }) {
                            HStack {
                                Text("SwiftiDate 是什麼？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black) // Ensure the text color remains black
                        
                        // Convert HStack to Button
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_SwiftiDatePaidTapped", parameters: nil)
                            isSwiftiDatePaid = true // Set the state variable to true
                        }) {
                            HStack {
                                Text("SwiftiDate 需要付費使用嗎？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black) // Ensure the text color remains black
                    }
                    
                    Section(header: Text("配對與聊天")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)) {
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToMatchAndChatTapped", parameters: nil)
                            isHowToMatchAndChat = true // Set the state variable to true
                        }) {
                            HStack {
                                Text("如何與他人配對、聊天？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                        
                        // Convert "我能查看誰喜歡了我嗎？" to Button
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhoLikedMeTapped", parameters: nil)
                            isWhoLikedMeView = true // Set the state variable to true
                        }) {
                            HStack {
                                Text("我能查看誰喜歡了我嗎？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                        
                        // Convert "為什麼我很難配對成功？" to Button
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhyIsItHardToMatchTapped", parameters: nil)
                            isWhyIsItHardToMatch = true // Set the state variable to true
                        }) {
                            HStack {
                                Text("為什麼我很難配對成功？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                        
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToUnmatchTapped", parameters: nil)
                            isHowToUnmatchView = true // Set the state variable to true
                        }) {
                            HStack {
                                Text("如何解除配對？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
            
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToDeleteMessagesTapped", parameters: nil)
                            isHowToDeleteMessagesView = true
                        }) {
                            HStack {
                                Text("可以刪除傳出去的訊息嗎？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
            
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_ReportUserTapped", parameters: nil)
                            isReportUserView = true
                        }) {
                            HStack {
                                Text("如何檢舉用戶？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                    }
                    
                    // Adding the SwiftiDate Premium section
                    Section(header: Text("SwiftiDate Premium")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)) {
                                    
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhatIsSwiftiDatePremiumTapped", parameters: nil)
                            isWhatIsSwiftiDatePremium = true
                        }) {
                            HStack {
                                Text("什麼是 SwiftiDate Premium？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                                
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToUseWhoLikedMeAndCrushListTapped", parameters: nil)
                            isHowToUseWhoLikedMeAndCrushListView = true
                        }) {
                            HStack {
                                Text("如何使用「看看誰喜歡你」與「開啟心動列表」功能？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                                    
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhatIsCrushAndHowToUseTapped", parameters: nil)
                            isWhatIsCrushAndHowToUseView = true
                        }) {
                            HStack {
                                Text("「Crush」是什麼？如何使用？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                                    
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhatIsTurboAndHowToUseTapped", parameters: nil)
                            isWhatIsTurboAndHowToUseView = true
                        }) {
                            HStack {
                                Text("「Turbo」是什麼？如何使用？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                                    
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_UndoSwipeTapped", parameters: nil)
                            isUndoSwipeView = true
                        }) {
                            HStack {
                                Text("滑錯如何反悔？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToEnablePremiumBadgeTapped", parameters: nil)
                            isHowToEnablePremiumBadgeView = true
                        }) {
                            HStack {
                                Text("如何開啟 Premium 專屬標誌？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToPurchaseSwiftiDatePremiumTapped", parameters: nil)
                            isHowToPurchaseSwiftiDatePremiumView = true
                        }) {
                            HStack {
                                Text("如何購買 SwiftiDate Premium？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToCancelSubscriptionTapped", parameters: nil)
                            isHowToCancelSubscriptionView = true
                        }) {
                            HStack {
                                Text("如何取消自動續費？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_RestorePurchaseTapped", parameters: nil)
                            isRestorePurchaseView = true
                        }) {
                            HStack {
                                Text("支付完成後，特權未生效怎麼辦？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                               
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_RefundPolicyTapped", parameters: nil)
                            isRefundPolicyView = true
                        }) {
                            HStack {
                                Text("如果已經成功續訂 SwiftiDate Premium，還可以退款嗎？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhatIsSwiftiDatePremiumDiscountPolicyTapped", parameters: nil)
                            isWhatIsSwiftiDatePremiumDiscountPolicyView = true
                        }) {
                            HStack {
                                Text("SwiftiDate Premium 的價格有優惠嗎？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                    }
                    
                    // Adding the SwiftiDate Supreme section
                    Section(header: Text("SwiftiDate Supreme")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)) {
                                    
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_WhatIsSwiftiDateSupremeTapped", parameters: nil)
                            isWhatIsSwiftiDateSupremeView = true
                        }) {
                            HStack {
                                Text("什麼是 SwiftiDate Supreme？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToUseDailyPraiseOpportunityTapped", parameters: nil)
                            isHowToUseDailyPraiseOpportunityView = true
                        }) {
                            HStack {
                                Text("如何使用「每日 3 次的讚美機會」功能？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToUseAdvancedFilteringTapped", parameters: nil)
                            isHowToUseAdvancedFilteringView = true
                        }) {
                            HStack {
                                Text("如何使用「高級篩選」功能？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToUseIncognitoModeTapped", parameters: nil)
                            isHowToUseIncognitoModeView = true
                        }) {
                            HStack {
                                Text("如何使用「隱身模式」功能？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToPurchaseSwiftiDateSupremeTapped", parameters: nil)
                            isHowToPurchaseSwiftiDateSupremeView = true
                        }) {
                            HStack {
                                Text("如何購買 SwiftiDate Supreme？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)
                    }
                    
                    // Adding the Personal Information and Settings section
                    Section(header: Text("個人資訊與設定")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.vertical, 5)) {
                                  
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_UpdateProfileDetailsTapped", parameters: nil)
                            isUpdateProfileDetailsView = true
                        }) {
                            HStack {
                                Text("如何編輯我的個人資料？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_ManageProfilePhotosTapped", parameters: nil)
                            isManageProfilePhotosView = true
                        }) {
                            HStack {
                                Text("如何更改我的照片？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_PhotoUploadGuidelinesTapped", parameters: nil)
                            isPhotoUploadGuidelinesView = true
                        }) {
                            HStack {
                                Text("我需要上傳什麼樣的照片作為頭像？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        HStack {
                            Text("如何通過真人認證？")
                                .padding(.vertical, 10)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("如何更改我的搜尋偏好？")
                                .padding(.vertical, 10)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("如何修改備註名稱？")
                                .padding(.vertical, 10)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("如何搜尋配對好友？")
                                .padding(.vertical, 10)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {
                            AnalyticsManager.shared.trackEvent("HelpView_HowToEnableNotificationsTapped", parameters: nil)
                            isHowToEnableNotificationsView = true
                        }) {
                            HStack {
                                Text("如何收到SwiftiDate的訊息提醒？")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .foregroundColor(.black)

                        HStack {
                            Text("如何註銷我的帳號")
                                .padding(.vertical, 10)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(GroupedListStyle()) // To create the grouped appearance like in your image
                .onAppear {
                    AnalyticsManager.shared.trackEvent("HelpView_Appeared", parameters: nil)
                }
            }
        }
    }
}

// Preview for HelpView
struct HelpView_Previews: PreviewProvider {
    @State static var isHelpView = true // Provide a sample state variable for the preview

    static var previews: some View {
        HelpView(isHelpView: $isHelpView) // Use the binding variable in the preview
    }
}
