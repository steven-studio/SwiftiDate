//
//  WebRTCCallView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/11.
//

import Foundation
import SwiftUI
import WebRTC

struct WebRTCCallView: View {
    // 這裡可以放一些 WebRTC 狀態，如 remoteVideoTrack
    @StateObject private var webRTCManager = WebRTCManager()
    
    var body: some View {
        VStack {
            Text("正在進行 WebRTC 通話…")
                .font(.title)
            
            // 如果要顯示遠端視訊，可放一個 VideoView
            // 這裡示範用 UIKit 的 Representable
            if let remoteRenderer = webRTCManager.remoteRenderer {
                WebRTCVideoView(renderer: remoteRenderer)
                    .frame(width: 200, height: 300)
            }
            
            // 自己視訊預覽
            if let localRenderer = webRTCManager.localRenderer {
                WebRTCVideoView(renderer: localRenderer)
                    .frame(width: 100, height: 150)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.blue, lineWidth: 2))
                    .padding()
            }
            
            Button("掛斷") {
                webRTCManager.hangup()
            }
            .padding()
        }
        .onAppear {
            webRTCManager.startCall() // Example: 開始 P2P 連線
        }
        .onDisappear {
            webRTCManager.hangup()
        }
    }
}
