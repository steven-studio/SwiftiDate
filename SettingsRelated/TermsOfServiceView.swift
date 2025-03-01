//
//  TermsOfServiceView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/24.
//

import SwiftUI

struct TermsOfServiceView: View {
    @Binding var isTermsOfServiceView: Bool

    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    AnalyticsManager.shared.trackEvent("TermsOfServiceView_BackTapped", parameters: nil)
                    isTermsOfServiceView = false // Dismiss TermsOfServiceView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Text("服務條款")
                    .font(.headline)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("SwiftiDate 提供在線社交網絡服務。本協議包括 SwiftiDate 網站和應用程式上的服務和內容，您的權利、義務和限制，以及 SwiftiDate 的服務條款。為了使用某些 SwiftiDate 服務，您可能須下載軟件或內容，並/或同意額外的條款和條件。請您在註冊為用戶前，仔細閱讀本服務條款及其所有附表，以確保您完全理解所有條款。如有問題，請發送電子郵件至 support@SwiftiDate.sg，主題為：服務條款。")
                        .padding(.bottom, 10)
                    
                    Text("SwiftiDate 可能會不時修改本協議，修改後的協議將在 SwiftiDate 的官方網站上發布並立即生效。您理解並同意，繼續使用 SwiftiDate 服務即表示接受修改後的協議。SwiftiDate 保留自行決定拒絕、限制、暫停或終止您的服務訪問權利，並無需事先通知或對此承擔任何責任。如果 SwiftiDate 認為您對 SwiftiDate 或其成員構成威脅，SwiftiDate 有權刪除您的個人資料並/或限制、暫停或終止您的訪問權利。")
                        .padding(.bottom, 10)
                    
