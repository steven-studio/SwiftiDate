//
//  CropViewControllerWrapper.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI
import UIKit
import TOCropViewController

struct CropViewControllerWrapper: UIViewControllerRepresentable {
    
    
    @Binding var image: UIImage?
    var onCrop: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode
    
    // 這裡明確指定包一層 UINavigationController
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        let src = image ?? UIImage()
        let cropVC = TOCropViewController(croppingStyle: .default, image: src)

        // 鎖 3:4（跨版本做法）
        cropVC.customAspectRatio = CGSize(width: 3, height: 4)

        cropVC.aspectRatioLockEnabled = true
        cropVC.resetAspectRatioEnabled = false
        cropVC.aspectRatioPickerButtonHidden = true
        cropVC.toolbar.clampButtonHidden = true               // 隱藏裁邊鈕
        cropVC.toolbar.rotateClockwiseButtonHidden = true     // 隱藏旋轉鈕
 
        cropVC.cancelButtonTitle = "取消"

        cropVC.delegate = context.coordinator

        // 用 UINavigationController 包起來
        let nav = UINavigationController(rootViewController: cropVC)
        nav.modalPresentationStyle = .fullScreen
        nav.navigationBar.isTranslucent = true
        return nav
    }
    
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, TOCropViewControllerDelegate {
        let parent: CropViewControllerWrapper
        
        init(_ parent: CropViewControllerWrapper) {
            self.parent = parent
        }
        
        // 新版 API（有些版本是這個）
        func cropViewController(_ cropViewController: TOCropViewController,
                                didCropTo image: UIImage,
                                with cropRect: CGRect,
                                angle: Int) {
            debugLog("didCropTo image.size=\(image.size), rect=\(cropRect)")
            parent.onCrop(image)                               // ✅ 直接回傳裁後圖
            parent.presentationMode.wrappedValue.dismiss()
        }

        func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        private func debugLog(_ s: String) { print("🔎 [CropVC] \(s)") }
    }
}
