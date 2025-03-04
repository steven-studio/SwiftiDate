//
//  TaggingView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

struct TaggingView: View {
    @State private var categories: [TagCategory] = [
        TagCategory(
            title: "影音",
            allTags: [
                TagItem(name: "墨西哥辣妹"), TagItem(name: "追劇"), TagItem(name: "Netflix"),
                TagItem(name: "漫威"), TagItem(name: "喜劇")
            ],
            previewCount: 3
        ),
        TagCategory(
            title: "動漫",
            allTags: [
                TagItem(name: "灌籃高手"), TagItem(name: "鬼滅之刃"), TagItem(name: "海賊王"),
                TagItem(name: "進擊的巨人"), TagItem(name: "妖怪少爺")
            ],
            previewCount: 2
        ),
        TagCategory(
            title: "文藝",
            allTags: [
                TagItem(name: "名著"), TagItem(name: "小說"), TagItem(name: "詩詞"), TagItem(name: "文青"),
            ],
            previewCount: 2
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 頂部標題
                    Text("新增你的標籤")
                        .font(.title2)
                        .bold()
                    
                    // 多個分類
                    ForEach($categories) { $category in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(category.title)
                                    .font(.headline)
                                Spacer()
                                // 切換「全部 / 預覽」按鈕
                                Button(category.isExpanded ? "收起" : "顯示更多") {
                                    category.isExpanded.toggle()
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                            
                            // 用 LazyVGrid 或 FlowLayout 顯示標籤
                            let showingCount = category.isExpanded ? category.allTags.count : min(category.previewCount, category.allTags.count)
                            let tagsToShow = category.allTags[0..<showingCount]
                            
                            // FlowLayout 的簡易作法：LazyVGrid + .adaptive
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 8)], spacing: 8) {
                                ForEach(tagsToShow.indices, id: \.self) { idx in
                                    let tag = tagsToShow[idx]
                                    TagChipView(tag: $category.allTags[idx]) // 需用 idx 對應
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
            }
            .navigationBarItems(
                leading: Button(action: {
                    // 返回上一頁或其它邏輯
                    print("返回按鈕點擊")
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.blue)
                },
                trailing: Button("完成") {
                    // 按下完成後的邏輯
                    // 可以收集使用者選到的標籤
                    let selectedTags = categories.flatMap { cat in
                        cat.allTags.filter { $0.isSelected }.map { $0.name }
                    }
                    print("使用者選擇的標籤：\(selectedTags)")
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - TagChipView
struct TagChipView: View {
    @Binding var tag: TagItem
    
    var body: some View {
        Text(tag.name)
            .font(.subheadline)
            .foregroundColor(tag.isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(tag.isSelected ? Color.blue : Color.gray.opacity(0.2))
            .clipShape(Capsule())
            .onTapGesture {
                tag.isSelected.toggle()
            }
    }
}

// MARK: - Models
struct TagItem: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
}

struct TagCategory: Identifiable {
    let id = UUID()
    let title: String
    var allTags: [TagItem]
    
    var previewCount: Int
    var isExpanded: Bool = false
}

struct TaggingView_Previews: PreviewProvider {
    static var previews: some View {
        TaggingView()
            .previewDevice("iPhone 15 Pro")
    }
}
