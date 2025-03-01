//
//  InterestSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/8.
//

import Foundation
import SwiftUI

struct InterestSelectionView: View {
    // 定義各個分類及其對應的標籤
    let categories = [
        "全部", "工作", "遊戲", "美食", "愛好", "明星", "生活", "車", "影視",
        "戀愛", "地方", "時尚", "讀書", "運動", "性格", "旅行", "動漫", "音樂",
        "寵物", "文藝", "獨特"
    ]
    
    let bookInterests = [
        "太宰治", "莫言", "侯文詠", "藝術設計", "Kindle", "追風箏的人", "我是大作家", "海明威", "鄉土中國", "談美",
        "李清照", "料理烹飪", "有聲書", "安徒生", "江戶川亂步", "都市言情", "月亮和六便士", "圍城", "尼羅河上的慘案", "書架快堆滿了",
        "飄", "文化失憶", "老舍", "水滸傳", "攝影雜誌", "書局為家", "雲邊有個小賣部", "朱少麟", "喜歡看人物傳記", "動作冒險",
        "旅遊書籍", "心理類型", "九州縹緲錄", "我愛讀書", "人生海海", "夢里花落知多少", "余華"
    ]
    
    let sportInterests = [
        "喜歡街頭健身", "逛街", "麥可喬丹", "鐵人三項", "喜歡衝浪", "騎馬", "喜歡傳統武術", "跆拳道", "HIIT", "喜歡柔道",
        "衝浪", "排球", "喜歡五人制足球", "喜歡沙灘排球", "紐約尼克隊球迷", "喜歡玩滑板", "網球", "跳舞", "喜歡手指滑板",
        "喜歡極限運動", "喜歡單排滑輪", "喜歡太極", "划船", "健身", "釣魚", "梅西球迷", "曼聯球迷", "馬拉松愛好者",
        "喜歡兩個人一起健身", "快艇隊球迷", "水肺潛水", "喜歡空手道", "空中舞蹈", "NBA", "巴黎球迷", "喜歡公路自行車"
    ]
    
    let fashionInterests = [
        "LV", "喜歡Supreme", "BALENCIAGA巴黎世家", "喜歡蘿莉塔", "喜歡正式服裝", "我是甜妹", "凡賽斯VERSACE", "Cartier卡地亞",
        "喜歡嘻哈風格", "喜歡小清新穿搭", "喜歡收集球鞋", "喜歡日系穿搭", "甜美酷帥", "氣質淑女", "不講究品牌", "Givenchy", "Bearbrick",
        "古裝穿搭", "甜辣少女", "喜歡北面", "喜歡買球鞋", "極簡主義", "小個子可愛", "喜歡街頭時尚", "Burberry", "最愛籃球鞋",
        "森林系女孩", "喜歡工裝風", "LOEWE", "GUCCI", "微胖", "鞋控"
    ]
    
    let placeInterests = [
        "下班後喜歡去喝一杯", "我喜歡散步約會", "喜歡去寺廟", "未來打算移居國外", "喜歡IKEA", "喜歡在公園慢跑", "米其林餐廳鑑賞專家",
        "飯後出門散步", "我喜歡去livehouse", "一起去看楓葉吧", "喜歡去夜店", "我喜歡水族館", "想去水族館約會", "喜歡去圖書館",
        "喜歡去新的餐廳", "喜歡去遊樂園", "喜歡咖啡館", "喜歡逛菜市場", "我想去天文館", "也許你也喜歡博物館", "喜歡打卡網紅店",
        "平時喜歡逛書店", "喜歡玩密室逃脫"
    ]
    
    // 新增生活選項
    let lifeInterests = [
        "嚮往兩人三餐四季", "吃吃喝喝才是生活", "喜歡大自然", "有很多朋友", "喜歡看日落", "喜歡做飯", "喜歡安靜的生活環境", "有態度",
        "我喜歡精釀啤酒", "喜歡月亮", "美國留學", "喜歡待在室內", "物質是最高的精神食糧", "喜歡喝酒吃燒烤", "養花我是認真的",
        "喜歡做家務", "有別墅", "下雨天", "心情好的時候會做飯", "朋友對我來說很重要", "喜歡喝到微醺的感覺", "想過安靜平穩的生活",
        "喜歡看海", "喜歡散步", "是個有錢人", "理想主義", "空閒時間喜歡待在家裡"
    ]
    
