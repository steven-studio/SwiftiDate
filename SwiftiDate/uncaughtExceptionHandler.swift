//
//  uncaughtExceptionHandler.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/1.
//

import Foundation
import FirebaseCrashlytics

// 全局未捕獲異常處理函數
func uncaughtExceptionHandler(exception: NSException) {
    let error = NSError(domain: exception.name.rawValue,
                        code: 0,
                        userInfo: [NSLocalizedDescriptionKey: exception.reason ?? "No reason"])
    Crashlytics.crashlytics().record(error: error)
    print("Uncaught exception logged to Crashlytics: \(exception.name.rawValue)")
}
