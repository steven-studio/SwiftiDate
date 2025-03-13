//
//  CrushPurchaseView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/21.
//

import SwiftUI
import StoreKit

struct CrushPurchaseView: View {
    @Environment(\.presentationMode) var presentationMode // Environment variable to control view dismissal
    @EnvironmentObject var store: ConsumableStore
    
    @State var isPurchased: Bool = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    @State private var selectedOption = "30 Crushes" // Default selected option
    @State private var selectedProduct: Product? = nil  // 新增：用於儲存所選產品

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                // Mockup header with the phone image
                Image("crush_header") // Replace with your actual image
                    .resizable()
                    .scaledToFill() // Use scaledToFill to ensure the image fills the frame
                    .frame(width: UIScreen.main.bounds.width, height: 350) // Adjust the height to extend as much as needed
                    .clipped() // Clips any overflowed content to fit within the frame
                    .edgesIgnoringSafeArea(.top) // Extend to the top edges
                
                // Add the "X" button on top of the image
                Button(action: {
                    AnalyticsManager.shared.trackEvent("crush_purchase_view_dismissed")
                    presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                        .padding(16) // Add padding to give more space around the X button
                }
            }
            
            Text("使用 Crush 魅力無窮")
                .font(.headline)
                .padding(.top)
            
            Text("送出 Crush，讓對方可以馬上看見你！")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Crush options
            HStack(spacing: 10) {
                CrushOptionView(title: "60 Crushes",
                                 price: "NT$34/個",
                                 discount: "省 48%",
                                 isSelected: selectedOption == "60 Crushes",
                                 product: store.crushes[0],
                                 purchasingEnabled: true,
                                 selectedProduct: $selectedProduct) {
                    selectedOption = "60 Crushes"
                    AnalyticsManager.shared.trackEvent("crush_option_selected", parameters: ["option": "60 Crushes"])
                }
                CrushOptionView(title: "30 Crushes",
                                 price: "NT$43/個",
                                 discount: "省 33%",
                                 isSelected: selectedOption == "30 Crushes",
                                 product: store.crushes[1],
                                 purchasingEnabled: true,
                                 selectedProduct: $selectedProduct) {
                    selectedOption = "30 Crushes"
                    AnalyticsManager.shared.trackEvent("crush_option_selected", parameters: ["option": "30 Crushes"])
                }
                CrushOptionView(title: "5 Crushes",
                                 price: "NT$64/個",
                                 discount: "",
                                 isSelected: selectedOption == "5 Crushes",
                                 product: store.crushes[2],
                                 purchasingEnabled: true,
                                 selectedProduct: $selectedProduct) {
                    selectedOption = "5 Crushes"
                    AnalyticsManager.shared.trackEvent("crush_option_selected", parameters: ["option": "5 Crushes"])
                }
            }
            .padding(.horizontal)
            
            // Purchase button
            Button(action: {
                AnalyticsManager.shared.trackEvent("crush_purchase_button_tapped", parameters: [
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
                
                print("立即擁有 clicked with \(selectedOption)")
                // Handle the purchase logic here
            }) {
                Text("立即擁有")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Text("獲得後隨時用，永遠不會過期")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 10)
        }
        .navigationTitle("Crush")
        .navigationBarTitleDisplayMode(.inline)
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

struct CrushOptionView: View {
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
        .background(isSelected ? Color.green.opacity(0.3) : Color.green.opacity(0.1))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
        )
        .onTapGesture {
            // 更新父視圖的 selectedProduct
            selectedProduct = product
            print("[DEBUG] onTapGesture - \(title) tapped. Setting selectedProduct to: \(product.id)")
            onSelect()
        }
        // 改用 .accessibilityElement(children: .ignore) 將子視圖忽略，僅保留父容器作為可訪問元素
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("CrushOption_\(title)")
        .accessibilityIdentifier("CrushOption_\(title)")
        .accessibilityAddTraits(.isButton)
    }
}
