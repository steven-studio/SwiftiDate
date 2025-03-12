//
//  PrivacySettingsView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/11.
//

import Foundation
import SwiftUI

struct PrivacySettingsView: View {
    @Binding var isPresented: Bool
    
    // 用於控制視圖的消失
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss // ✅ 使用 SwiftUI 內建的 `dismiss`
    
    // 使用 @EnvironmentObject 引入 UserSettings
    @EnvironmentObject var userSettings: UserSettings
    
    // 直接使用 @AppStorage 來存儲和同步 selectedGender
    @AppStorage("globalSelectedGender") var selectedGender: String = "女生"

    @State private var showGenderSelection = false // 控制顯示性別選擇頁面
    @State private var isIncognitoModeOn = false // 控制隱身模式的開關
    @State private var searchRange: Double = 100 // 控制最大搜索範圍
    @State private var autoExpandSearch = true // 控制自動擴大搜索範圍
    @State private var lowerAge: Double = 18 // 最小年齡
    @State private var upperAge: Double = 33 // 最大年齡

    var body: some View {
        NavigationView {
            // 向我展示（性別選擇）
            if showGenderSelection {
                GenderSelectionView(selectedGender: $selectedGender, showGenderSelection: $showGenderSelection)
                    .onAppear {
                        AnalyticsManager.shared.trackEvent("privacy_gender_selection_view_appear")
                    }
            } else {
                VStack {
//                    // 標題
//                    ZStack {
//                        // 返回按鈕，放在左側
//                        HStack {
//                            Button(action: {
//                                print("✅ Button 被點擊了！")
//                                presentationMode.wrappedValue.dismiss()
//                            }) {
//                                Image(systemName: "chevron.left")
//                                    .foregroundColor(.gray)
//                                    .padding()
//                            }
//                            .zIndex(999) // ✅ 提升 zIndex 避免被覆蓋
//                            .highPriorityGesture(TapGesture()) // ✅ 確保 Button 具有最高點擊優先權
//
//                            Spacer() // 用 Spacer 把按鈕推到左側
//                        }
//
//                        // 中間的標題
//                        Text("篩選")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                    }
//                    .frame(maxWidth: .infinity) // 讓ZStack佔滿整個寬度
                    
                    // 篩選條件標題
                    HStack {
                        Text("隱私設置")
                            .font(.headline)
                            .foregroundColor(.gray)

                        if userSettings.isSupremeUser {
                            // "Supreme" 標籤
                            Text("Supreme")
                                .font(.caption)
                                .fontWeight(.bold) // 粗體
                                .italic() // 斜體
                                .foregroundColor(.gold) // 金色文字
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.black) // 黑色背景
                                .cornerRadius(10) // 圓角效果
                                .padding(.leading, 8) // 調整與 "隱私設置" 的間距
                        }
                        
                        Spacer() // 將文字推向左側
                    }
                    .padding(.leading)
                    
                    if userSettings.isSupremeUser {
                        // 隱身模式卡片
                        ZStack {
                            // 黑色背景圖片
                            Image("incognitoModeBackground")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 400) // 調整圖片的高度以適應需要的區域
                                .clipShape(Rectangle()) // Crop it to a square shape
                                .cornerRadius(20) // 圓角效果

                            // 內容，疊加在黑色背景圖片上
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("隱身模式")
                                        .font(.headline)
                                        .foregroundColor(.white) // 白色文字，對比黑色背景
                                    Text("只有你主動喜歡的人才能看見你")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.7)) // 調整透明度，使其更柔和
                                }
                                Spacer()
                                Toggle(isOn: $isIncognitoModeOn) {
                                    Text("")
                                }
                                .labelsHidden()
                            }
                            .padding()
                        }
                        .frame(height: 200) // 確保整體區塊有適當的高度
                        .cornerRadius(20) // 讓圖片和內容都具有圓角效果
                        .shadow(radius: 10) // 為整個區塊添加陰影效果
                    }

                    Divider()

                    // 篩選條件標題
                    HStack {
                        Text("篩選條件")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer() // 這個 Spacer() 將文字推向左側
                    }
                    .padding(.leading)
                    
                    // 向我展示（性別選擇）
                    HStack {
                        Text("向我展示")
                        Spacer()
                        Text(selectedGender) // 根據用戶的篩選選擇
                            .foregroundColor(.gray)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .onTapGesture {
                        AnalyticsManager.shared.trackEvent("privacy_settings_gender_selection_tapped")
                        showGenderSelection = true
                    }

                    Divider()

                    // 搜索範圍
                    VStack(alignment: .leading) {
                        HStack {
                            Text("最大範圍")
                            Spacer()
                            Text("\(Int(searchRange))km+")
                                .foregroundColor(.gray)
                        }
                        Slider(value: $searchRange, in: 0...100)
                            .accentColor(.green)
                    }
                    .padding()

                    // 自動擴大搜索範圍
                    HStack {
                        Text("自動擴大搜索範圍")
                        Spacer()
                        Toggle(isOn: $autoExpandSearch) {
                            Text("")
                        }
                        .labelsHidden()
                    }
                    .padding()

                    Divider()

                    // 年齡範圍
                    VStack(alignment: .leading) {
                        HStack {
                            Text("年齡")
                            Spacer()
                            Text("\(Int(lowerAge)) - \(Int(upperAge))")
                                .foregroundColor(.gray)
                        }
                        // 直接將RangeSlider邏輯合併進來
                        VStack {
                            Slider(value: $lowerAge, in: 18...upperAge) // 設置下限滑塊
                            Slider(value: $upperAge, in: lowerAge...50)  // 設置上限滑塊
                        }
                        .accentColor(.green)
                    }
                    .padding()

                    Spacer()
                }
                .background(Color.white)
                .navigationBarTitle("篩選", displayMode: .inline)
                .navigationBarItems(
                    leading: backButton
                )
                .onAppear {
                    AnalyticsManager.shared.trackEvent("privacy_settings_view_appear")
                }
            }
        }
    }
    
    @inline(never) // ✅ 禁止 Swift 優化這個函數
    func buttonAction() {
        print("✅ Button 被點擊了！")
        presentationMode.wrappedValue.dismiss()
    }
    
    // "返回" 按鈕的行為
    private var backButton: some View {
        Button(action: {
            AnalyticsManager.shared.trackEvent("privacy_settings_back_tapped")
            buttonAction()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
            }
        }
    }
}

