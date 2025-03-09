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

    @StateObject private var webRTCManager = WebRTCManager(signalingServerURL: URL(string: "http://192.168.1.100:3000")!)

    var body: some View {
        VStack {
            Text("正在進行 WebRTC 通話…")
                .font(.title)
                .foregroundColor(.white)
            
            Text(userName) // 改成顯示對方名稱
                .font(.title)
                .foregroundColor(.white)
                .padding(.bottom)
            
            // 依照 callState 顯示不同文字
            switch webRTCManager.callState {
            case .calling:
                Text("等待對方接受邀請...")
                    .font(.headline)
                    .foregroundColor(.white)
            case .accepted:
                Text("通話中...")
                    .font(.headline)
                    .foregroundColor(.white)
            case .ended:
                Text("通話已結束")
                    .font(.headline)
                    .foregroundColor(.white)
            default:
                EmptyView()
            }

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
            
            Button(action: {
                webRTCManager.hangup()
            }) {
                VStack {
                    Image(systemName: "phone.down.circle.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.white, .red)
                    Text("掛斷")
                        .font(.headline) // 設定字型大小為 24
                }
            }
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
