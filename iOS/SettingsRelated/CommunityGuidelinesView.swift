//
//  CommunityGuidelinesView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/24.
//

import Foundation
import SwiftUI

struct CommunityGuidelinesView: View {
    @Binding var isCommunityGuidelinesView: Bool

    var body: some View {
        VStack {
            // Custom Navigation Bar
            HStack {
                Button(action: {
                    AnalyticsManager.shared.trackEvent("CommunityGuidelines_BackTapped", parameters: nil)
                    isCommunityGuidelinesView = false // Dismiss CommunityGuidelinesView
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.blue)
                }
                
                Text("社區規範")
                    .font(.headline)
                    .padding(.leading, 5)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Text("歡迎來到 SwiftiDate！")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("""
                    我們希望您能夠在 SwiftiDate 享受聊天交友的樂趣，也能感受到輕鬆和安心的社區氛圍。SwiftiDate 歡迎每一個能夠真誠、友善、懂得尊重他人的人，也歡迎並期待您能夠跟 SwiftiDate 一起建立一個和諧友好的交友平台。SwiftiDate 鼓勵用戶在不冒犯他人的前提下，自由、勇敢地表達和展現自己，收穫更多新鮮有趣的體驗。為了讓所有人有更好交友環境，請閱讀並遵守以下平台準則。任何違反準則的行為都有可能會導致您被禁止使用 SwiftiDate，並永久地失去您的帳號。
                    """)
                    .padding(.bottom, 10)
                    
                    Text("我們建議您在 SwiftiDate：")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. 使用本人真實照片")
                        Text("""
                        每個人都有可愛的一面！我們希望您能夠在 SwiftiDate 上展示真實的自我，請在上傳頭像照片，或傳送你的親照給你的配對對象時使用本人的照片，自信大方的照片將會使你魅力無限！
                        """)
                        
                        Text("2. 尊重其他用戶")
                        Text("""
                        SwiftiDate 致力於打造一個平等、多元化的交友平台，我們尊重每個人的身份、意識形態、價值觀。請您在使用 SwiftiDate 時也秉承著同樣開放包容的態度對待他人，理解並尊重他人。
                        """)
                        
                        Text("3. 發佈友好的內容")
                        Text("""
                        SwiftiDate 鼓勵用戶真誠、友善地表達自己的個性、觀點、想法，我們相信積極正向的交流，將帶來一個良好的交友環境。請您在使用 SwiftiDate 與其他用戶交流的時候，時刻注意自己的態度、語氣及用詞，友好友善地對待他人。
                        """)
                        
                        Text("4. 保護個人信息")
                        Text("""
                        SwiftiDate 提醒您提高警覺，時刻注意您的個人資料的保密，尤其涉及銀行賬戶、密碼、身份證件等個資，提防潛在風險，以免上當受騙。
                        """)
                        
                        Text("5. 豐富個人資料")
                        Text("""
                        SwiftiDate 鼓勵用戶盡量將您的個人資料填寫完整，豐富您的個人簡介，這樣有助於獲得其他用戶的信任，幫助其他用戶更好的瞭解您並與您配對。
                        """)
                    }
                    
                    Text("請勿在 SwiftiDate 上：")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. 使用非自己本人的照片或版權")
                        Text("""
                        SwiftiDate 對肖像權及版權採取非常嚴肅的態度，請勿使用他人（不管是你熟悉的還是網絡上）的照片作為頭像。請不要發佈未經授權或任何不屬於您的內容。
                        """)
                        
                        Text("2. 發表仇恨言論")
                        Text("""
                        SwiftiDate 尊重每個人的多樣性，任何針對種族、民族、宗教、殘疾、性別、年齡、國籍、性取向或性別認同等因素，煽動、鼓吹或縱容對個人或群體的種族主義、偏見、仇恨或暴力的內容和言論都是被嚴格禁止。
                        """)
                        
                        Text("3. 發佈裸露或色情內容")
                        Text("""
                        SwiftiDate 是一個健康、包容的交友平台，我們歡迎各種審美及穿搭品味。但為了使大多數人都能舒適地聊天和交友，SwiftiDate 嚴格禁止用戶在用戶名稱、自我介紹、聊天等任何場合發佈任何裸體、露骨、色情的圖片、影片、音頻、文字等內容。

                        特別提醒：男生請勿傳送自己的屌照，因為對大多數女生來說，這並不是她們想看到的內容；同樣地，女生請勿傳送自己的裸體照，這裡是一個交友平台，而不是進行不當交易或賣淫的地方。我們希望大家能在 SwiftiDate 上建立真誠、友善的互動，尊重彼此，並共同維護這個美好的社區氛圍。
                        """)
                        
                        Text("4. 發佈涉及暴力和身體傷害的內容")
                        Text("""
                        請勿發佈任何涉及暴力、血腥、犯罪的內容及言論，包括威脅、人身攻擊或宣傳恐怖主義。同樣的，SwiftiDate 也不允許傳播或鼓吹他人自殺或自殘的內容及言論。特別心理健康案例發生時，SwiftiDate 可能會採取一些干預措施來幫助用戶走出危機。
                        """)
                        
                        Text("5. 騷擾其他用戶")
                        Text("""
                        請勿參與或鼓勵他人參與針對任何其他用戶的辱罵或騷擾。這包括未經允許向您的配對對象發送涉及色情、暴力、跟蹤、威脅、恐嚇等內容及言論。如您遇到此類內容及言論，SwiftiDate 建議您及時檢舉，我們將嚴肅地處理所有檢舉事件。
                        """)

                        Text("6. 發佈涉及賣淫和拐賣的內容")
                        Text("""
                        請勿宣傳或鼓吹商業性服務、人口販賣或其他非自願性行為。如您遇到此類內容及言論，SwiftiDate 建議您及時檢舉，我們將嚴肅地處理所有檢舉事件。
                        """)

                        Text("7. 詐騙")
                        Text("""
                        請勿有試圖獲得其他用戶的私人資訊以進行欺詐的行為，這包括分享自己的收款資訊（銀行賬號、Paypal等）以獲得其他用戶的錢財。如您遇到此類內容及言論，SwiftiDate 建議您及時檢舉，我們將嚴肅地處理所有檢舉事件。

                        特別說明：SwiftiDate 的老闆本人曾經遭遇過詐騙，因此對於任何形式的欺詐行為都非常厭惡。我們非常重視保護用戶的財產安全，若您遇到詐騙，請務必及時檢舉，我們會全力協助您處理這類事件。畢竟，沒有人願意在交友的過程中蒙受財產的損失，而且詐騙案件通常還需要經過法院的程序，這是一件非常麻煩的事，我們希望能幫助您避免這樣的不愉快經歷。
                        """)

                        Text("8. 公開私人信息")
                        Text("""
                        為了您和他人的個資安全，請勿公開傳播任何私人資訊。這包括護照、駕駛證等身份證件資料、密碼、財務資訊或未公開的聯絡資訊，如電話號碼、電子郵件地址、家庭/工作地址等。
                        """)
                        
                        Text("9. 非法使用 SwiftiDate")
                        Text("""
                        請勿用 SwiftiDate 做任何違法的事情。如果在現實世界中是非法的，那麼它在 SwiftiDate 上也是非法的。
                        """)
                        
                        Text("10. 發佈外部鏈接、推廣或招攬")
                        Text("""
                        請勿在SwiftiDate上發佈前往外部網站的鏈接或其他方式。請勿在 SwiftiDate 上招攬其他用戶。您可以邀請配對對象參加自己的活動，但如果您個人資料的目的是宣傳您的商業業務、非營利性組織活動、競選活動等，我們可能會刪除您的帳號。
                        """)
                    }
                    
                    Text("如何匿名檢舉：")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. 在聊天消息頁面的右上角，點擊 ··· 圖標，發起匿名檢舉及封鎖（配截圖）")
                        
                        Text("2. 打開用戶的個人資料，點擊右上角的 ··· 圖標，發起匿名檢舉及封鎖（配截圖）")
                        
                        Text("若您濫用服務或有 SwiftiDate 視為不當、不合法或違反《平台規範》的行為，SwiftiDate 保留調查及/或終止您的帳號、而不退還任何購買費用的權利。")
                    }
                }
                .padding()
            }
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("CommunityGuidelinesView_Appeared", parameters: nil)
        }
    }
}

// Preview for CommunityGuidelinesView
struct CommunityGuidelinesView_Previews: PreviewProvider {
    @State static var isCommunityGuidelinesView = true // Provide a sample state variable for the preview

    static var previews: some View {
        CommunityGuidelinesView(isCommunityGuidelinesView: $isCommunityGuidelinesView) // Use the binding variable in the preview
    }
}
