//
//  LifestylePhotoView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

enum PhotoCategory {
    case selfie
    case interest
    case travel
}

struct LifestylePhotoView: View {
    @EnvironmentObject var userSettings: UserSettings   // ← 新增
    @EnvironmentObject var appState: AppState           // ← 新增
    
    // 用來存放使用者上傳的圖片
    @State private var selfieImage: UIImage?
    @State private var interestImage: UIImage?
    @State private var travelImage: UIImage?
    
    // 是否顯示 ImagePicker
    @State private var showImagePicker = false
    // 紀錄當前使用者要上傳哪一種類別
    @State private var selectedCategory: PhotoCategory?
    @State private var showTaggingFullScreen = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    // 返回上一頁前追蹤返回事件
                    AnalyticsManager.shared.trackEvent("CreatePassword_BackTapped", parameters: nil)
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                        .padding(.leading)
                }
                Spacer()
                Button("略過") {
                    // 略過行為：可依需求跳過或記錄事件
                    print("使用者點擊略過")
                }
                .padding(.trailing, 20)
            }
            .padding(.top)
            
            // 標題
            Text("你的生活")
                .font(.title)
                .bold()
            
            // 三個上傳區塊
            VStack(spacing: 20) {
                photoRow(title: "自拍", image: selfieImage, category: .selfie)
                photoRow(title: "興趣", image: interestImage, category: .interest)
                photoRow(title: "旅行", image: travelImage, category: .travel)
            }
            .padding(.horizontal, 30)
            
            // 底部提示文字
            Text("照片越是豐富，越容易收別人的喜歡哦…")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // 「繼續」按鈕
            Button(action: {
                // 按下繼續的行為
                print("使用者點擊繼續")
                showTaggingFullScreen = true
            }) {
                Text("繼續")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .frame(width: 300)
                    .cornerRadius(25)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 30)
        }
        .sheet(isPresented: $showImagePicker) {
            // 在這裡放你的 ImagePicker / Photo Picker
            // 例如:
            // ImagePicker(sourceType: .photoLibrary, selectedImage: $tempImage)
            //   .onDisappear {
            //       // 根據 selectedCategory 決定要存到 selfieImage / interestImage / travelImage
            //   }
        }
        .fullScreenCover(isPresented: $showTaggingFullScreen) {
            TaggingView(
                // selfieImage: selfieImage, interestImage: interestImage, travelImage: travelImage
            )
        }
    }
    
    // MARK: - 單一上傳區塊
    private func photoRow(title: String, image: UIImage?, category: PhotoCategory) -> some View {
        HStack(spacing: 12) {
            // 圖示或圖片區
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: 50, height: 50)
                
                if let img = image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.green)
                }
            }
            
            // 標題文字
            Text(title)
                .font(.headline)
            
            Spacer()
        }
        .contentShape(Rectangle()) // 讓整個區塊可點擊
        .onTapGesture {
            // 使用者點擊後要上傳哪一類圖片
            selectedCategory = category
            showImagePicker = true
        }
    }
}

struct LifestylePhotoView_Previews: PreviewProvider {
    static var previews: some View {
        LifestylePhotoView()
    }
}
