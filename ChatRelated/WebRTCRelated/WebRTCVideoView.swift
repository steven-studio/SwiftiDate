//
//  WebRTCVideoView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/11.
//

import Foundation
import UIKit
import SwiftUI
import WebRTC

struct WebRTCVideoView: UIViewRepresentable {
    let renderer: RTCVideoRenderer
    
    func makeUIView(context: Context) -> UIView {
        guard let metalView = renderer as? RTCMTLVideoView else {
            return UIView()
        }
        // 使其填滿
        metalView.videoContentMode = .scaleAspectFit
        return metalView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // nothing
    }
}
