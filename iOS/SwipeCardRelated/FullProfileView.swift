//
//  FullProfileView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/14.
//

import SwiftUI

struct FullProfileView: View {
    let user: Profile
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // 相片輪播（若有多張）
                    if !user.photos.isEmpty {
                        TabView {
                            ForEach(user.photos, id: \.self) { p in
                                Image(p)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 360)
                                    .clipped()
                            }
                        }
                        .frame(height: 360)
                        .tabViewStyle(.page)
                        .indexViewStyle(.page(backgroundDisplayMode: .always)) // 讓頁點有底
                        .padding(.bottom, 24) // <<< 關鍵：替頁點「預留空間」
                        .overlay(alignment: .bottomTrailing) {
                            HStack(spacing: 8) {
                                // 上箭頭
                                Button {
                                    // 你的上箭頭動作
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.up")
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.gray.opacity(0.8))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.trailing, 16)
                            .padding(.bottom, 16)
                        }
                    }

                    // 名稱 / 年齡
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(user.name ?? "用戶")\(user.age.map { ", \($0)" } ?? "")")
                            .font(.title)
                            .bold()
                        if let about = user.aboutMe, !about.isEmpty {
                            Text(about)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)

                    // 標籤列（用 LazyVGrid .adaptive 自動換行，避免高度為 0 的首輪排版問題）
                    let tagColumns = [GridItem(.adaptive(minimum: 72), spacing: 8)]

                    // 關於我
                    if let about = user.aboutMe, !about.isEmpty {
                        SectionBox(title: "關於我") {
                            Text(about)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true) // 正確換行高度
                                .foregroundStyle(.primary)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    
                    // 基本資料區塊
                    SectionBox(title: "基本資料") {
                        InfoRow(label: "星座",   value: user.zodiac)
                        InfoRow(label: "城市",   value: user.location)
                        InfoRow(label: "身高",   value: user.height.map { "\($0) cm" })
                        InfoRow(label: "學歷",   value: user.degree)
                        InfoRow(label: "產業",   value: user.industry)
                        InfoRow(label: "職業",   value: user.job)
                        InfoRow(label: "語言",   value: user.languages?.joined(separator: "、"))
                        InfoRow(label: "感情目標", value: user.lookingFor)
                        InfoRow(label: "飲食",   value: user.dietPreference)
                        InfoRow(label: "飲酒",   value: user.drinkOption)
                        InfoRow(label: "抽菸",   value: user.smokingOption)
                        InfoRow(label: "健身",   value: user.fitnessOption)
                        InfoRow(label: "寵物",   value: user.pet)
                        InfoRow(label: "學校",   value: user.school)
                        InfoRow(label: "休假",   value: user.vacationOption)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("個人檔案")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: { Image(systemName: "xmark") }
                }
            }
        }
    }

    // 組合需要顯示在上方標籤列的字串
    private var compactTags: [String] {
        [
            user.zodiac,
            user.location,
            user.height.map { "\($0) cm" }
        ].compactMap { $0 }
    }
}

// 一個簡單的 Section 外框
struct SectionBox<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            VStack(alignment: .leading, spacing: 8) { content }
                .padding(12)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// 單行資料
struct InfoRow: View {
    let label: String
    let value: String?
    var body: some View {
        if let value, !value.isEmpty {
            HStack {
                Text(label).foregroundColor(.secondary)
                Spacer()
                Text(value)
            }
            .font(.subheadline)
        }
    }
}

struct Wrap<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let content: (Data.Element) -> Content

    @State private var totalHeight: CGFloat = .zero

    init(tags data: Data, spacing: CGFloat = 8,
         @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.data = data
        self.spacing = spacing
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            generate(in: geo)
        }
        .frame(height: totalHeight)   // 正確高度，避免覆蓋
    }

    private func generate(in geo: GeometryProxy) -> some View {
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0   // 追蹤當前列最高 chip

        return ZStack(alignment: .topLeading) {
            ForEach(Array(data), id: \.self) { item in
                content(item)
                    .padding(4)
                    .alignmentGuide(.leading) { d in
                        if x + d.width > geo.size.width {
                            // 換行：把上一列的高度加到 y
                            x = 0
                            y += rowHeight + spacing
                            rowHeight = 0
                        }
                        let result = x
                        x += d.width + spacing
                        rowHeight = max(rowHeight, d.height) // 記錄本列最高
                        return result
                    }
                    .alignmentGuide(.top) { _ in y }
            }
        }
        .background(
            GeometryReader { _ in
                Color.clear
                    .onAppear { totalHeight = y + rowHeight }           // 首次
                    .onChange(of: Array(data).count) { _ in             // 資料變動
                        totalHeight = y + rowHeight
                    }
            }
        )
    }
}

#if DEBUG
struct FullProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // 淺色
            NavigationStack { FullProfileView(user: .demo) }
                .previewDisplayName("Light")
                .preferredColorScheme(.light)

            // 深色
            NavigationStack { FullProfileView(user: .demo) }
                .previewDisplayName("Dark")
                .preferredColorScheme(.dark)

            // 小螢幕（測 Wrap 換行）
            NavigationStack {
                FullProfileView(
                    user: {
                        var u = Profile.demo
                        u.height = 172
                        // 多塞幾個 tag 看換行
                        //（這些會出現在 compactTags 裡 → 星座/城市/身高已涵蓋，必要時也可臨時改 compactTags 觀察）
                        return u
                    }()
                )
            }
            .previewDisplayName("iPhone SE")
            .previewDevice("iPhone SE (3rd generation)")
        }
    }
}
#endif

#if DEBUG
extension Profile {
    static let demo: Profile = Profile(
        id: "demo_001",
        name: "後照鏡被偷",
        age: 20,
        zodiac: "雙魚座",
        location: "桃園市",
        height: 172,
        photos: ["userID_2_photo1", "userID_2_photo2"], // 換成專案裡存在的圖片名稱
    )
}
#endif
