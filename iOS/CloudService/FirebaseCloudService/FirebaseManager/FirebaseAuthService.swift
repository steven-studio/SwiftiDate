//
//  FirebaseAuthService.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthService: AuthService {

    func signInAnonymously() async -> Result<UserID, AuthError> {
        do {
            let result = try await Auth.auth().signInAnonymously()
            return .success(result.user.uid)
        } catch { return .failure(map(error)) }
    }

    func startPhoneVerification(phone: String) async -> Result<VerificationID, AuthError> {
        await withCheckedContinuation { cont in
            PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { vid, err in
                if let err = err { cont.resume(returning: .failure(self.map(err))) }
                else if let vid = vid { cont.resume(returning: .success(vid)) }
                else { cont.resume(returning: .failure(.unknown("nil verificationID"))) }
            }
        }
    }

    func verifyOTP(verificationID: String, code: String) async -> Result<UserID, AuthError> {
        let cred = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        do {
            let result = try await Auth.auth().signIn(with: cred)
            return .success(result.user.uid)
        } catch { return .failure(map(error)) }
    }

    func linkAnonymousWithPhone(verificationID: String, code: String) async -> Result<UserID, AuthError> {
        guard let user = Auth.auth().currentUser else { return .failure(.sessionExpired) }
        let cred = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        do {
            let result = try await user.link(with: cred)
            return .success(result.user.uid)
        } catch { return .failure(map(error)) }
    }

    func signOut() -> Result<Void, AuthError> {
        do { try Auth.auth().signOut(); return .success(()) }
        catch { return .failure(map(error)) }
    }

    private func map(_ error: Error) -> AuthError {
        let ns = error as NSError
        switch (ns.domain, ns.code) {
        case (AuthErrorDomain, AuthErrorCode.invalidVerificationCode.rawValue): return .invalidOTP
        case (AuthErrorDomain, AuthErrorCode.invalidPhoneNumber.rawValue):     return .invalidPhoneFormat
        case (AuthErrorDomain, AuthErrorCode.quotaExceeded.rawValue):          return .rateLimited
        case (AuthErrorDomain, AuthErrorCode.credentialAlreadyInUse.rawValue): return .credentialAlreadyInUse
        case (NSURLErrorDomain, _):                                               return .network
        default:                                                                   return .unknown("\(ns.domain)#\(ns.code): \(ns.localizedDescription)")
        }
    }
}
