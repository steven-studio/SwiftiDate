//
//  ContentView.swift
//  SwiftiDateWatch Watch App
//
//  Created by 游哲維 on 2025/1/25.
//

import SwiftUI
import WatchConnectivity

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Send Heart Rate")
            Button(action: {
                sendHeartRateToiPhone()
            }) {
                Text("Send")
            }
        }
    }

    func sendHeartRateToiPhone() {
        guard WCSession.default.isReachable else {
            print("iPhone is not reachable")
            return
        }

        WCSession.default.sendMessage(["heartRate": 75], replyHandler: nil) { error in
            print("Failed to send message: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
