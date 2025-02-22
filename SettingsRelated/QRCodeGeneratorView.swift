//
//  QRCodeGeneratorView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/21.
//

import Foundation
import SwiftUI
import FirebaseFunctions
import CoreImage.CIFilterBuiltins

struct QRCodeGeneratorView: View {
    @State private var tokenId: String = ""
    @State private var qrImage: UIImage? = nil
    @State private var errorMessage: String = ""
    
    // 是否顯示 loading 或者 alert
    @State private var isLoading: Bool = false
    
    // 取得 Functions 實例
    private let functions = Functions.functions()

    var body: some View {
        VStack(spacing: 20) {
            Text("產生 QR Code")
                .font(.title)
                .padding()

            if isLoading {
                ProgressView("取得 tokenId 中...")
            } else {
                // 如果已有 tokenId，就生成 / 顯示對應 QR Code
                if let image = qrImage {
                    Image(uiImage: image)
                        .resizable()
                        .interpolation(.none)  // 避免QRCode模糊
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                    
                    Text("TokenID: \(tokenId)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    Text("尚未產生 tokenId")
                        .foregroundColor(.secondary)
                }
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }

            Button(action: {
                createTokenAndGenerateQR()
            }) {
                Text("生成 Token 並產生 QRCode")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
    }
    
    /// 呼叫 Cloud Function，拿到 tokenId 後生成 QR Code
    private func createTokenAndGenerateQR() {
        isLoading = true
        errorMessage = ""
        
        functions.httpsCallable("createMatchToken").call([:]) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "createMatchToken error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = result?.data as? [String: Any],
                      let token = data["tokenId"] as? String
                else {
                    self.errorMessage = "回傳資料格式錯誤"
                    return
                }
                
                self.tokenId = token
                // 產生 QR code
                self.qrImage = generateQRCode(from: token)
            }
        }
    }
    
    /// 利用 CIFilter 產生 QRCode 圖像
    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")

        // 產生 CIImage
        guard let ciImage = filter.outputImage else { return nil }
        
        // 放大 / scale up
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciImage.transformed(by: transform)

        // 轉成 UIImage
        if let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
