//
//  WebRTCManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/11.
//

import Foundation
import WebRTC

class WebRTCManager: ObservableObject {
    // Video Renderer
    @Published var remoteRenderer: RTCVideoRenderer?
    @Published var localRenderer: RTCVideoRenderer?
    
    private var peerConnection: RTCPeerConnection?
    private var factory: RTCPeerConnectionFactory
    
    init() {
        // 初始化 WebRTC
        RTCInitializeSSL()
        let encoderFactory = RTCDefaultVideoEncoderFactory()
        let decoderFactory = RTCDefaultVideoDecoderFactory()
        factory = RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)
        
        // 或初始化 localRenderer, remoteRenderer
        self.localRenderer = RTCMTLVideoView(frame: .zero)
        self.remoteRenderer = RTCMTLVideoView(frame: .zero)
    }
    
    func startCall() {
        // 在這裡做： create PeerConnection, add local media track, create offer, etc.
        // 也可能需要 signaling
        print("startCall triggered")
    }
    
    func hangup() {
        // 結束通話
        peerConnection?.close()
        peerConnection = nil
        print("hangup call")
    }
}
