//
//  SwiftiDateWatchApp.swift
//  SwiftiDateWatch Watch App
//
//  Created by 游哲維 on 2025/1/25.
//

import SwiftUI
import WatchConnectivity

@main
struct SwiftiDateWatch_Watch_AppApp: App {
    init() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = WatchConnectivityManager.shared // 確保有一個共享管理器
            session.activate()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
