//
//  AuthError.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/6.
//

enum AuthError: Error {
    case firebaseNotInitialized
    case otpSendFailed(String)
    case invalidVerificationID
    case signInFailed(String)
    case unknown(String)
}
