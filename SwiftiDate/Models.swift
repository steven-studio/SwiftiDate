//
//  Models.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/16.
//

import Foundation
import SwiftUI

// Define a structure for user match data
struct UserMatch: Identifiable, Codable { // 添加 Codable
    let id = UUID()
    let name: String
    let imageName: String // Use image names stored in Assets
}

enum MessageType: Codable {
    case text(String)
    case image(Data)   // 使用 Data 來存儲圖片數據
    case audio(String) // 使用 String 來存儲音頻文件的 URL 字符串

    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }

    private enum MessageTypeKey: String {
        case text
        case image
        case audio
    }

    // 自定義編碼邏輯
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let text):
            try container.encode(MessageTypeKey.text.rawValue, forKey: .type)
            try container.encode(text, forKey: .value)
        case .image(let imageData):
            try container.encode(MessageTypeKey.image.rawValue, forKey: .type)
            try container.encode(imageData, forKey: .value)
        case .audio(let audioPath):
            try container.encode(MessageTypeKey.audio.rawValue, forKey: .type)
            try container.encode(audioPath, forKey: .value)
        }
    }

    // 自定義解碼邏輯
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        print("Decoding MessageType with type: \(type)")

        switch MessageTypeKey(rawValue: type) {
        case .text:
            let text = try container.decode(String.self, forKey: .value)
            self = .text(text)
        case .image:
            let imageData = try container.decode(Data.self, forKey: .value)
            self = .image(imageData)
        case .audio:
            let audioPath = try container.decode(String.self, forKey: .value)
            self = .audio(audioPath)
        case .none:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown MessageType: \(type)")
        }
    }
}

// Message model
struct Message: Identifiable, Codable {
    let id: UUID
    let content: MessageType
    let isSender: Bool
    let time: String
    var isCompliment: Bool
}

// 聊天模型
struct Chat: Identifiable, Codable {
    let id: UUID
    let name: String
    let time: String
    let unreadCount: Int
}
