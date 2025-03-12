//
//  PraisePurchaseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/21.
//

import Foundation
import SwiftUI
import StoreKit

struct PraisePurchaseView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to control view dismissal
    @EnvironmentObject var store: ConsumableStore  // 取得 store.praises 產品資料
    
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    @State private var selectedOption = "30次讚美" // Default selected option
    @State private var selectedProduct: Product? = nil  // 新增：用於儲存所選產品

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Mockup header with the phone image
                Image("praise_header") // Replace with your actual image
                    .resizable()
                    .scaledToFill() // Use scaledToFill to ensure the image fills the frame
                    .frame(width: UIScreen.main.bounds.width, height: 350) // Adjust the height to extend as much as needed
                    .clipped() // Clips any overflowed content to fit within the frame
                    .edgesIgnoringSafeArea(.top) // Extend to the top edges
                
                // Add the "X" button on top of the image
                Button(action: {
                    AnalyticsManager.shared.trackEvent("praise_purchase_view_dismissed")
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                        .padding(16) // Add padding to give more space around the X button
                }
            }
            
            Text("想使用更多次的讚美嗎？")
                .font(.headline)
                .padding(.top)
            
            Text("一鍵讚美心儀對象，你的喜歡無需等待")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Praise options
            HStack(spacing: 10) {
                PraiseOptionView(
                    title: "60次讚美",
                    price: "NT$34/次",
                    discount: "省 52%",
                    isSelected: selectedOption == "60次讚美",
                    product: store.praises.first(where: { $0.id == "stevenstudio.SwiftiDate.praise.60" })!,
                    purchasingEnabled: true,
                    selectedProduct: $selectedProduct
                ) {
                    selectedOption = "60次讚美"
                }
                
                PraiseOptionView(
                    title: "30次讚美",
                    price: "NT$42/次",
                    discount: "省 40%",
                    isSelected: selectedOption == "30次讚美",
                    product: store.praises.first(where: { $0.id == "stevenstudio.SwiftiDate.praise.30" })!,
                    purchasingEnabled: true,
                    selectedProduct: $selectedProduct
                ) {
                    selectedOption = "30次讚美"
                }
                
                PraiseOptionView(
                    title: "5次讚美",
                    price: "NT$70/次",
                    discount: "",
                    isSelected: selectedOption == "5次讚美",
                    product: store.praises.first(where: { $0.id == "stevenstudio.SwiftiDate.praise.5" })!,
                    purchasingEnabled: true,
                    selectedProduct: $selectedProduct
                ) {
                    selectedOption = "5次讚美"
                }
            }
            .padding(.horizontal)
            
            // Purchase button
            Button(action: {
                AnalyticsManager.shared.trackEvent("praise_purchase_button_tapped", parameters: [
                    "selected_option": selectedOption
                ])
                
                // 檢查使用者的地區代碼
                let regionCode = Locale.current.region?.identifier ?? "US" // 預設為 US
                if regionCode == "CN" {
                    // 假設這是微信支付或支付寶支付的 URL
                    if let url = URL(string: "weixin://pay?params=xxx") {
                        UIApplication.shared.open(url)
                    } else {
                        print("無法打開微信支付 URL")
                    }
                } else {
                    if let product = selectedProduct {
                        Task {
                            await buy(product)
                        }
                    } else {
                        print("尚未選擇產品")
                    }
                }
                
                print("立即獲取 clicked")
                // 在這裡添加購買邏輯
            }) {
                Text("立即獲取")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Text("獲得後隨時用，永遠不會過期")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .navigationTitle("讚美")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            AnalyticsManager.shared.trackEvent("praise_purchase_view_appear")
        }
    }
    
    func buy(_ product: Product) async {
        print("[DEBUG] buy(_:) called with product.id = \(product.id)")
        do {
            if try await store.purchase(product) != nil {
                withAnimation {
                    isPurchased = true
                }
                print("[DEBUG] Successfully purchased \(product.id)")
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
            print("[ERROR] Purchase verification failed for \(product.id)")
        } catch {
            print("Failed purchase for \(product.id). \(error)")
        }
    }
}

struct PraiseOptionView: View {
    var title: String
    var price: String
    var discount: String
    var isSelected: Bool
    
    let product: Product
    let purchasingEnabled: Bool
    
    // 新增：Binding，讓父視圖能夠更新所選產品
    @Binding var selectedProduct: Product?
    
    var onSelect: () -> Void

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)
            
            if !discount.isEmpty {
                Text(discount)
                    .font(.subheadline)
                    .foregroundColor(.red)
                    .padding(3)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(5)
            }
            
            Text(price)
                .font(.subheadline)
        }
        .frame(width: 100, height: 120)
        .background(isSelected ? Color.orange.opacity(0.3) : Color.orange.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            // 更新父視圖的 selectedProduct
            selectedProduct = product
            print("[DEBUG] onTapGesture - \(title) tapped. Setting selectedProduct to: \(product.id)")
            onSelect()
        }
    }
}
