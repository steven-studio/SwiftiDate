//
//  ConsumableStore.swift
//  SwiftiDateUITests
//
//  Created by 游哲維 on 2025/3/12.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

// Define the app's subscription entitlements by level of service, with the highest level of service first.
// The numerical-level value matches the subscription's level that you configure in
// the StoreKit configuration file or App Store Connect.
public enum ServiceEntitlement: Int, Comparable {
    case notEntitled = 0
    
    case pro = 1
    case premium = 2
    case standard = 3
    
    init?(for product: Product) {
        // The product must be a subscription to have service entitlements.
        guard let subscription = product.subscription else {
            return nil
        }
        if #available(iOS 16.4, *) {
            self.init(rawValue: subscription.groupLevel)
        } else {
            switch product.id {
            case "subscription.standard":
                self = .standard
            case "subscription.premium":
                self = .premium
            case "subscription.pro":
                self = .pro
            default:
                self = .notEntitled
            }
        }
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        // Subscription-group levels are in descending order.
        return lhs.rawValue > rhs.rawValue
    }
}

class ConsumableStore: ObservableObject {
    
    @Published private(set) var turbos: [Product]
    @Published private(set) var crushes: [Product]
    @Published private(set) var praises: [Product]
    
    @Published private(set) var purchasedTurbos: [Product] = []
    @Published private(set) var purchasedCrushes: [Product] = []
    @Published private(set) var purchasedPraises: [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    // 產品識別碼與產品展示的映射，可根據你的產品設定調整
    private let consumableProductIDs: Set<String> = [
        "stevenstudio.SwiftiDate.turbo.1", // 例如 Turbo 產品
        "stevenstudio.SwiftiDate.turbo.5", // 例如 Turbo 產品
        "stevenstudio.SwiftiDate.turbo.10",  // 可以擴充更多產品
        "stevenstudio.SwiftiDate.crushes.5",
        "stevenstudio.SwiftiDate.crushes.30",
        "stevenstudio.SwiftiDate.crushes.60",
        "stevenstudio.SwiftiDate.praise.5",
        "stevenstudio.SwiftiDate.praise.30",
        "stevenstudio.SwiftiDate.praise.60"
    ]
    
    init() {
        turbos = []
        crushes = []
        praises = []
        
        // Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()
        
        Task {
            // During store initialization, request products from the App Store.
            await requestProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                                        
                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification.")
                }
            }
        }
    }
    
    // 向 App Store 請求消耗性產品
    @MainActor
    func requestProducts() async {
        do {
            // Request products from the App Store using the identifiers that the `Products.plist` file defines.
            let storeProducts = try await Product.products(for: consumableProductIDs)
            print("Fetched products: \(storeProducts.map { $0.id })") // 加上這行
            
            var newTurbos: [Product] = []
            var newCrushes: [Product] = []
            var newPraises: [Product] = []
            
            // Filter the products into categories based on their type.
            for product in storeProducts {
                let id = product.id.lowercased() // 轉成小寫方便比對
                if id.contains("turbo") {
                    newTurbos.append(product)
                } else if id.contains("crush") {
                    newCrushes.append(product)
                } else if id.contains("praise") {
                    newPraises.append(product)
                }
            }
            
            // 過濾出消耗性產品（應該與 consumableProductIDs 相符）
            turbos = sortByPrice(newTurbos)
            crushes = sortByPrice(newCrushes)
            praises = sortByPrice(newPraises)
        } catch {
            print("Failed product request from the App Store server. \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        // Begin purchasing the `Product` the user selects.
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            // Check whether the transaction is verified. If it isn't,
            // this function rethrows the verification error.
            let transaction = try checkVerified(verification)
            
            // Always finish a transaction.
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func isPurchased(_ product: Product) async throws -> Bool {
        // Determine whether the user purchases a given product.
        switch product.type {
        default:
            return false
        }
    }
        
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            // The result is verified. Return the unwrapped value.
            return safe
        }
    }
        
    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }
}
