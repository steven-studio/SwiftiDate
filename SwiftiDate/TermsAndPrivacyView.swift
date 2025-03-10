//
//  TermsAndPrivacyView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/10.
//

import Foundation
import SwiftUI

struct DataItem: Identifiable {
    let id = UUID()
    let category: String
    let description: String
}

struct TermsAndPrivacyView: View {
    // 若要在此頁面本身提供「關閉」功能，可宣告以下變數：
    @Environment(\.presentationMode) var presentationMode
    
    let testData = [
        DataItem(category: "帳戶資料", description: "需要填入一些基本資訊..."),
        DataItem(category: "個人檔案", description: "包含照片、喜好等...")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("SWIFTIDATE隱私政策")
                    .font(.title)
                    .foregroundColor(.green)
                    .bold()
                    .padding(.top)
                    .padding(.bottom, 20)
                
                Text("""
    哈囉！歡迎閱讀 SwiftiDate 的隱私政策

    我們知道閱讀隱私政策可能不是每個人想做的事，但請聽我們說完！我們真的很用心將這份政策寫得清楚又有趣，因為我們希望你能看完！就像是你的數位好夥伴，我們會帶你了解我們收集哪些資料、為什麼收集，以及如何使用這些資料。所以放輕鬆，拿杯你喜歡的飲料，讓我們一起深入了解個資的世界吧！
    
    此隱私政策自 2025 年 3 月 10 日起生效。
    
    1. 我們是誰
    2. 此隱私政策的適用範圍
    3. 我們收集的資料
    4. 我們為何以及如何使用資料
    5. 我們如何分享資料
    6. 你的權利
    7. 我們的資料保留權限
    8. 兒童隱私
    9. 隱私政策的變更
    10. 如何聯絡我們
    11. 我們是誰
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    1. 我們是誰
                    """)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("""
    SwiftiDate 是一個社交網路平台，讓你能在安全、愉快的環境中交友。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    2. 此隱私政策的適用範圍
                    """)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("""
    此隱私政策適用於我們在 SwiftiDate 品牌下運營的網站、App、活動和其他服務。無論你是在尋找靈魂伴侶、參加我們的活動，或是使用我們其他很棒的服務，這份政策都適用。為了簡便起見，在此隱私政策中，我們統稱這些為「服務」。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    3. 我們收集的資料
                    """)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("""
    不用多說，要幫助你建立有意義的連結，當然需要你提供一些個人資訊，例如基本的個人資料及你希望認識的人類型。使用我們的服務時也會產生一些資訊，例如你登入的時間和使用服務的方式。我們可能也會從第三方獲取資料，例如當你使用 Facebook、Google 或 Apple帳號登入服務，或是將其他平台上的帳號資訊上傳以完成你的個人檔案。如果你對細節有興趣，請查看下方的資料表。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                // 如果你希望用你原本 SpreadSheet 的呼叫方式，可以先將 testData 轉成 [[String]]
                let spreadsheetData = testData.map { [ $0.category, $0.description ] }
                
                SpreadSheetViewRepresentable(view: SpreadSheetView(viewModel: spreadsheetData))
                    .frame(height: 250)  // 根據內容或需求設定高度
                    .padding(.horizontal, 40)

                Text("""
    一、隱私權保護政策的內容
    為了保障您的個人資料及隱私，本服務將嚴格遵守相關法令規定。若您不同意本政策內容，請立即停止使用本服務。
    
    二、個人資料的收集
    1. 本服務在您註冊帳號時，可能會收集您的手機號碼、電子郵件、姓名等資訊。
    2. 在使用過程中，本服務可能會記錄設備資訊、IP 位址、瀏覽器類型等技術性資料。
    
    三、個人資料的使用
    1. 本服務僅在提供與改善服務的必要範圍內使用您的個人資料。
    2. 本服務絕不會將您的個人資料用於未經授權的第三方營銷活動。
    
    四、個人資料的保護
    1. 本服務將採取合理的技術及管理措施，保護您的個人資料不被竊取、洩漏或篡改。
    2. 如因不可抗力或其他非本服務可歸責之事由導致資料外洩，本服務將盡速通知並協助您進行補救措施。
    
    五、Cookies 及類似技術
    本服務可能使用 Cookies 及其他類似技術，以利辨識使用者身分及提供更佳之服務體驗。
    
    六、第三方服務
    1. 本服務可能包含連結至第三方網站或服務，這些第三方有各自的隱私權保護政策。
    2. 建議您在使用該等第三方服務前，先行瞭解並同意其隱私權保護政策。
    
    七、隱私權政策的修訂
    本服務保留隨時修訂本政策之權利，修訂後的條文將於網站或 App 公告。建議您定期查閱以瞭解最新內容。
    
    八、聯絡方式
    如對本政策有任何疑問或建議，歡迎透過以下方式與我們聯繫：
    • 電子郵件：support@example.com
    • 客服電話：+886-2-12345678
    
    以上條款若與您原有認知或期待有所差異，請再次確認並考慮是否繼續使用本服務。如您繼續使用，將視為同意本隱私政策。
    
    （範例條款結束，請替換為真實條款）
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
            }
            .navigationTitle("SwiftiDate - Date & Meet Friends")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray.opacity(0.5)) // 可依設計需求調整顏色
                            .bold()
                    }
                }
            }
        }
    }
}

struct TermsAndPrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndPrivacyView()
    }
}
