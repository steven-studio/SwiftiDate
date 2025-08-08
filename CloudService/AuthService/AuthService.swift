//
//  AuthService.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

import Foundation

public typealias UserID = String
public typealias VerificationID = String

public protocol AuthService {
    func signInAnonymously() async -> Result<UserID, AuthError>
    func startPhoneVerification(phone: String) async -> Result<VerificationID, AuthError>
    func verifyOTP(verificationID: String, code: String) async -> Result<UserID, AuthError>
    func linkAnonymousWithPhone(verificationID: String, code: String) async -> Result<UserID, AuthError>
    func signOut() -> Result<Void, AuthError>
}

public enum AuthError: Error {
    case invalidPhoneFormat
    case smsNotSent
    case invalidOTP
    case sessionExpired
    case credentialAlreadyInUse
    case network
    case rateLimited
    case unknown(String)
}
