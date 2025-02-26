//
//  Response.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/9.
//

import Foundation

struct Response: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}
