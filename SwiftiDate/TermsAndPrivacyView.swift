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
    @State private var tableHeight3: CGFloat = 250
    @State private var tableHeight4: CGFloat = 250
    @State private var tableHeight5: CGFloat = 250

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
        view.cellWidthMultiplier = 2.0 / 8.0
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
        view.cellWidthMultiplier = 15.0 / 85.0
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
        view.cellWidthMultiplier = 2.0 / 8.0
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spreadsheetView3: SpreadSheetView = {
        let viewModel: [[String]] = [
            ["處理你資料的目的", "處理你資料的依據", "處理的資料類別(詳見本政策的第 3 節)"],
            ["為了讓你使用我們的服務，包括：(i) 建立並維護你的帳戶和個人檔案；(ii) 運營並維護我們服務的各種功能；(iii) 向你推薦其他會員，並將你推薦給其他會員；(iv) 舉辦抽獎活動和比賽；(v) 回應你的請求和問題；(vi) 監控我們服務的正常運作，並在需要時排查和修復問題；(vii) 處理你申請加入我們高級服務的申請。", "履行我們與你的合約。你的同意（當處理敏感資料或其他需經同意的資料時）", "處理的資料類別：帳戶資料、個人檔案資料、內容、購買資料、行銷、調查與研究資料、第三方資料、客戶支援資料、社群媒體資料、使用資料、技術資料、地理位置資料、臉部幾何資料"],
            ["為了在我們的服務上促成你的購買，包括：(i) 處理付款；(ii) 提供折扣和促銷，調整價格。", "履行我們與你的合約", "帳戶資料、個人檔案資料、技術資料、購買資料、使用資料"],
            ["為了運營廣告和行銷活動，包括：(i) 執行並衡量在我們服務上運行的廣告活動效果；(ii) 執行並衡量在第三方平台上推廣我們自身服務的行銷活動效果；(iii) 與你溝通我們認為可能對你有興趣的產品和服務。", "同意（如適用法律要求）以及我們的合法利益。推廣我們的服務並向會員展示量身訂做的廣告是我們的合法利益所在，這有助於提升會員體驗並支持我們免費服務的運營。", "帳戶資料、個人檔案資料、使用資料、行銷、調查與研究資料、技術資料"],
            ["為了改進我們的服務並創建新的功能和服務，包括：(i) 執行焦點小組、市場研究和問卷調查；(ii) 分析我們服務的使用情況；(iii) 檢視與客戶服務團隊的互動以提升服務質量；(iv) 開發和改進新功能和服務，包括透過機器學習和其他技術進行測試；(v) 進行研究並發表研究論文。", "履行我們與你的合約。我們的合法利益：持續改進服務是我們的合法利益所在。當適用法律要求時，會徵得你的同意（例如，在某些國家我們可能會處理被視為敏感或特殊的資料，以確保使用我們服務的各社群能夠公平對待，並保持我們服務的多元與包容性）。", "帳戶資料、個人檔案資料、內容、購買資料、行銷、調查與研究資料、第三方資料、客戶支援資料、社群媒體資料、使用資料、技術資料"],
            ["為了遵守適用法律、建立、行使和捍衛法律權利，包括：(i) 保存資料以遵守並證明遵守適用法律；(ii) 支援調查並捍衛潛在或正在進行的訴訟、監管行動或爭議；(iii) 回應執法機構、法院、監管機構及其他第三方的合法請求；(iv) 向執法機構、政府或其他當局報告非法或侵權內容；(v) 建立、行使或捍衛持續或威脅中的訴訟；(vi) 與執法機構或合作夥伴分享資料，以打擊濫用或非法行為。", "我們的合法利益：遵守適用法律並保護我們自己、我們的會員及其他人是我們的合法利益所在，這也包括在調查、法律程序及其他爭議中的行使權利。保護你和其他會員的生命利益。遵守對我們的法律義務，例如回應執法機構的資料請求。", "分享的資料類別將根據每個義務、強制性利益或爭議的具體情況有所不同。"],
            ["為了提供安全保障：為了提升你使用我們及我們的關聯公司和合作夥伴提供服務的安全性，保護你、其他用戶或公眾的個人安全，防止財產侵害，並採取更有效的措施對抗網路釣魚網站、詐騙、網路漏洞、電腦病毒、網路攻擊、網路入侵及其他安全風險，更準確地識別違反法律法規或SwiftiDate相關協議及規定的行為", "我們可能會使用或結合你的用戶信息、交易信息、設備信息、相關網路日誌及我們的關聯公司和合作夥伴根據你的授權或依法律規定分享的信息，綜合判斷你的帳戶及交易風險，進行身份驗證，檢測並防範安全事件，並依法律進行必要的記錄、審核、分析及處理措施。", "帳戶資料、內容、購買資料、使用資料、技術資料"]
        ]
        let view = SpreadSheetView(viewModel: viewModel)
        // 例如設定比例為 1:4:4
        view.columnRatios = [4, 3, 2]
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spreadsheetView4: SpreadSheetView = {
        let viewModel: [[String]] = [
            ["接受者", "分享原因", "個人資料類別"],
            ["其他會員", "當你自願公開資料以供其他會員查看（例如你的公開檔案）時，你會與其他會員分享資料。如果有人提交報告指出你違反了我們的使用條款，我們可能會讓報告者知道我們根據其報告採取了哪些行動（如果有的話）。如果你提交關於其他會員的報告，也同樣適用此規定。", "個人檔案資料、內容、社群媒體資料、第三方資料、客戶支援資料"],
            ["服務提供商/合作夥伴", "我們會與幫助我們運營、推廣和改進服務的供應商和合作夥伴分享資料。他們為我們提供的服務包括資料托管和維護、分析、客戶服務、行銷、廣告、支付處理、法律支持和安全運營等。", "根據供應商或合作夥伴提供的服務，所涉及的資料可能包括：帳戶資料、個人檔案資料、內容、購買資料、行銷、調查與研究資料、第三方資料、客戶支援資料、社群媒體資料、使用資料、技術資料、地理位置資料、面部幾何資料。"],
            ["廣告合作夥伴", "我們可能會在我們的服務上發布有關第三方廣告商的產品和服務的廣告，並在第三方網站和應用程式上發布推廣我們自己服務的廣告。為了提高這些廣告的相關性，我們會將某些你的資料提供給第三方，包括廣告合作夥伴，或允許他們從我們的服務中收集這些資料（例如通過cookies、SDK或類似技術）。我們的一些廣告合作夥伴使我們能夠將你的電子郵件地址、廣告識別碼或電話號碼轉換為無法用來識別你的唯一識別碼，然後使用這個識別碼要麼將你排除在我們的行銷活動之外，要麼將我們的廣告定向給與你在背景、興趣或應用程式使用上相似的觀眾。", "帳戶資料、個人檔案資料、使用資料、技術資料"],
            ["執法機構", "我們可能會將你的資料透露給： (i) 為了遵守法律程序，例如法院命令、傳票或搜查令、政府/執法機構的調查或其他法律要求； (ii) 協助預防或偵測犯罪； (iii) 保護任何人的安全；以及 (iv) 建立、行使或捍衛法律主張。", "根據請求的具體情況，分享的資料類別會有所不同，但通常會包括：帳戶資料、個人檔案資料、內容、購買資料、客戶支援資料、第三方資料、社群媒體資料、使用資料、技術資料、地理位置資料。"],
            ["在合併與收購的情境下，與我們的關聯公司或新所有者", "如果我們涉及到合併、出售、收購、剝離、重組、改組、解散、破產或其他所有權或控制權變更，我們可能會轉移你的資料，無論是全部還是部分資料。", "分享的資料類別會根據具體的企業交易類型而有所不同，可能會包括整體組織資料或僅特定的子集，例如購買資料。"],
            ["當使用檔案分享功能時", "你可以選擇分享其他成員的檔案，他們也可以使用分享功能將你的檔案分享給我們服務之外的人。", "個人檔案內容"]
        ]
        let view = SpreadSheetView(viewModel: viewModel)
        // 例如設定比例為 1:4:4
        view.columnRatios = [15, 45, 30]
//        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let spreadsheetView5: SpreadSheetView = {
        let viewModel: [[String]] = [
            ["您的權利", "如何行使您的權利"],
            ["查閱、攜帶或知情權：有權了解我們處理的關於你的個人資料，以及要求獲得該資料的副本", "你可以直接登入你的帳戶來查閱和檢視一些資料。"],
            ["更正或修改權：有權修改或更新不準確或不完整的個人資料", "你可以直接在服務中更新你的資料，簡單地更新你的個人檔案。如果你希望更正其他資料，請通過此處聯繫我們。"],
            ["刪除或抹除權：有權刪除個人資料", "你可以直接在服務中刪除一些你提供的資料。你也可以透過這裡關閉你的帳戶，我們會根據隱私政策刪除你的資料。無論如何，你可以隨時聯繫我們。"],
            ["撤回同意權：有權撤回你所給予我們的同意，停止我們為特定目的處理你的個人資料", "你可以直接在裝置設定中撤回你所同意的裝置許可權（例如，撤回對某些裝置資料（如電話聯絡人、照片、廣告識別碼和位置服務）或推播通知的存取許可）。當你撤回同意時，某些服務可能會失去部分功能。"]
        ]
        let view = SpreadSheetView(viewModel: viewModel)
        view.cellWidthMultiplier = 3.0 / 6.0
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
                
                SpreadSheetViewRepresentable(view: spreadsheetView, contentHeight: $tableHeight)
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

                SpreadSheetViewRepresentable(view: spreadsheetView1, contentHeight: $tableHeight1)
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
                
                SpreadSheetViewRepresentable(view: spreadsheetView2, contentHeight: $tableHeight2)
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
                
                VStack(alignment: .leading) {
                    Text("""
                    4. 我們為何以及如何使用你的資料
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
    我們處理你資料的主要原因，是為了向你提供服務並不斷改進。這包括將你與可能讓你心動的會員連結，個性化你的使用體驗，並協助你充分利用我們的服務。我們也會處理你的資料，以確保你和所有會員在使用服務時的安全。我們非常重視這項責任，並不斷改進系統和流程，致力於保護你的安全。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                SpreadSheetViewRepresentable(view: spreadsheetView3, contentHeight: $tableHeight3)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TableHeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(TableHeightPreferenceKey.self) { newHeight in
                        tableHeight3 = newHeight
                    }
                    .frame(height: tableHeight3 + 50)
                    .padding(.horizontal, 28)
                
                VStack(alignment: .leading) {
                    Text("""
                    5. 我們如何分享資料
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
    由於我們的目標是幫助你建立有意義的連結，因此你的一些資料當然會對服務中的其他會員可見。我們也會與協助我們運營服務的服務提供商和合作夥伴分享資料。繼續閱讀以了解更多詳細信息。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)

                SpreadSheetViewRepresentable(view: spreadsheetView4, contentHeight: $tableHeight4)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TableHeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(TableHeightPreferenceKey.self) { newHeight in
                        tableHeight4 = newHeight
                    }
                    .frame(height: tableHeight4 + 50)
                    .padding(.horizontal, 28)
                
                VStack(alignment: .leading) {
                    Text("""
                    6. 你的權利
                    """)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                (
                    Text("我們希望您能夠掌控您的數據，因此我們想提醒您可以使用以下權利、選項和工具。根據您所居住的地區，您可能擁有不同的權利，或者這些權利可能有不同的名稱。如果您對您的權利以及如何行使這些權利有任何疑問，請通過")
                    + Text("此處").foregroundColor(.green)
                    + Text("與我們聯繫。")
                )
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)
                .padding(.bottom)
                
                SpreadSheetViewRepresentable(view: spreadsheetView5, contentHeight: $tableHeight5)
                    .overlay(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: TableHeightPreferenceKey.self, value: proxy.size.height)
                        }
                    )
                    .onPreferenceChange(TableHeightPreferenceKey.self) { newHeight in
                        tableHeight5 = newHeight
                    }
                    .frame(height: tableHeight5 + 50)
                    .padding(.horizontal, 28)
                
                Text("""
    為了保護你和我們所有成員的安全，我們可能會要求提供身份獲授權資訊來確認你是否有權代表某位成員提出請求，在處理上述請求之前，我們需要確保資料安全。我們不希望其他人能夠掌控你的資料！
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    請注意，我們可能會拒絕某些請求，包括無法驗證身份的情況，或請求違法、無效，或可能侵犯商業機密、智慧財產或他人隱私及其他權利的情況。如果你希望收到有關其他成員的資訊（例如，收到的消息副本），那麼該成員需要親自提出請求。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    7. 我們保留資料的時間
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
    我們希望你透過我們的服務建立的聯繫能夠永續存在，但我們只會在合理的商業需求下保留你的個人資料（如第4部分所述），並且符合法律規定的範圍內。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    如果你決定停止使用我們的服務，你可以關閉你的帳戶，並且你的個人資料將不再對其他成員可見。請注意，如果你兩年內未使用服務，我們會自動關閉你的帳戶。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    在帳戶關閉後，我們會按照以下規定刪除你的資料：
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    1. 為了保護我們成員的安全，我們實施三個月的安全保留其，這段期間內，我們會保留你的資料以便調查非法或有害行為。若你的帳戶遭到禁止，我們會保留資料長達一年。此段期間的資料保留是基於我們和潛在第三方受害者的正當利益。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    2. 我們會保留有限的資料以遵守法律上的資料保留義務，具體包括：交易資料保留10年，以符合稅務和會計要求；信用卡資訊保留至用戶有挑戰交易的權利為止；“流量數據”/日誌保留1年，以符合法律的資料保留要求；我們也會保留用戶給予我們的同意記錄5年，以證明我們遵守適用法律。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    3. 我們會根據正當利益保留有限的資料，具體包括：顧客服務交流紀錄自溝通日期起保留6年；顧客服務紀錄和支持資料，以及下載/購買的模糊位置，保留5年，以支持我們的安全措施，支持顧客服務決策，執行我們的權利，並在發生索賠時進行自我辯護；有關過去帳戶和訂閱的資訊，我們會在關閉你的最後一個帳戶後保留3年，以確保財務預測和報告的準確性；資料（如用戶個人資料）在潛在訴訟中會保留1年，以便為法律索賠的建立、行使或辯護做準備；防止被封禁成員重新註冊新帳戶的資料，會保留必要的時間，以確保我們成員的安全和重要利益。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    4. 最後，我們會基於正當利益保留資料，當存在未解決或潛在的問題、索賠或爭議時，這會要求我們保留資料，特別是在以下情況下：我們收到有效的法律傳票或要求，要求我們保留資料（此時我們需要保留資料以遵守法律義務）；資料可能在法律程序中必須使用。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                Text("""
    在法律允許的範圍內，我們可能會保留並使用那些無法單獨識別或專門歸屬於你的資料，用於本隱私政策中所述的目的，包括改善我們的服務、創建新功能、技術和服務，以及保持我們服務的安全性。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    8. 兒童隱私權
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
    我們的服務僅限於18歲或以上的個人使用。我們不允許18歲以下的個體在我們的平台上註冊。如果您懷疑某位會員年齡未滿18歲，請使用服務中提供的報告機制。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    9. 隱私政策的變更
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
    本政策可能會隨時間變更。我們始終在尋找新的創新方式，幫助您建立有意義的聯繫，並確保我們對資料處理方式的解釋保持最新。在重大變更生效之前，我們會通知您，讓您有時間審查變更內容。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
                
                VStack(alignment: .leading) {
                    Text("""
                    10. 如何聯絡我們
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
    您可以通過SwiftiDate的[設定 - 客戶服務]中的客服渠道，或通過我們的支持中心聯絡我們，我們將在30天內回應您的請求。
    """)
                .font(.body)
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)

                Text("""
    好了，這就是我們的隱私政策！希望它像我們所做的那樣既有趣又清晰。現在，讓我們一起開始創造一些美好的回憶吧！我們很高興能與您一同踏上這段旅程。
    """)
                .font(.footnote)
                .bold()
                .padding(.leading, 40)
                .padding(.trailing, 40)
                .lineSpacing(8)     // 調整行距，例如8個點
                .padding(.bottom)
            }
        }
    }
}

struct TermsAndPrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndPrivacyView()
    }
}
