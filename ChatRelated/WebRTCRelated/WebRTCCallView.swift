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
    // 新增一個用來顯示對方名字的參數
    let userName: String

    @StateObject private var webRTCManager = WebRTCManager()

    var body: some View {
        VStack {
            Text("正在進行 WebRTC 通話…")
                .font(.title)
                .foregroundColor(.white)
            
            Text(userName) // 改成顯示對方名稱
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom)
            
            Text("等待對方接受邀請...") // 改成顯示對方名稱
                .font(.headline)
                .foregroundColor(.white)
            
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
            .font(.system(size: 24)) // 設定字型大小為 24
            .foregroundColor(.white)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .onAppear {
            webRTCManager.startCall() // Example: 開始 P2P 連線
        }
        .onDisappear {
            webRTCManager.hangup()
        }
    }
}

struct WebRTCCallView_Previews: PreviewProvider {
    static var previews: some View {
        WebRTCCallView(userName: "Ashley")
    }
}
