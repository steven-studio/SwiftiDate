//
//  PHPickerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/22.
//

import Foundation
import PhotosUI // by bryan_u.6_developer
import UIKit
import SwiftUI

/**
 * ===============================================
 * 📸 **PHPickerView**
 * ===============================================
 * 開發者: bryan_u.6_developer
 * 功能: 自定義照片選取器，使用 PHPickerViewController 來選取圖片。
 *
 * 主要功能:
 * - 使用者可以選取單張圖片
 * - 支援非同步載入選取的圖片
 * - 適合 SwiftUI 的 UIViewControllerRepresentable
 *
 * 日期: 2024-12-21
 * ===============================================
 */

struct PHPickerView: UIViewControllerRepresentable {
    // 用於將選擇的圖片傳回父視圖
    @Binding var selectedImage: UIImage?
    // 用於控制選擇器的顯示狀態
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        // 建立並配置 PHPicker
        var configuration = PHPickerConfiguration()
        // 設定只能選擇圖片
        configuration.filter = .images
        // 設定只能選擇一張圖片，如果要多選可以設定其他數字或 0（無限制）
        configuration.selectionLimit = 1
        // 設定選擇模式，預設為 .default
        configuration.selection = .default
        // 設定預設呈現的資料夾，這裡使用所有照片
        configuration.preferredAssetRepresentationMode = .automatic
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    // 由於我們不需要更新 UIViewController，這個方法可以留空
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // 協調器負責處理照片選擇的結果
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerView
        
        init(_ parent: PHPickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 無論是否選擇照片，選擇器都會關閉
            parent.presentationMode.wrappedValue.dismiss()
            
            // 如果沒有選擇照片，直接返回
            guard let provider = results.first?.itemProvider else { return }
            
            // 檢查是否可以載入 UIImage
            if provider.canLoadObject(ofClass: UIImage.self) {
                // 非同步載入圖片
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Error loading image: \(error.localizedDescription)")
                            return
                        }
                        
                        // 將載入的圖片指派給 selectedImage
                        self?.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}
