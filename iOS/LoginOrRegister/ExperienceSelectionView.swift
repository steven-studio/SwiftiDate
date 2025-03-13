//
//  ExperienceSelectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/4.
//

import Foundation
import SwiftUI

struct ExperienceSelectionView: View {
    @State private var showNotificationInfo = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        // 返回上一頁前追蹤返回事件
                        AnalyticsManager.shared.trackEvent("ExperienceSelection_BackTapped", parameters: nil)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.5)) // 設置文字顏色為黑色
                            .padding(.leading)
                    }
                    Spacer()
                }
                .padding(.top)
                
                // 頂部標題
                Text("請選擇你的體驗類型")
                    .font(.title)
                    .bold()
                    .padding(.top, 10)
                    .padding(.bottom, 30)
                
                // 卡片
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 40) {
                        Text("完整體驗")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        // 核取項目列表
                        checkmarkRow("訂閱配對通知與新訊息提醒")
                        checkmarkRow("個性化推薦")
                        checkmarkRow("第一時間領取限時好康")
                    }
                    .padding()
                    
                    // 綠色按鈕
                    Button {
                        // 按下「點擊開啟完整體驗」的行為
                        print("使用者選擇開啟完整體驗")
                    } label: {
                        HStack {
                            Text("點擊開啟完整體驗")
                                .foregroundColor(.white)
                                .padding()
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward.2")
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green)
                        .cornerRadius(8)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.green, lineWidth: 2) // 外框綠色
                )
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9) // 可依設計需求調整
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // 底部「使用不完整體驗」按鈕
                Button {
                    // 按下「使用不完整體驗」的行為
                    print("使用者選擇不完整體驗")
                } label: {
                    HStack {
                        Text("使用不完整體驗")
                            .foregroundColor(.gray)
                            .padding()
                        
                        Spacer()
                        
                        Image(systemName: "chevron.forward.2")
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    // 1. 先設定想要的尺寸
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                    // 2. 再套用 overlay 讓外框貼合這個 frame
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(UIColor.systemGray5), lineWidth: 2)
                    )
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            
            // MARK: - 通知提醒彈窗 (Overlay)
            if showNotificationInfo {
                // 半透明背景
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // 點背景關閉
                        showNotificationInfo = false
                    }
                
                // 彈出卡片
                notificationInfoCard
            }
        }
    }
    
    // MARK: - 小工具：核取列
    @ViewBuilder
    private func checkmarkRow(_ text: String) -> some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: "checkmark")
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
    
    // MARK: - 通知提醒卡片視圖
    private var notificationInfoCard: some View {
        VStack {
            Image(systemName: "xmark")
                .font(.system(size: 20))
                .foregroundColor(.gray.opacity(0.5))
                .bold()
                .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("如何開啟通知提醒")
                .font(.system(size: 24))
                .bold()
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            Text("跳轉到設定，點擊「通知」")
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            HStack {
                Image(systemName: "bell.square.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.orange)
                
                Text("通知")
                    .font(.system(size: 18))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
            .padding(.bottom, 5)
            
            Divider()
            
            Text("點擊右側的允許通知的開關，即可開啟")
                .font(.system(size: 18))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            Divider()
            
            // 模擬一個「允許通知」切換
            HStack {
                Text("允許通知")
                    .font(.system(size: 18))
                Spacer()
                Toggle("", isOn: .constant(true))
                    .labelsHidden()
            }
            .padding(.top, 5)
            .padding(.bottom, 5)
            
            Divider()
            
            Button {
                // 這裡可以跳到 iOS 設定 (無法直接跳，但可提示用戶)
                print("使用者點擊『知道了，現在去設定』")
                // 關閉視窗
                showNotificationInfo = false
            } label: {
                Text("知道了，現在去設定")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .frame(width: 300, height: 50)
                    .cornerRadius(25)
            }
            .padding(.top, 20)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
    }

}

struct ExperienceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceSelectionView()
    }
}