                    Text("SwiftiDate 可能包含不準確、不適當、冒犯性或露骨的信息，或者其他違反本協議第 7 條的內容。SwiftiDate 對此不承擔任何責任或義務。")
                }
                .padding()
                
                // Section Title
                Text("1. 資格")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("欲在SwiftiDate上創建帳戶，您需向我們提供您的姓名、電子郵件地址和/或手機號碼，設定密碼，並同意SwiftiDate的用戶協議。該協議設定了SwiftiDate如何處理您的信息。在註冊過程中，您還可以提供其他信息（如性別、年齡、職位、公司、愛好等）以創建您的個人資料，並在SwiftiDate上獲得更多個性化的服務。")
                        .padding(.bottom, 10)
                    
                    Text("在SwiftiDate上使用某些功能，您可能需要使用SwiftiDate的通訊錄或“聯繫人”導入器（或其他類似功能）將您的電話通訊錄上傳到SwiftiDate的服務。您上傳或同步的任何信息都將受到用戶協議的約束。您可以隨時刪除您的通訊錄和任何其他同步信息。使用Omi的服務，表示您同意SwiftiDate按照其服務條款收集、使用和共享您的信息。如果有任何變更，您繼續使用Omi的服務即表示您接受修訂後的服務條款。通過使用Omi的服務，您聲明並保證：")
                        .padding(.bottom, 10)

                    Text("(a) 您提交的所有註冊信息都是真實準確； (b) 您將保持此類信息的準確性； (c) 您使用SwiftiDate提供的服務不違反任何適用的法律或法規。")
                        .padding(.bottom, 10)

                    Text("如果SwiftiDate認為您未滿18歲或未達到成年年齡，SwiftiDate可能會刪除您的個人資料並終止您的會員資格，恕不另行通知。")
                        .padding(.bottom, 10)

                    Text("在提供服務的過程中，SwiftiDate將收集、存儲和使用以下與您相關的信息：")
                        .padding(.bottom, 10)

                    Text("1. 您在創建帳戶或使用Omi提供的服務時提供的信息，例如姓名、電話號碼、電子郵件地址和信用卡詳細信息；")
                        .padding(.bottom, 10)

                    Text("2. 您在使用SwiftiDate提供的服務時提供的信息，包括您共享的信息和您使用SwiftiDate提供的服務存儲的信息，以供他人分享；")
                        .padding(.bottom, 10)

                    Text("3. 其他人使用SwiftiDate提供的服務提供的關於您的共享信息，例如包含在他們發布的帖子中的信息或您與其他使用SwiftiDate提供的服務的人之間交換的信息；")
                        .padding(.bottom, 10)

                    Text("4. Omi在您使用服務時收集的信息，例如位置數據、日誌數據和公共信息。")
                        .padding(.bottom, 10)
                    
                    Text("在提供服務時，Omi將收集、存儲和使用位置數據。如果您不再希望Omi收集您的位置數據，您可以通過Omi的服務刪除這些數據。")
                        .padding(.bottom, 10)

                    Text("Omi會在您使用服務時收集、存儲和使用“日誌數據”，這是Omi在提供服務過程中自動收集的技術信息。")
                        .padding(.bottom, 10)

                    Text("本協議在您註冊成為Omi的服務使用者時生效，並在您的會員資格期間持續有效。您可以隨時終止您的會員資格。Omi也可以隨時終止您的會員資格，恕不另行通知。即使會員資格終止，本協議仍將繼續有效。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                // Section Title
                Text("2. 個人信息的隱私")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("除了在本服務條款中許可或經您單獨同意之外，Omi不會將您的個人資訊轉讓給任何第三方。 然而，SwiftiDate及其關聯公司可能會在集團內部，以及與合作夥伴和第三方服務供應商、承包商和代理商（例如，負責代表SwiftiDate發送電子郵件或推播通知的提供者、協助SwiftiDate和您共享位置 資料的地圖服務提供者、協助SwiftiDate進行業務分析的合作夥伴以及廣告合作夥伴）分享您的個人資訊。 此外，SwiftiDate可能允許這些第三方在提供服務的過程中收集您的個人資訊。 在每種情況下，Omi允許這些資訊的共享和/或收集的目的包括：(i) 提供SwiftiDate的服務給您；(ii) 輔助Omi實現在「我們如何使用您的資訊」部分中規定的目標 ；(iii) 履行SwiftiDate的義務並執行SwiftiDate在服務條款下的權利；和/或(iv) 支持SwiftiDate的業務運作，包括改進SwiftiDate的服務。 這些第三方可能會在其管轄區之外儲存和使用您的個人資訊。 在允許任何第三方按照上述規定收集和使用您的個人資訊時，SwiftiDate將盡合理努力確保這些第三方只會：(i) 遵守Omi的服務條款；(ii) 遵守給予他們的指示，包括SwiftiDate實施 的任何適當的保密和安全措施。")
                        .padding(.bottom, 10)
                    
                    Text("您同意SwiftiDate或其關聯公司可能需要保留、保存或披露您的個人信息，以：(i) 遵守適用的法律或法規；(ii) 遵守法院命令、傳票或其他法律程序；(iii) 響應政府、 執法機構或類似機構的要求（無論他們位於您的司法管轄區或其他地方）；或(iv) 在SwiftiDate認為合理必要的情況下，遵守適用的法律或法規。 您也同意SwiftiDate或其關聯公司可能需要揭露您的個人資訊，以執行服務條款，或保護SwiftiDate、其關聯公司或Omi的其他使用者的權利、財產或安全。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                // Section Title
                Text("3. 密碼")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("當您註冊成為會員時，您將需要設定一個密碼。您需全權負責保護您的密碼的機密性。您同意不將您的帳戶、用戶名或密碼提供給其他會員使用，或將您的密碼透露給任何第三方。如果您懷疑您的帳戶或密碼被未經授權的使用或訪問，您應立即通知Omi，請以電子郵件方式聯繫 support@SwiftiDate.sg。請注意，您需對您帳戶的所有使用行為負責。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                // Section Title
                Text("4. 會員非商業性使用")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("SwiftiDate提供的服務僅供會員個人使用，並不允許用於任何商業活動，除非獲得SwiftiDate的明確認可或批准。任何非法和/或未經授權的使用SwiftiDate服務的行為，包括但不限於收集會員的用戶名和/或電子郵件地址以發送未經請求的電子郵件，或透過未經授權的框架或鏈接到SwiftiDate網站，都將被嚴格禁止。任何商業廣告、附屬鏈接和其他形式的推廣可能會在未經通知的情況下從會員資訊中刪除，並可能導致會員特權被終止。對於任何非法或未經授權使用SwiftiDate服務的行為，我們將採取適當的法律行動。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                // Section Title
                Text("5. SwiftiDate內容的所有權")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("1. 當您在SwiftiDate提供的服務上或通過SwiftiDate提供的服務展示或發布任何內容時，您在此授予SwiftiDate有限許可，僅在SwiftiDate提供的服務上或通過SwiftiDate提供的服務使用、修改、公開演出、公開展示、複製和分發該等內容。")
                        .padding(.bottom, 10)
                    
                    Text("2. 您聲明並保證：(i) 您擁有或以其他方式有權向Omi授予本條款中所述的許可，且 (ii) 您在Omi提供的服務上或通過Omi提供的服務發布的內容不侵犯任何人的隱私權、公眾權、版權、合約權或任何其他權利。您同意支付所有因您在Omi提供的服務上或通過Omi提供的服務發布的任何內容而欠任何人的版稅、費用和其他款項。")
                        .padding(.bottom, 10)

                    Text("3. SwiftiDate提供的服務包含由SwiftiDate產生的內容，該內容受版權、商標、專利、商業秘密和其他法律保護，且SwiftiDate擁有並保留所有對SwiftiDate提供的服務中SwiftiDate所產生的內容的權利。SwiftiDate在此授予您有限的、可撤銷的、不可再許可的許可，僅供您個人使用和瀏覽SwiftiDate網站及使用SwiftiDate提供的服務，以複製和展示SwiftiDate所產生的內容（不包括任何軟體代碼）。任何因您不當使用SwiftiDate內容所產生的責任由您自行承擔。")
                        .padding(.bottom, 10)

                    Text("4. SwiftiDate提供的服務包含會員和其他SwiftiDate許可方的內容。除了您發布的內容外，您不得複製、修改、翻譯、出版、廣播、傳輸、分發、表演、展示或出售在SwiftiDate提供的服務上或通過SwiftiDate提供的服務出現的任何內容。")
                        .padding(.bottom, 10)
                }
                .padding()

                // Section Title
                Text("6. 發佈內容")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("1. SwiftiDate有權刪除任何SwiftiDate認為違反本協議或可能具有冒犯性、非法、侵犯他人權利、傷害或威脅他人安全的內容。SwiftiDate沒有責任監控SwiftiDate服務中的不當內容或行為。儘管SwiftiDate可能選擇在任何時候自行監控SwiftiDate服務，但SwiftiDate對於服務中的內容沒有責任，也無義務修改或刪除任何不適當的內容，並且對於提交任何此類內容的用戶的行為不承擔任何責任。")
                        .padding(.bottom, 10)
                    
                    Text("2. 您聲明並保證：(i) 您擁有或以其他方式有權向SwiftiDate授予本條款中所述的許可，且 (ii) 您在SwiftiDate提供的服務上或通過SwiftiDate提供的服務發布的內容不侵犯任何人的隱私權、公眾權、版權、合約權或任何其他權利。您同意支付所有因您在SwiftiDate提供的服務上或通過SwiftiDate提供的服務發布的任何內容而欠任何人的版稅、費用和其他款項。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                // Section Title
                Text("7. 禁止內容/活動")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("以下是在Omi服務上或通過Omi服務進行的非法或被禁止的行為。Omi保留對任何違反這些規定的人進行調查並採取適當法律行動的權利，包括但不限於，刪除違規的通訊，終止違規者的會員資格，並向違規者索賠。被禁止的內容包括但不限於以下類型：")
                        .padding(.bottom, 10)
                    
                    Text("1. 宣揚任何形式的種族主義、偏見、仇恨或對任何群體或個人的身體傷害；")
                        .padding(.bottom, 10)
                    
                    Text("2. 違反任何專利權；")
                        .padding(.bottom, 10)

                    Text("3. 騷擾或鼓勵騷擾他人；")
                        .padding(.bottom, 10)
                    
                    Text("4. 以性或暴力的方式剝削他人；")
                        .padding(.bottom, 10)

                    Text("5. 包含裸露、暴力或令人反感的主題，或包含成人網站的鏈接；")
                        .padding(.bottom, 10)

                    Text("6. 向 18 歲以下的人索取個人信息；")
                        .padding(.bottom, 10)

                    Text("7. 提供任何電話號碼、街道地址、姓氏、網址或電子郵件地址；")
                        .padding(.bottom, 10)

                    Text("8. 宣傳您明知是虛假或誤導性的資訊，或宣傳非法活動或行為；")
                        .padding(.bottom, 10)

                    Text("9. 宣傳非法或未經授權複製他人受版權保護的作品；")
                        .padding(.bottom, 10)

                    Text("10. 涉及“垃圾郵件”、“連鎖信”或未經請求的群發郵件、即時消息；")
                        .padding(.bottom, 10)

                    Text("11. 包含受限或僅能以密碼訪問的頁面或隱藏頁面或圖像；")
                        .padding(.bottom, 10)

                    Text("12. 宣傳任何犯罪活動或企業，或提供有關非法活動的指導信息；")
                        .padding(.bottom, 10)

                    Text("13. 出於商業或非法目的向其他會員索取密碼或個人識別信息；")
                        .padding(.bottom, 10)

                    Text("14. 未經我們事先書面同意涉及商業活動和/或銷售；")
                        .padding(.bottom, 10)

                    Text("15. 在未經他人同意的情況下發布他人的照片；")
                        .padding(.bottom, 10)

                    Text("16. 使用性暗示圖片或任何其他旨在吸引流量的不公平、誤導性或欺騙性內容。")
                        .padding(.bottom, 10)

                    Text("以下是在Omi平台上非法或被禁止的活動：")
                        .padding(.bottom, 10)

                    Text("1. 犯罪或侵權活動，包括兒童色情、欺詐、販運淫穢材料、毒品交易、賭博、騷擾、跟踪、垃圾郵件、發送惡意或有害文件、版權侵權、專利侵權或盜竊商業秘密；")
                        .padding(.bottom, 10)

                    Text("2. 通過使用SwiftiDate服務，向其他會員發送任何連鎖信或垃圾郵件；")
                        .padding(.bottom, 10)

                    Text("3. 使用 HTML/CSS 覆蓋或隱藏您的個人資料頁面或任何SwiftiDate頁面上的橫幅廣告；")
                        .padding(.bottom, 10)

                    Text("4. 使用任何自動化系統，例如使用腳本添加朋友或發送評論或消息；")
                        .padding(.bottom, 10)

                    Text("5. 干擾、擾亂SwiftiDate服務或網絡，或對其造成過度負擔；")
                        .padding(.bottom, 10)

                    Text("6. 試圖冒充其他成員或個人；")
                        .padding(.bottom, 10)

                    Text("7. 將您的SwiftiDate播放器的代碼複製到其他資料中，或要求其他成員將其嵌入到他們的個人資料中；")
                        .padding(.bottom, 10)

                    Text("8. 使用其他會員的帳戶、用戶名或密碼，或將您的密碼透露給任何第三方，或允許任何第三方訪問您的帳戶；")
                        .padding(.bottom, 10)

                    Text("9. 出售或以其他方式轉讓您的個人資料；")
                        .padding(.bottom, 10)

                    Text("10. 使用從SwiftiDate服務中獲得的任何資訊來騷擾、辱罵或傷害他人；")
                        .padding(.bottom, 10)

                    Text("11. 在您的個人資料上展示廣告，或接受來自第三方的付款或任何有價物品，以換取您在SwiftiDate服務上或通過SwiftiDate服務進行的任何商業活動；")
                        .padding(.bottom, 10)

                    Text("12. 以任何不符合適用法律法規的方式使用SwiftiDate服務。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                // Section Title
                Text("8. 版權政策")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("您不得以任何方式發布、修改、分發或複製任何受版權保護的材料、商標，或未經所有者事先書面同意的其他專有資訊。根據Omi的政策，如果您在收到版權方對Omi的適當通知後，繼續侵犯他人的版權，將會導致您的會員特權被終止。如果您認為您的作品已被複製並在Omi服務上發佈，並構成版權侵權，請將以下信息發送至 support@Omi.sg：")
                        .padding(.bottom, 10)
                    
                    Text("(i) 版權所有者或被授權代表版權所有者行事的人的電子或實體簽名； (ii) 對您聲稱已被侵權的受版權保護作品的描述； (iii) 指出您聲稱被侵權的材料在Omi服務上的位置； (iv) 您的地址、電話號碼和電子郵件地址； (v) 一份您的書面聲明，聲明您有充分理由相信有爭議的使用未經版權所有者、其代理人或法律的授權； (vi) 您在適用法律處罰下作出的聲明，表明通知中的信息是準確的，並且您是版權所有者或被授權代表版權所有者行事。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                Text("9. 會員間的糾紛")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("您需要對與Omi的其他成員進行的所有互動負全責。雖然Omi保留權利，但我們並無義務監控您與其他成員之間的糾紛。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                Text("10. 隱私權")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("使用SwiftiDate的服務同時也需遵守SwiftiDate的隱私政策，該政策已被納入並作為本協議的一部分。")
                        .padding(.bottom, 10)
                }
                .padding()

                Text("11. 使用付費功能")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("SwiftiDate的部分增值服務需要付費使用。您在購買頁面上選擇並購買所需的增值服務，並進行支付。SwiftiDate 可能透過以下方式提供產品和服務供您購買（「應用內購買」）：iTunes、Google Play、運營商計費、SwiftiDate 直接計費或 SwiftiDate 授權的其他支付平台。在購買時，您應確認商品的類別、價格、數量、時長、使用方式、自動續訂期限（如果可選）等，並根據您的實際需求購買服務。付款後，您將被視為已確認購買，並且除非法律另有規定，您不得要求修改或退款。")
                        .padding(.bottom, 10)
                    
                    Text("如果您購買自動定期訂閱，您的付款方式將在您取消訂閱之前持續計費。如果您以未經調整的價格購買了增值服務，您在該增值服務有效期內將不受可能發生的價格調整影響，並無需支付額外費用；但在下次購買或自動續訂時，您需要以最新的標價付款。如果您不希望您的訂閱自動續訂，您可以按照[幫助 - 如何取消自動續訂？]中的指南和步驟操作。如果您未能在訂閱期結束前至少24小時取消自動續訂，您將被視為接受Omi根據協議和您選擇的自動續訂週期繼續收費。如果您在增值服務有效期內停止使用SwiftiDate，SwiftiDate 將不承擔退還剩餘期間的相應服務費的責任。在SwiftiDate上刪除您的帳戶或在您的設備上刪除SwiftiDate應用程序不會取消您的訂閱。")
                        .padding(.bottom, 10)

                    Text("您可能需要承擔因開具發票而產生的稅費、快遞費等費用，具體繳納的稅金、快遞費等會因您支付的金額及您所在地要求等有所差別，Omi將根據相關法律法規要求進行收取。")
                        .padding(.bottom, 10)

                }
                .padding()

                Text("12. 免責聲明")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("SwiftiDate對於在SwiftiDate網站上發布的任何不正確或不準確的內容或與SwiftiDate提供的服務相關或在其中使用的任何內容，無論是由SwiftiDate成員或任何設備或程序引起的，不承擔任何責任。成員在SwiftiDate上創建和發布的個人資料可能包含指向其他網站的鏈接。SwiftiDate不對此類網站上表達的內容、準確性或意見負責，並且此類網站不會被調查、監控或檢查其準確性或完整性。SwiftiDate提供的服務中包含的任何鏈接網站並不代表SwiftiDate對鏈接網站的認可或批准。當您訪問這些第三方網站時，您需要自行承擔風險。SwiftiDate也不對本SwiftiDate網站上發布的第三方廣告或通過SwiftiDate提供的服務、或其提供的商品或服務承擔任何責任。SwiftiDate不對任何SwiftiDate服務用戶的在線或離線行為負責。SwiftiDate不對任何錯誤、遺漏、中斷、刪除、缺陷、操作或傳輸延遲、通信線路故障、盜竊或破壞或未經授權訪問或更改任何成員通信負責。SwiftiDate不對任何因網絡、線路、計算機在線系統、服務器或提供商、計算機設備、軟件、或任何因互聯網或任何服務上的技術問題或交通擁堵而導致的電子郵件或播放器失敗、或對用戶或任何人的計算機造成的任何傷害或損壞負責。在任何情況下，SwiftiDate均不對任何損失或損害負責，包括人身傷害或死亡，無論是因為使用SwiftiDate提供的服務、參加SwiftiDate組織或贊助的活動、或來自任何在SwiftiDate提供的服務上或通過SwiftiDate提供的服務發布的內容，或來自SwiftiDate任何成員的行為的內容，無論是在線或離線。SwiftiDate提供的服務按“原樣”和可用的狀態提供，SwiftiDate明確否認任何適用於特定目的或不侵權的保證。SwiftiDate不能保證也不承諾使用SwiftiDate提供的服務的任何具體結果。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                Text("13. 責任限制")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("在任何情況下，SwiftiDate都不對您或任何第三方承擔任何間接、附帶、懲罰性、偶發性、特殊或懲罰性損害賠償，包括但不限於因使用我們的服務而導致的利益損失，即使SwiftiDate已被告知該等損害的可能性。無論本協議包含何種相反的條款，SwiftiDate對您承擔的責任，無論基於何種原因或何種形式的行為，均將限於您在會員期間支付給SwiftiDate的服務費用（如有）。SwiftiDate對於您或第三方的任何行為或不作為而導致的任何損害或損失，包括但不限於任何第三方的支付服務或互聯網訪問服務，不承擔任何責任。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                Text("14. 糾紛")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("對於與SwiftiDate提供的服務有關或涉及的任何爭議，您同意該爭議將受到香港法律的管轄，不考慮其法律衝突原則。您或SwiftiDate可以要求任何關於或涉及SwiftiDate提供的服務的爭議，必須透過香港的爭議解決程序進行仲裁，但這不妨礙SwiftiDate在有管轄權的法院尋求禁止性救濟。仲裁裁決將成為最終裁決，並對SwiftiDate和您具有約束力。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                Text("15. 賠償")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("您同意對SwiftiDate、其子公司、關聯公司及其各自的高級職員、代理人、合作夥伴和員工，賠償並使其免受任何損失、責任、索賠或要求，包括合理的律師費，這些損失或責任可能源於您違反本協議使用SwiftiDate提供的服務，或因此產生的任何第三方索賠，包括但不限於您違反本協議和/或任何違反您的陳述和保證，以及您在SwiftiDate網站或通過SwiftiDate提供的服務發布的任何內容。")
                        .padding(.bottom, 10)
                }
                .padding()
                
                Text("16. 其他")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensures left alignment
                    .padding(.horizontal) // Apply padding if needed

                VStack(alignment: .leading, spacing: 15) {
                    Text("您在使用SwiftiDate網站、軟體或SwiftiDate提供的任何服務時，應接受本協議，並在成為會員後進一步確認。本協議是您與SwiftiDate關於使用SwiftiDate提供的服務的完整協議。該服務由MATCHUP UK LIMITED提供，地址是UNIT 417, 4/F LIPPO CTR TOWER TWO NO 89 QUEENSWAY ADMIRALTY, HK。SwiftiDate未行使或執行本協議的任何權利或規定並不代表對該權利或規定的放棄。本協議中的標題僅供參考，並無法律或契約效力。本協議在法律允許的範圍內有效。如本協議的任何條款被判定為非法、無效或不可執行，該條款將與本協議分離，並不影響其餘條款的有效性與可執行性。本使用條款的版權屬於SwiftiDate，SwiftiDate保留對本使用條款的解釋權和修改權。如有任何疑問，請透過以下方式聯繫我們：support@SwiftiDate.sg。")
                        .padding(.bottom, 10)
                }
                .padding()
            }
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("PrivacyPolicyView_Appeared", parameters: nil)
        }
    }
}

// Preview for TermsOfServiceView
struct TermsOfServiceView_Previews: PreviewProvider {
    @State static var isTermsOfServiceView = true // Provide a sample state variable for the preview

    static var previews: some View {
        TermsOfServiceView(isTermsOfServiceView: $isTermsOfServiceView) // Use the binding variable in the preview
    }
}