    let movieInterests = [
        "大話西遊", "無間警探", "新世紀福爾摩斯", "話劇", "科幻片", "後翼棄兵", "紙牌屋", "我喜歡韓國電影", "動作片", "我喜歡殭屍片",
        "甄嬛傳", "我腦海中的橡皮擦", "脫口秀", "DC宇宙", "復仇者聯盟", "我喜歡暮光系列", "懸疑電影愛好者", "日劇愛好者", "星際特攻隊",
        "小姐不熙娣", "美食節目", "溫子仁", "動漫", "對恐怖片又愛又恨", "欠周星馳一張電影票", "愛x死x機器人", "六人行",
        "我喜歡動作片", "想見你", "海賊迷", "我喜歡日本電影", "黑色追緝令", "浴血黑幫"
    ]
    
    let workInterests = [
        "從事網路相關產業", "自由職業", "投資人", "碩士", "為自己的工作感到自豪", "高管", "想自己創業", "從事金融方面的工作",
        "經常到國外出差", "從事投資", "幼兒園老師", "公務員", "產品研發人員", "要有穩定的工作(正常班最好)", "在航空業工作",
        "空服", "程序工程師", "我是Youtuber", "工作中要穿西裝", "演員", "外資企業", "四大會計師事務所員工",
        "正在攻讀博士學位", "我是教師", "遊戲開發者", "科研人員", "空姐"
    ]
    let gameInterests = [
        "喜歡電競", "江南百景圖", "我是主機黨", "射擊遊戲", "第五人格", "喜歡戰國無雙", "星露穀物語", "傳奇", "奇妙人生",
        "節奏大師", "和平精英", "GTA系列", "越南大戰", "植物大戰殭屍", "超級瑪利歐", "歧路旅人", "魔獸世界", "迷你世界",
        "大都會：天際", "喜歡建造類遊戲", "逃離塔科夫", "劇本殺", "喜歡APEX", "魂斗羅", "我喜歡玩UNO", "保衛蘿蔔",
        "喜歡乙女遊戲", "大富翁", "末日之战", "喜歡網咖打遊戲", "奧德賽"
    ]
    let carInterests = [
        "MINI車主", "Cadillac車主", "台鈴機車車主", "一起騎摩托車去兜風吧", "藍寶堅尼車主", "Volkswagen車主",
        "Subaru車主", "有一輛重型機車", "性能車車主", "Ford車主", "有一輛房車", "Wagon車主", "Morning Drive愛好者",
        "勞斯萊斯車主", "Chevrolet車主", "BMW車主", "瑪莎拉蒂車主", "敞蓬車車主", "三菱車主", "Buick車主",
        "麥拉倫車主", "Toyota車主", "Drive跑車", "鈴木機車車主", "川崎機車車主", "Skoda車主"
    ]
    let foodInterests = [
        "沙茶爐", "可樂雞翅", "糖醋排骨", "鹽酥雞", "砂鍋粥", "剁椒魚頭", "墨西哥夾餅", "喜歡冰棒", "檸檬茶", "大愛烤生蠔",
        "喜歡韓國料理", "茶", "乾式熟成牛排", "愛喝茶", "喜歡芒果", "喜歡BBQ", "刈包", "法國料理", "甜甜圈", "喜歡吃川菜",
        "比薩", "愛吃肉燥飯", "愛吃炒年糕", "泡椒鳳爪", "喜歡江浙菜", "愛吃酸菜魚", "泰式料理", "會煮魚湯", "沙拉愛好者",
        "蛋撻", "完全不挑食", "喜歡墨西哥菜", "又怕辣又愛吃辣", "海南雞飯", "喜歡烤牛舌", "喜歡日式鐵板燒", "涮羊肉火鍋"
    ]
    let loveInterests = [
        "我喜歡擁抱", "拒絕公主病", "喜歡聰明人", "依然相信愛情", "想放肆撒嬌", "我想認真談戀愛", "身高180", "絕對不會背叛對方",
        "戀愛經驗很少", "涼爽的秋天很適合戀愛", "已經忘記怎麼談戀愛了", "頂客", "想要跟你一起說說情話", "想緊緊擁抱一整天",
        "有訊息就會回", "沒必要每天都聯繫", "已讀必回", "拒絕拉扯", "希望結婚後也能像情侶一樣相處", "拒絕玩玩",
        "出現問題時要好好溝通解決", "可以見面聊聊", "想要以結婚為目的戀愛", "皮膚超白"
    ]
    
