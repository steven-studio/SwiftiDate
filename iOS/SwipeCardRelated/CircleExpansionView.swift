//
//  CircleExpansionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/10.
//

import SwiftUI

struct CircleExpansionView: View {
    @State private var circles: [CircleData] = [] // 用來存儲圓圈的數據
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // 定時器，每 1 秒產生一個圓圈
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea() // 背景顏色
            
            VStack {
                // 將圖片放置在圓圈中央
                ZStack {
                    Image("photo1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150) // 調整圖片大小
                        .clipShape(Circle()) // 圖片也變成圓形
                    
                    ForEach(circles.indices, id: \.self) { index in
                        ZStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 100, height: 100)
                                .scaleEffect(circles[index].scale)
                                .opacity(circles[index].opacity)
                        }
                        .onAppear {
                            // 使用索引修改數據
                            withAnimation(Animation.easeOut(duration: 1.5)) {
                                circles[index].scale = 5.0 // 圓圈擴大
                                circles[index].opacity = 0.0 // 圓圈消失
                            }
                        }
                    }
                }

                // 添加下方的文字
                VStack {
                    Text("附近沒有更多的人了")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 30)
                    
                    Text("可以嘗試擴大距離和年齡範圍")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)

                    Button(action: {
                        // 動作：例如顯示設定條件
                    }) {
                        HStack {
                            Text("編輯篩選條件")
                            Image(systemName: "chevron.right")
                        }
                        .foregroundColor(.green)
                        .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onReceive(timer) { _ in
            // 每 0.5 秒生成一個新的圓圈
            let newCircle = CircleData(id: UUID(), scale: 0.1, opacity: 1.0)
            circles.append(newCircle)
        }
    }
}

// 用來表示圓圈的數據模型
struct CircleData: Identifiable {
    let id: UUID
    var scale: CGFloat
    var opacity: Double
}

struct CircleExpansionView_Previews: PreviewProvider {
    static var previews: some View {
        CircleExpansionView()
    }
}