// 自定義的RangeSlider
struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>

    @State private var lowerValue: Double
    @State private var upperValue: Double

    init(range: Binding<ClosedRange<Double>>, bounds: ClosedRange<Double>) {
        self._range = range
        self.bounds = bounds
        self._lowerValue = State(initialValue: range.wrappedValue.lowerBound)
        self._upperValue = State(initialValue: range.wrappedValue.upperBound)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 滑軌
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6)

                // 選擇範圍
                Capsule()
                    .fill(Color.green)
                    .frame(width: CGFloat(self.rangeWidth(geometry: geometry)), height: 6)
                    .offset(x: self.rangeOffset(geometry: geometry))

                // 左邊滑塊
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    .offset(x: self.xOffsetForValue(self.lowerValue, in: geometry))

                // 右邊滑塊
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .overlay(Circle().stroke(Color.green, lineWidth: 2))
                    .offset(x: self.xOffsetForValue(self.upperValue, in: geometry))

                // 左邊滑塊的拖動手勢
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.onDragChanged(value: value, isUpper: false, geometry: geometry)
                            }
                    )
                    .offset(x: self.xOffsetForValue(self.lowerValue, in: geometry))

                // 右邊滑塊的拖動手勢
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                self.onDragChanged(value: value, isUpper: true, geometry: geometry)
                            }
                    )
                    .offset(x: self.xOffsetForValue(self.upperValue, in: geometry))
            }
            .onChange(of: lowerValue) { oldValue, newValue in
                range = newValue...upperValue
            }
            .onChange(of: upperValue) { oldValue, newValue in
                range = lowerValue...newValue
            }
        }
    }

    // 計算選擇範圍的寬度
    private func rangeWidth(geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let lowerOffset = CGFloat((lowerValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * totalWidth
        let upperOffset = CGFloat((upperValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * totalWidth
        return upperOffset - lowerOffset
    }

    // 計算選擇範圍的偏移量
    private func rangeOffset(geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        let lowerOffset = CGFloat((lowerValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * totalWidth
        return lowerOffset - totalWidth / 2
    }

    // 根據值計算X軸的偏移量
    private func xOffsetForValue(_ value: Double, in geometry: GeometryProxy) -> CGFloat {
        let totalWidth = geometry.size.width
        return CGFloat((value - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)) * totalWidth - totalWidth / 2
    }

    // 當滑塊被拖動時，更新數值
    private func onDragChanged(value: DragGesture.Value, isUpper: Bool, geometry: GeometryProxy) {
        let totalWidth = geometry.size.width
        let newValue = bounds.lowerBound + Double((value.location.x / totalWidth)) * (bounds.upperBound - bounds.lowerBound)

        if isUpper {
            self.upperValue = min(max(newValue, lowerValue), bounds.upperBound)
        } else {
            self.lowerValue = max(min(newValue, upperValue), bounds.lowerBound)
        }
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView(isPresented: .constant(true))
            .environmentObject(UserSettings()) // 注入 UserSettings
    }
}
