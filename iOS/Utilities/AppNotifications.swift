//
//  AppNotifications.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

import Foundation

extension Notification.Name {
    static let apnsReady = Notification.Name("apnsReady")
    // 如果想要失敗也通知，可再加：
    // static let apnsFailed = Notification.Name("apnsFailed")
}
