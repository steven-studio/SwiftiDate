//
//  SocialCourse.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/1/31.
//

import Foundation

struct SocialCourse: Identifiable {
    let id = UUID()
    let title: String      // 課程標題
    let instructor: String // 講師或機構名稱
    let description: String // 課程描述
    let price: String      // 價格
    let url: URL?          // 課程連結（如果是外部網站）
    let isInAppPurchase: Bool // 是否支援內購
}
