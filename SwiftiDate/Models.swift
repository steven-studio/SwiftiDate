//
//  Models.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/16.
//

import Foundation

// Define a structure for user match data
struct UserMatch: Identifiable, Codable { // 添加 Codable
    let id = UUID()
    let name: String
    let imageName: String // Use image names stored in Assets
}

// Message model
struct Message: Identifiable, Codable {
    let id: UUID
    let text: String
    let isSender: Bool
    let time: String
    var isCompliment: Bool // New property to indicate if the message is a compliment
}

// 聊天模型
struct Chat: Identifiable, Codable {
    let id: UUID
    let name: String
    let time: String
    let unreadCount: Int
}
