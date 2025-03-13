//
//  TransactionProtocol.swift
//  SwiftiDateTests
//
//  Created by 游哲維 on 2025/3/12.
//

import StoreKit

protocol TransactionProtocol {
    var transactionState: SKPaymentTransactionState { get }
    var payment: SKPayment { get }
    var error: Error? { get }
}

extension SKPaymentTransaction: TransactionProtocol { }
