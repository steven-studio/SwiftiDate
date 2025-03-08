//
//  SettingsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import UIKit
import SwiftUI
import MessageUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState // 確保可以訪問 AppState
    @EnvironmentObject var userSettings: UserSettings // 使用 EnvironmentObject 來獲取 global 變數
    @Binding var showSettingsView: Bool // Binding variable to control the view dismissal
    @State private var isQRCodeScannerView = false
    @State private var isHelpView = false // State variable to control HelpView presentation
    @State private var isCommunityGuidelinesView = false // State variable for CommunityGuidelinesView
    @State private var isPrivacyPolicyView = false // State variable for PrivacyPolicyView
    @State private var isTermsOfServiceView = false // State variable for TermsOfServiceView
    @State private var isDataManagementView = false
    @State private var showUpdatePopup = false // State variable to control update popup display
    @State private var isShowingLogoutAlert = false // State variable to control alert presentation
    @State private var isPersonalInfoView = false // 控制個人資料頁面的顯示
    @State private var isShowingCustomerServiceAlert = false
    @State private var isShowingMailComposer = false // 控制郵件視圖的顯示
    @State private var mailData: MailData? // 保存郵件數據

    var body: some View {
        ZStack {
            if isQRCodeScannerView {
                QRCodeScannerView(didFindCode: { scannedCode in
                    // Handle the scanned code
                    print("Scanned QR Code: \(scannedCode)")
                    isQRCodeScannerView = false // Dismiss QRCodeScannerView after scanning
                }, dismissView: {
                    // Action to dismiss the QR code scanner
                    isQRCodeScannerView = false // Dismiss the scanner when the back button is tapped
                })
                .edgesIgnoringSafeArea(.all)
            } else if isPersonalInfoView {
                PersonalInfoView(isPersonalInfoView: $isPersonalInfoView)
            } else if isHelpView {
                HelpView(isHelpView: $isHelpView) // Use the binding variable in the preview
            } else if isCommunityGuidelinesView {
                CommunityGuidelinesView(isCommunityGuidelinesView: $isCommunityGuidelinesView)
            } else if isPrivacyPolicyView {
                PrivacyPolicyView(isPrivacyPolicyView: $isPrivacyPolicyView)
            } else if isTermsOfServiceView {
                TermsOfServiceView(isTermsOfServiceView: $isTermsOfServiceView)
            } else if isDataManagementView {
                DataManagementView(isDataManagementView: $isDataManagementView)
            } else {
                VStack {
                    ZStack {
                        // 中間的標題
                        HStack {
                            Spacer() // Push title to the center
                            
                            Text("設定")
                                .font(.headline)
                                .fontWeight(.bold)
                            
                            Spacer() // Keep title centered by adding another spacer
                        }
                        .padding() // Overall padding for the HStack
                        
                        // 左上角的返回按鈕
                        HStack {
                            Button(action: {
                                // 當按下返回按鈕時關閉 SafetyCenterView
                                showSettingsView = false
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.gray) // 設置按鈕顏色
                            }
                            .padding(.leading) // 添加內邊距以確保按鈕不會緊貼邊緣
                            
                            Spacer() // This will push the button to the left
                        }
                    }
                    
                    Divider()
                    
                    // Settings content
                    List {
                        Section {
                            Button(action: {
                                isQRCodeScannerView = true // Navigate to QR Code Scanner
                            }) {
                                HStack {
                                    Image(systemName: "qrcode.viewfinder")
                                        .foregroundColor(.purple)
                                    Text("掃碼")
                                        .foregroundColor(.black) // Keep the text color unchanged when the button is tapped
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray) // Optional: Set the color of the chevron
                                }
                                .padding(.vertical, 10)
                                .background(Color.clear) // 加上透明背景
                            }
                            
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.orange)
                                Text("恢復購買")
                                Spacer()
                            }
                            .padding(.vertical, 10) // Adjust this value to increase the height
                            
                            HStack {
                                Image(systemName: "crown")
                                    .foregroundColor(.brown)
                                Text("開啟 SwiftiDate Supreme 會員標誌")
                                Spacer()
                                Toggle("", isOn: .constant(true))
                                    .labelsHidden()
                            }
                            .padding(.vertical, 10) // Adjust this value to increase the height
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.pink)
                                Text("邀請好友一起玩SwiftiDate")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray) // Optional: Set the color of the chevron
                            }
                            .padding(.vertical, 10) // Adjust this value to increase the height
                            
                            HStack {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.pink)
                                Text("兌換會員")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray) // Optional: Set the color of the chevron
                            }
                            .padding(.vertical, 10) // Adjust this value to increase the height
                            
                            Button(action: {
                                isPersonalInfoView = true // Navigate to Personal Info View
                            }) {
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.cyan)
                                    Text("個人資料")
                                        .foregroundColor(.black) // Keep the text color unchanged when the button is tapped
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 10)
                                .background(Color.clear)
                            }
                        }
                        
                        Section {
                            Button(action: {
                                checkIfMailIsSetup()
                            }) {
                                HStack {
                                    Text("客服")
                                        .foregroundColor(.black) // 確保字體顏色為黑色
                                        .padding(.vertical, 10) // Adjust this value to increase the height
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray) // Optional: Set the color of the chevron
                                }
                            }
                            .alert(isPresented: $isShowingCustomerServiceAlert) {
                                Alert(
                                    title: Text("請設置郵箱"),
                                    message: Text("需要設置郵箱才可以發送反饋給我們"),
                                    primaryButton: .default(Text("去設置"), action: {
                                        // 跳轉到郵箱設置頁面
                                        if let url = URL(string: "App-Prefs:root=MAIL") {
                                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                        }
                                    }),
                                    secondaryButton: .cancel(Text("不用了"))
                                )
                            }

                            Button(action: {
                                isHelpView = true // Show HelpView
                            }) {
                                HStack {
                                    Text("幫助")
                                        .padding(.vertical, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.black) // Keep the text color unchanged when the button is tapped
                            }
                            
                            HStack {
                                Text("語言")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }

                            Button(action: {
                                isCommunityGuidelinesView = true
                            }) {
                                HStack {
                                    Text("社區規範")
                                        .padding(.vertical, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.black) // Keep the text color unchanged when the button is tapped
                            }

                            Button(action: {
                                isPrivacyPolicyView = true // Show PrivacyPolicyView
                            }) {
                                HStack {
                                    Text("隱私權政策")
                                        .padding(.vertical, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.black) // Keep the text color unchanged when the button is tapped
                            }

                            Button(action: {
                                isTermsOfServiceView = true // Show TermsOfServiceView
                            }) {
                                HStack {
                                    Text("服務協議")
                                        .padding(.vertical, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            .foregroundColor(.black) // Keep the text color unchanged when the button is tapped

                            Button(action: {
                                isDataManagementView = true // Navigate to DataManagementView
                            }) {
                                HStack {
                                    Text("數據管理")
                                        .padding(.vertical, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.black) // Maintain text color
                            }

                            HStack {
                                Text("資料恢復")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }

                            Button(action: {
                                showUpdatePopup = true // Show the update popup when tapped
                            }) {
                                HStack {
                                    Text("檢查版本更新")
                                        .padding(.vertical, 10)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .foregroundColor(.black) // Keep the text color unchanged when the button is tapped
                            }
                            
                            HStack {
                                Text("戀愛性格測驗")
                                    .padding(.vertical, 10)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            
//                            HStack {
//                                Text("MBTI測驗")
//                                    .padding(.vertical, 10)
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
                        }
                        
                        Section {
                            Button(action: {
                                isShowingLogoutAlert = true // Show the alert when tapped
                            }) {
                                Text("登出")
                                    .padding(.vertical, 10) // Adjust this value to increase the height
                                    .frame(maxWidth: .infinity, alignment: .leading) // Extend Text to the full width
                                    .background(Color.white) // Make sure the background is set to white
                                    .foregroundColor(.red) // Set the text color to red
                            }
                            .alert(isPresented: $isShowingLogoutAlert) {
                                Alert(
                                    title: Text("一旦登出，你的登入資料將被清除"),
                                    primaryButton: .default(Text("取消")),
                                    secondaryButton: .destructive(Text("確定"), action: {
                                        saveUserState() // 在登出前保存用戶資料
                                        // 更新登錄狀態
                                        appState.isLoggedIn = false // 切換到未登錄狀態
                                    })
                                )
                            }
                        }
                        
                        Section {
                            Text("關閉帳號")
                                .padding(.vertical, 10) // Adjust this value to increase the height
                                .frame(maxWidth: .infinity, alignment: .leading) // Extend Text to the full width
                                .background(Color.white) // Make sure the background is set to white
                        }
                    }
                }
            }
            
            if showUpdatePopup {
                // Custom Popup View
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 20) {
                        // Add a close button in the top-right corner
                        HStack {
                            Spacer() // Push the X button to the right
                            Button(action: {
                                showUpdatePopup = false // Close the popup when "X" is tapped
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                    .foregroundColor(.gray)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)) // Adjust padding values
                            }
                        }
                        
                        // Image (Add your custom image here)
                        Image(systemName: "rocket.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding(.top, 20)
                        
                        Text("目前已經是最新版本")
                            .font(.headline)
                            .padding(.horizontal, 20)
                        
                        Text("超多免費的新功能，輕鬆脫單無負擔，快來體驗全新 SwiftiDate 吧～")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Button(action: {
                            showUpdatePopup = false // Close the popup when "好的" button is tapped
                        }) {
                            Text("好的")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 40)
                                .background(Color.green)
                                .cornerRadius(20)
                        }
                        .padding(.bottom, 20)
                    }
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                }
            }
        }
    }
    
    // No need for saveUserState as @AppStorage handles persistence
    func saveUserState() {
        let defaults = UserDefaults.standard
        defaults.set(userSettings.globalPhoneNumber, forKey: "phoneNumber")
        defaults.set(userSettings.globalUserName, forKey: "userName")
        defaults.set(userSettings.globalUserGender.rawValue, forKey: "userGender")
        defaults.set(userSettings.globalIsUserVerified, forKey: "isUserVerified")
        defaults.set(userSettings.globalTurboCount, forKey: "turboCount")
        defaults.set(userSettings.globalCrushCount, forKey: "crushCount")
        defaults.set(userSettings.globalPraiseCount, forKey: "praiseCount")
        defaults.set(userSettings.globalLikesMeCount, forKey: "likesMeCount")
        defaults.set(userSettings.globalLikeCount, forKey: "likeCount")
        defaults.set(userSettings.isSupremeUser, forKey: "isSupremeUser")
        print("Debug - User data has been saved to UserDefaults.")
    }
    
    // 檢查是否有設置郵箱帳戶
    func checkIfMailIsSetup() {
        if MFMailComposeViewController.canSendMail() {
            // 設置郵件數據
            mailData = MailData(subject: "反饋", recipients: ["support@swiftidate.com"], messageBody: "請描述您遇到的問題")
            isShowingMailComposer = true // 顯示郵件撰寫頁面
        } else {
            // 未設置郵箱，顯示提醒框
            isShowingCustomerServiceAlert = true
        }
    }
}

// 自定義的郵件撰寫視圖
struct MailComposeView: UIViewControllerRepresentable {
    var data: MailData
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setSubject(data.subject)
        mailComposeVC.setToRecipients(data.recipients)
        mailComposeVC.setMessageBody(data.messageBody, isHTML: false)
        mailComposeVC.mailComposeDelegate = context.coordinator
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}

// 定義郵件數據模型
struct MailData {
    var subject: String
    var recipients: [String]
    var messageBody: String
}

struct SettingsView_Previews: PreviewProvider {
    @State static var showSettingsView = true // Provide a sample state variable for the preview

    static var previews: some View {
        SettingsView(showSettingsView: $showSettingsView) // Use the binding variable in the preview
    }
}
