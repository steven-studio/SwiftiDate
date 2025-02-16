//
//  FaceVideo.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation    // NSObject 所在處
import SwiftUI       // ObservableObject、@Published 的語法在 SwiftUI 或 Combine 內
import Combine       // 如果只用 Combine（沒有用 SwiftUI）也可以使用 ObservableObject 和 @Published
import UIKit         // UIImage 所在處
import Vision        // VNFaceObservation 所在處

class FaceVideo: NSObject, ObservableObject {
    static let shared = FaceVideo()
    @Published var uiImage: UIImage?
    @Published var faces: [VNFaceObservation] = []
}
