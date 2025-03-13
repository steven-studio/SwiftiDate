/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The class responsible for requesting products from the App Store and starting purchases.
*/

import Foundation
import StoreKit

class Store: ObservableObject {

    @Published private(set) var cars: [Product]
    @Published private(set) var fuel: [Product]
    @Published private(set) var subscriptions: [Product]
    @Published private(set) var nonRenewables: [Product]
    
    @Published private(set) var purchasedCars: [Product] = []
    @Published private(set) var purchasedNonRenewableSubscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: Product.SubscriptionInfo.Status?
    
    var updateListenerTask: Task<Void, Error>? = nil

    private let productIdToEmoji: [String: String]

    init() {
        productIdToEmoji = Store.loadProductIdToEmojiData()

        // Initialize empty products, then do a product request asynchronously to fill them in.
        cars = []
        fuel = []
        subscriptions = []
        nonRenewables = []

        // Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()

        Task {
            // During store initialization, request products from the App Store.
            await requestProducts()

            // Deliver products that the customer purchases.
            await updateCustomerProductStatus()
        }
    }

    deinit {
        updateListenerTask?.cancel()
    }
    
    static func loadProductIdToEmojiData() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String] else {
            return [:]
        }
        return data
    }

    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            // Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    // Deliver products to the user.
                    await self.updateCustomerProductStatus()

                    // Always finish a transaction.
                    await transaction.finish()
                } catch {
                    // StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification.")
                }
            }
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            // Request products from the App Store using the identifiers that the `Products.plist` file defines.
            let storeProducts = try await Product.products(for: productIdToEmoji.keys)

            var newCars: [Product] = []
            var newSubscriptions: [Product] = []
            var newNonRenewables: [Product] = []
            var newFuel: [Product] = []

            // Filter the products into categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newFuel.append(product)
                case .nonConsumable:
                    newCars.append(product)
                case .autoRenewable:
                    newSubscriptions.append(product)
                case .nonRenewable:
                    newNonRenewables.append(product)
                default:
                    // Ignore this product.
                    print("Unknown product.")
                }
            }

            // Sort each product category by price, lowest to highest, to update the store.
            cars = sortByPrice(newCars)
            subscriptions = sortByPrice(newSubscriptions)
            nonRenewables = sortByPrice(newNonRenewables)
            fuel = sortByPrice(newFuel)
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

            // The transaction is verified. Deliver content to the user.
            await updateCustomerProductStatus()

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
        case .nonRenewable:
            return purchasedNonRenewableSubscriptions.contains(product)
        case .nonConsumable:
            return purchasedCars.contains(product)
        case .autoRenewable:
            return purchasedSubscriptions.contains(product)
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

    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedCars: [Product] = []
        var purchasedSubscriptions: [Product] = []
        var purchasedNonRenewableSubscriptions: [Product] = []

        // Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                // Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)

                // Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {
                case .nonConsumable:
                    if let car = cars.first(where: { $0.id == transaction.productID }) {
                        purchasedCars.append(car)
                    }
                case .nonRenewable:
                    if let nonRenewable = nonRenewables.first(where: { $0.id == transaction.productID }),
                       transaction.productID == "nonRenewing.standard" {
                        // Non-renewing subscriptions have no inherent expiration date, so `Transaction.currentEntitlements`
                        // always contains them after the user purchases them.
                        // This app defines this non-renewing subscription's expiration date to be one year after purchase.
                        // If the current date is within one year of the `purchaseDate`, the user is still entitled to this
                        // product.
                        let currentDate = Date()
                        let expirationDate = Calendar(identifier: .gregorian).date(byAdding: DateComponents(year: 1),
                                                                   to: transaction.purchaseDate)!

                        if currentDate < expirationDate {
                            purchasedNonRenewableSubscriptions.append(nonRenewable)
                        }
                    }
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
            } catch {
                print()
            }
        }

        // Update the store information with the purchased products.
        self.purchasedCars = purchasedCars
        self.purchasedNonRenewableSubscriptions = purchasedNonRenewableSubscriptions

        // Update the store information with auto-renewable subscription products.
        self.purchasedSubscriptions = purchasedSubscriptions

        // Check the `subscriptionGroupStatus` to learn the auto-renewable subscription state to determine whether the customer
        // is new (never subscribed), active, or inactive (expired subscription).
        // This app has only one subscription group, so products in the subscriptions array all belong to the same group.
        // Customers can be subscribed to only one product in the subscription group.
        // The statuses that `product.subscription.status` returns apply to the entire subscription group.
        subscriptionGroupStatus = try? await subscriptions.first?.subscription?.status.max { lhs, rhs in
            // There may be multiple statuses for different family members, because this app supports Family Sharing.
            // The subscriber is entitled to service for the status with the highest level of service.
            let lhsEntitlement = entitlement(for: lhs)
            let rhsEntitlement = entitlement(for: rhs)
            return lhsEntitlement < rhsEntitlement
        }
    }

    func emoji(for productId: String) -> String {
        return productIdToEmoji[productId]!
    }

    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }

    // Get a subscription's level of service using the product ID.
    func entitlement(for status: Product.SubscriptionInfo.Status) -> ServiceEntitlement {
        // If the status is expired, then the customer is not entitled.
        if status.state == .expired || status.state == .revoked {
            return .notEntitled
        }
        // Get the product associated with the subscription status.
        let productID = status.transaction.unsafePayloadValue.productID
        guard let product = subscriptions.first(where: { $0.id == productID }) else {
            return .notEntitled
        }
        // Finally, get the corresponding entitlement for this product.
        return ServiceEntitlement(for: product) ?? .notEntitled
    }
}
