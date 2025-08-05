//
//  UserProfile.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/7/30.
//

struct UserProfile: Identifiable {
    let id: String
    let name: String
    let gender: String
    let age: Int
    let photoURL: String // 網路圖片路徑
    let aboutMe: String
}
