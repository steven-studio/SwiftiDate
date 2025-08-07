//
//  MatchTipsPopupView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/7.
//

import SwiftUI

struct MatchTipsPopupView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack {
                Spacer()
                
                // 主要內容容器
                ZStack {
                    // 背景
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 600)
                    
                    VStack(spacing: 0) {
                        // 關閉按鈕
                        HStack {
                            Spacer()
                            Button(action: {
                                isPresented = false
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                        .padding(.horizontal, 10)
                        
                        // 裝飾性圖片區域
                        ZStack {
                            // 背景色塊
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.1))
                                .frame(height: 250)
                            
                            // 裝飾元素
                            VStack {
                                // 模擬照片卡片
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: 120, height: 160)
                                        .rotationEffect(.degrees(-10))
                                    
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.pink.opacity(0.3))
                                        .frame(width: 120, height: 160)
                                        .rotationEffect(.degrees(5))
                                    
                                    // "Match" 標籤
                                    Text("Match")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 15)
                                        .padding(.vertical, 5)
                                        .background(Color.cyan)
                                        .cornerRadius(20)
                                        .rotationEffect(.degrees(-15))
                                        .offset(x: -20, y: -80)
                                }
                                
                                // 裝飾圖標
                                HStack(spacing: 15) {
                                    // 笑臉 emoji
                                    Text("😊")
                                        .font(.system(size: 30))
                                        .padding(10)
                                        .background(Color.purple.opacity(0.2))
                                        .cornerRadius(15)
                                    
                                    // 音符圖標
                                    Image(systemName: "music.note")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.pink)
                                        .cornerRadius(15)
                                    
                                    // 讚圖標
                                    Image(systemName: "hand.thumbsup.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.orange)
                                        .cornerRadius(15)
                                    
                                    // 餐具圖標
                                    Image(systemName: "fork.knife")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                        .padding(12)
                                        .background(Color.yellow)
                                        .cornerRadius(15)
                                }
                                .offset(y: 20)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer().frame(height: 30)
                        
                        // 標題
                        Text("在Omi上獲得更多配對的秘訣")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Spacer().frame(height: 30)
                        
                        // 建議清單
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                                Text("三張以上的個人照片")
                                    .font(.body)
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                                Text("完善個人資料和興趣標籤")
                                    .font(.body)
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                                Text("一段有趣的自我介紹來展現獨特個性")
                                    .font(.body)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer().frame(height: 40)
                        
                        // 行動按鈕
                        Button(action: {
                            // 記錄用戶點擊事件
                            AnalyticsManager.shared.trackEvent("MatchTips_TryNowTapped", parameters: nil)
                            isPresented = false
                            // 這裡可以導向個人資料編輯頁面
                        }) {
                            Text("馬上試試")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.green)
                                .cornerRadius(25)
                                .padding(.horizontal, 30)
                        }
                        
                        Spacer().frame(height: 30)
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .onAppear {
            // 記錄彈窗顯示事件
            AnalyticsManager.shared.trackEvent("MatchTips_PopupShown", parameters: nil)
        }
    }
}