    // 新增明星選項
    let celebrityInterests = [
        "巨石強森", "彭于晏", "王耀慶", "白冰", "安以軒", "瓦昆菲尼克斯", "OZI", "吳奇隆", "舒淇", "吳彥祖",
        "尤長靖", "林允", "菅田將暉", "黃家駒", "吳忠憲", "樸信惠", "蔣欣", "竇驍", "曾敬驊", "黃子佼",
        "安.海瑟薇", "郭書瑤", "黎姿", "肖戰", "陳妍希", "尼可拉斯.凱吉", "阿諾.史瓦辛格", "麥特.戴蒙",
        "宋仲基", "邱蔓綾 安喬", "霍建華", "李現", "喜歡劉德華", "黃景瑜", "刑邵林", "馬思純", "鄭裕玲",
        "保羅.沃克", "男人幫", "章子怡", "湯姆.克魯斯", "萊恩.雷諾斯", "周慧敏"
    ]

    let hobbyInterests = [
        "滑板無極限", "長板", "閱讀", "漢服旗袍", "專業桌遊湊桌人", "抓娃娃達人", "高達模型", "喜歡旗袍漢服", "爵士鼓", "國標舞",
        "重型機車", "喜歡晚上出去散步", "喜歡看煙火", "喜歡青草的味道", "機車girl", "對小動物沒有抵抗力", "球鞋控",
        "喜歡毛絨絨", "喜歡冬天", "愛講冷笑話", "超輕粘土", "熱愛色彩斑斕", "桌遊達人", "喜歡春天", "有刺青紋身",
        "喜歡寫作", "週末喜歡宅在家", "喜歡養花花草草", "喜歡玩遊戲", "愛玩王者榮耀", "喜歡養貓", "我愛小狗"
    ]
    
    let personalityInterests = [
        "情緒穩定", "我是巨蟹座", "小確幸捕捉人", "是一個有同理心的人", "有上進心", "可可愛愛沒有腦袋", "我是雙子座", "就愛打退堂鼓",
        "容易感動，淚腺發達", "孝順", "是個理性的人", "日拋網友勿擾", "對生活始終抱有熱情", "有獨立思考能力", "樂於思考問題的本質",
        "上進少年", "想要輕鬆些", "拒絕平淡", "性格內斂", "基本可以做到訊息秒回", "很怕麻煩別人", "我是牡羊座", "中二", "心態極好",
        "一個小白目", "中二病患者", "搞笑女", "笑點奇低", "紳士"
    ]
    
    let travelInterests = [
        "喜歡隨意輕鬆的旅行", "探索新的城市", "去過不同國家", "落日晚霞", "星級酒店", "喜歡深度遊", "VR旅行", "窮游愛好者",
        "無計劃旅行", "喜歡一個人開車", "豪華露營", "必去博物館", "會認真計劃旅行", "喜歡看藍天", "自然風光", "瘋狂購物",
        "護照蓋滿印章", "必需做攻略", "想去南極", "單車騎行", "背包客", "機加酒套餐", "宅度假", "飯店是我的旅遊目的地",
        "我喜歡傍晚的海", "冰雪運動", "自駕游", "我喜歡騎車旅行", "一直在路上", "公路旅行"
    ]
    
    let animeInterests = [
        "我喜歡進擊的巨人", "我喜歡刀劍神域", "命運石之門", "聲優控", "我支持國產漫畫", "日向雛田", "死神", "美少女戰士", "神奇寶貝",
        "庫洛魔法使", "櫻蘭高中男公關部", "一起去參加漫展吧！", "月刊少女野崎君", "哆啦A夢", "我喜歡治愈系動漫", "麻辣教師GTO", "咒術迴戰",
        "銀魂", "我愛七龍珠", "我喜歡Cosply", "妖精的尾巴", "盜夢偵探", "海賊王", "龍與虎", "時崎狂三", "鋼之煉金術師", "靈能百分百",
        "犬夜叉", "坂田銀時", "JK", "喜歡追番"
    ]
    
    let musicInterests = [
        "我喜歡古典音樂", "喜歡搖滾", "流行音樂愛好者", "我會彈吉他", "音樂會愛好者", "喜歡聽鋼琴曲", "我愛唱卡拉OK",
        "爵士樂愛好者", "喜歡電音", "偶像歌手粉絲", "喜歡國樂", "聽音樂是我的日常", "我喜歡音樂節", "愛聽爵士",
        "經常聽Podcast", "喜歡新生代音樂", "我熱愛聽CD", "音樂是靈魂的食糧", "我喜歡搖滾樂", "唱歌是我最愛的休閒"
    ]
    
