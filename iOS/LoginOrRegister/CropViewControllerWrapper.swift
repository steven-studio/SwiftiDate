//
//  CropViewControllerWrapper.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI
import TOCropViewController

struct CropViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onCrop: (UIImage) -> Void
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> TOCropViewController {
        guard let image = image else {
            // 若沒有圖片可裁切，直接回傳空白
            return TOCropViewController(croppingStyle: .default, image: UIImage())
        }
        let cropVC = TOCropViewController(croppingStyle: .default, image: image)
        cropVC.delegate = context.coordinator
        return cropVC
    }
    
    func updateUIViewController(_ uiViewController: TOCropViewController, context: Context) {
        // 不需要動態更新
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, TOCropViewControllerDelegate {
        let parent: CropViewControllerWrapper
        
        init(_ parent: CropViewControllerWrapper) {
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
            parent.onCrop(image)
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
