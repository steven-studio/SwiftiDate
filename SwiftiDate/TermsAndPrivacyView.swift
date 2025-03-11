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

struct TableHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        // 我們可以取最大值，或進行其他合併運算
        value = max(value, nextValue())
    }
}

struct TermsAndPrivacyView: View {
    @State private var tableHeight: CGFloat = 250  // 預設一個最低高度
    @State private var tableHeight1: CGFloat = 250  // 用於第二個 SpreadSheetView
    @State private var tableHeight2: CGFloat = 250

    // 若要在此頁面本身提供「關閉」功能，可宣告以下變數：
    @Environment(\.presentationMode) var presentationMode
    
    private let spreadsheetView: SpreadSheetView = {
        let viewModel: [[String]] = [
            ["類別", "描述"],
            ["帳戶資料", "當你建立帳戶時，你需要提供一些基本資訊來設定帳戶，例如你的手機號碼、電子郵件地址和出生日期"],
            ["個人檔案資料", "當你完成個人檔案時，你會分享更多關於自己的細節，例如性別、興趣、偏好、大概位置等。在某些國家，這些資料可能被視為敏感或特殊資訊，例如關於性傾向、性生活、健康狀況或政治信仰的細節。如果你選擇提供這些資料，表示你同意我們依據本隱私政策使用這些資料。"],
            ["內容", "使用我們的服務時，你可能會上傳照片、影片、音檔、文字及其他類型的內容，例如與其他會員的聊天記錄。"],
            ["購買資料", "當你進行購買時，我們會保存交易細節（例如購買項目、交易日期及價格）。具體的資料取決於你選擇的支付方式。如果你是直接向我們支付（而非透過 iOS 平台)，你需要提供銀行卡或信用卡號碼或其他金融資料。"],
            ["行銷、調查與研究資料", "我們有時會進行以下活動：(i)用於研究目的的問卷調查、焦點小組或市場研究；(ii)用於行銷目的的推廣活動、活動或比賽。當你選擇參與時，你會提供一些資訊以便我們處理你的參與內容，包括你的回答、回饋意見，以及電子郵件和電話號碼，方便我們進行後續研究。"],
            ["第三方資料", "當你選擇與我們分享關於其他人的資訊時（例如使用某些功能時輸入認識的人的聯絡資訊，或提交涉及其他會員的查詢或報告），我們會代你處理這些資料以完成你的請求。"],
            ["客戶支援資料", "當你聯絡我們時，你可能會提供一些資訊以幫助解決你的問題。其他人也可能提交與你相關的查詢或報告。此外，我們的審核工具和團隊在調查過程中也可能收集額外資料。"],
            ["社群媒體資料", "你可以選擇透過其他平台的帳戶與我們分享資料（例如 Facebook、Spotify 或 Apple）。例如，當你使用這些平台的帳戶建立或登入我們的服務，或上傳這些平台上的資料（如照片或播放清單)到我們的服務時，我們會處理相關資料。"]
        ]
        let view = SpreadSheetView(viewModel: viewModel)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spreadsheetView1: SpreadSheetView = {
        let viewModel: [[String]] = [
            ["類別", "描述"],
            ["使用資料", "使用服務會生成有關你活動的資料，包括你如何使用服務（例如登入時間、使用的功能、執行的操作、顯示給你的資訊、來源網頁、互動過的廣告）以及你與其他人互動的方式（例如搜尋、配對、交流）。我們也可能收到你與我們廣告在第三方網站或應用程式上互動的相關資料。"],
            ["技術資料", "使用服務會從您用於存取我們服務的裝置上收集數據，包括硬體和軟體訊息，如IP 位址、裝置ID 和類型、應用程式設定和特徵、應用程式崩潰、廣告ID 和與Cookie 或其他可能唯一標識設備或瀏覽器的技術相關的識別碼。"]
        ]
        let view = SpreadSheetView(viewModel: viewModel)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let spreadsheetView2: SpreadSheetView = {
        let viewModel: [[String]] = [
            ["類別", "描述"],
            ["地理位置資料", "如果你允許，我們可以從你的裝置收集地理位置（經緯度）。如果你拒絕授權，依賴精確地理位置的功能可能無法使用。"],
            ["臉部幾何資料", "你可以選擇參與我們的某些功能，例如照片驗證，在某些地區這可能被視為生物特徵數據。"]
        ]
        let view = SpreadSheetView(viewModel: viewModel)
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
                
                VStack(alignment: .leading) {
                    Text("""
                    你提供給我們的資料
                    """)
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                SpreadSheetViewRepresentable(view: spreadsheetView, contentHeight: $tableHeight, multiplier: 2.0/8.0)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TableHeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(TableHeightPreferenceKey.self) { newHeight in
                        tableHeight = newHeight
                    }
                    .frame(height: tableHeight + 50)
                    .padding(.horizontal, 28)
                
                VStack(alignment: .leading) {
                    Text("""
                    自動生成或收集的資料
                    """)
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                SpreadSheetViewRepresentable(view: spreadsheetView1, contentHeight: $tableHeight1, multiplier: 15.0/85.0)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TableHeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(TableHeightPreferenceKey.self) { newHeight in
                        tableHeight1 = newHeight
                    }
                    .frame(height: tableHeight1 + 50)
                    .padding(.horizontal, 28)
                
                VStack(alignment: .leading) {
                    Text("""
                    我們在獲得你同意後收集的其他資料
                    """)
                    .font(.body)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                SpreadSheetViewRepresentable(view: spreadsheetView2, contentHeight: $tableHeight2, multiplier: 2.0/8.0)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TableHeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(TableHeightPreferenceKey.self) { newHeight in
                        tableHeight2 = newHeight
                    }
                    .frame(height: tableHeight2 + 50)
                    .padding(.horizontal, 28)

                
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