    let petInterests = [
        "喜歡鯨魚", "喜歡大型犬", "想養隻貓", "緬因", "喜歡養鳥", "對可愛動物沒有抵抗力", "鏟屎官", "喜歡鸚鵡", "我有一隻加菲貓",
        "喜歡鯊魚", "藍貓", "養了隻倉鼠", "我有一隻小比熊", "想跟水獺握握手", "養了布偶貓", "喜歡水族館", "養了隻狗子", "喜歡猛禽",
        "喜歡海獺", "喜歡金魚", "想跟海龜一起暢遊", "養了隻烏龜", "照顧流浪狗", "寵物是我重要的家庭成員", "無毛貓", "喜歡博美",
        "喜歡貓咪咖啡館", "巨型貴賓", "喜歡刺蝟"
    ]
    
    let artInterests = [
        "喜歡建築學", "我是藝術生", "喜歡天文學", "畢卡索", "喜歡民族舞", "一個孤獨的詩人", "喜歡沙畫", "喜歡近代史",
        "喜歡抽象藝術", "新尼采主義", "我是設計師", "對法國藝術感興趣", "喜歡現代舞", "浪漫主義",
        "喜歡古希臘神話", "喜歡刺青紋身", "喜歡塗鴉", "林布蘭", "古典自由主義", "蒙娜麗莎", "喜歡超現實主義", "精神分析", "喜歡歷史", "喜歡水彩畫", "喜歡逛畫廊", "攝影初學者", "克勞德.莫奈", "藝術院校畢業", "喜歡京劇", "保羅.塞尚", "齊白石"
    ]
    
    @Binding var selectedInterests: Set<String>  // 用來追蹤選中的興趣
    @State private var selectedCategories: Set<String> = ["全部"]  // 預設為 "全部"
    @State private var isExpanded = false  // 用來控制分類是否展開

    @Binding var interestColors: [String: Color]
    
