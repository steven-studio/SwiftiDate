//
//  VerificationView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct VerificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var photos: [String] // Accept photos as a binding variable

    var body: some View {
        VStack {
            // Close button at the top left
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
            }
            
            Spacer()
            
            // Profile picture with verification icon
            VStack {
                ZStack {
                    // Example image (Replace with actual user image)
                    ProfileImageView(photoName: photos.first, frameWidth: 120, frameHeight: 160)
                    
                    // Verification badge at the bottom
                    Image(systemName: "checkmark.seal.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.white))
                        .offset(x: 40, y: 40)
                }
                .padding(.bottom, 20)
                
                // Main title
                Text("認證你的個人照片")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                // Subtitle
                Text("專屬認證標籤，優先推薦/曝光")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Error message section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                    Text("您的第一張照片無法進行真人認證哦")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 5)
                
                Text("• 真人認證將根據您上傳的第一張照片進行認證")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("• 請確認您的首張圖片中臉部沒有被遮擋，五官清楚")
                    .font(.subheadline)
                    .foregroundColor(.red)
                
                Text("• 請檢查您的頭像照片後再進行認證哦")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 4)
            .padding(.horizontal)
            
            Spacer()
            
            // Disclaimer text
            Text("請放心！收集的照片僅用於認證用途，不會被其他用戶看見")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Action buttons
            VStack(spacing: 10) {
                Button(action: {
                    // Add action for changing profile picture
                }) {
                    Text("更換頭像")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Add action for verification submission
                }) {
                    Text("認證")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.5)) // Disabled button style
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(true) // Disable the button if conditions are not met
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color(UIColor.systemGroupedBackground)) // Background color
        .edgesIgnoringSafeArea(.all)
    }
}

struct VerificationView_Previews: PreviewProvider {
    @State static var mockPhotos = ["photo1", "photo2", "photo3", "photo4", "photo5", "photo6"]

    static var previews: some View {
        VerificationView(photos: $mockPhotos)
            .environmentObject(UserSettings()) // Provide a mock UserSettings object
    }
}