    // 佈局定義，讓每行至少可以放下多個標籤
    let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 80), spacing: 10)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("新增你的標籤")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)
                
                // 顯示分類的 LazyVGrid
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 10) {
                    // 顯示前兩排（6個分類）或全部分類
                    ForEach(isExpanded ? categories : Array(categories.prefix(8)), id: \.self) { category in
                        Button(action: {
                            // 處理複選邏輯
                            if category == "全部" {
                                selectedCategories = ["全部"]  // 如果選擇的是 "全部"，清除其他選擇
                            } else {
                                if selectedCategories.contains("全部") {
                                    selectedCategories.remove("全部") // 如果 "全部" 已經被選中，取消選中
                                }
                                if selectedCategories.contains(category) {
                                    selectedCategories.remove(category)  // 已選中的再次點擊則取消選中
                                    // 檢查是否為空，如果為空則選中 "全部"
                                    if selectedCategories.isEmpty {
                                        selectedCategories.insert("全部")
                                    }
                                } else {
                                    selectedCategories.insert(category)   // 添加選中分類
                                }
                            }
                            // 埋點：記錄使用者切換分類
                            AnalyticsManager.shared.trackEvent("interest_category_toggled", parameters: [
                                "selected_categories": Array(selectedCategories)
                            ])
                        }) {
                            Text(category)
                                .font(.subheadline)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(selectedCategories.contains(category) ? Color.green.opacity(1) : Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .foregroundColor(selectedCategories.contains(category) ? .white : .black)
                        }
                    }
                }
                .padding(.horizontal)
                
                // 展開/收起的按鈕
                Button(action: {
                    isExpanded.toggle()  // 切換展開狀態
                    // 埋點：記錄用戶展開或收起分類
                    AnalyticsManager.shared.trackEvent("interest_categories_expanded_toggled", parameters: [
                        "isExpanded": isExpanded
                    ])
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // 如果只選中 "全部"，顯示所有分類
                if selectedCategories.contains("全部") {
                    SectionView(sectionTitle: "工作", items: workInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.green.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "遊戲", items: gameInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.purple.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "車", items: carInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "美食", items: foodInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.orange.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "戀愛", items: loveInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.pink.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "愛好", items: hobbyInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.yellow.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "明星", items: celebrityInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.red.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "生活", items: lifeInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "影視", items: movieInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.cyan.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "地方", items: placeInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.green.opacity(1), prefix: 8)  // 加入地方的SectionView
                    SectionView(sectionTitle: "時尚", items: fashionInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.purple.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "讀書", items: bookInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.gray.opacity(1), prefix: 8)  // 新增讀書的SectionView
                    SectionView(sectionTitle: "運動", items: sportInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.orange.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "性格", items: personalityInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.gray.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "旅行", items: travelInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "動漫", items: animeInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.pink.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "音樂", items: musicInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.orange.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "寵物", items: petInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    SectionView(sectionTitle: "文藝", items: artInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.green.opacity(1), prefix: 8)
                } else {
                    // 根據選中的分類顯示對應的興趣標籤
                    if selectedCategories.contains("工作") {
                        SectionView(sectionTitle: "工作", items: workInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.green.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("遊戲") {
                        SectionView(sectionTitle: "遊戲", items: gameInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.purple.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("車") {
                        SectionView(sectionTitle: "車", items: carInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("美食") {
                        SectionView(sectionTitle: "美食", items: foodInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.orange.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("戀愛") {
                        SectionView(sectionTitle: "戀愛", items: loveInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.pink.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("愛好") {
                        SectionView(sectionTitle: "愛好", items: hobbyInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.yellow.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("明星") {
                        SectionView(sectionTitle: "明星", items: celebrityInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.red.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("生活") {
                        SectionView(sectionTitle: "生活", items: lifeInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("影視") {
                        SectionView(sectionTitle: "影視", items: movieInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.cyan.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("地方") {  // 加入地方的SectionView
                        SectionView(sectionTitle: "地方", items: placeInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.green.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("時尚") {
                        SectionView(sectionTitle: "時尚", items: fashionInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.purple.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("讀書") {  // 加入讀書的SectionView
                        SectionView(sectionTitle: "讀書", items: bookInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.gray.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("運動") {
                        SectionView(sectionTitle: "運動", items: sportInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.orange.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("性格") {
                        SectionView(sectionTitle: "性格", items: personalityInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.gray.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("旅行") {
                        SectionView(sectionTitle: "旅行", items: travelInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("動漫") {
                        SectionView(sectionTitle: "動漫", items: animeInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.pink.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("音樂") {
                        SectionView(sectionTitle: "音樂", items: musicInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.orange.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("寵物") {
                        SectionView(sectionTitle: "寵物", items: petInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.blue.opacity(1), prefix: 8)
                    }
                    if selectedCategories.contains("文藝") {
                        SectionView(sectionTitle: "文藝", items: artInterests, selectedInterests: $selectedInterests, interestColors: $interestColors, color: Color.green.opacity(1), prefix: 8)
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            AnalyticsManager.shared.trackEvent("interest_selection_view_appear")
        }
    }
}

struct SectionView: View {
    let sectionTitle: String
    let items: [String]
    @Binding var selectedInterests: Set<String>  // 被選中的標籤集合
    @Binding var interestColors: [String: Color] // 用於保存每個興趣對應的顏色
    let color: Color
    @State private var isExpanded: Bool = false  // 控制該 section 是否展開
    let prefix: Int  // 控制顯示項目的數量

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(sectionTitle)
                .font(.headline)
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                ForEach(isExpanded ? items : Array(items.prefix(prefix)), id: \.self) { item in
                    Text(item)
                        .font(.subheadline)
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                        .background(color.opacity(selectedInterests.contains(item) ? 0.8 : 0.2))  // 背景變深
                        .cornerRadius(20)
                        .foregroundColor(selectedInterests.contains(item) ? .white : .black)  // 只改變文字顏色
                        .onTapGesture {
                            if selectedInterests.contains(item) {
                                selectedInterests.remove(item)
                            } else {
                                selectedInterests.insert(item)
                                interestColors[item] = color // 或者使用一個固定的顏色
                            }
                        }
                }
            }
            .padding(.horizontal)
            
            // 如果項目數量超過 prefix，顯示「顯示更多」按鈕
            if items.count > prefix {
                Button(action: {
                    isExpanded.toggle()  // 切換展開狀態
                }) {
                    HStack {
                        Spacer()
                        Text(isExpanded ? "顯示更少" : "顯示更多")  // 根據狀態顯示文本
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
        }
        .padding(.top, 10)
    }
}

struct InterestSelectionView_Previews: PreviewProvider {
    @State static var previewSelectedInterests: Set<String> = [
        "我喜歡Cosply", "咒術迴戰", "死神", "基本上可以做到訊息秒回", "是個理性的人", "有上進心", "我是巨蟹座"
    ]
    
    @State static var previewInterestColors: [String: Color] = [:]  // 添加 previewInterestColors

    static var previews: some View {
        InterestSelectionView(selectedInterests: $previewSelectedInterests, interestColors: $previewInterestColors)  // 傳遞 interestColors
    }
}
