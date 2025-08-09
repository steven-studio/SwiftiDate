//
//  AuthServiceEnvironment.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

import SwiftUI

private struct AuthServiceKey: EnvironmentKey {
    // 預設給一個實作（或給一個 fatalError placeholder 也行）
    static var defaultValue: AuthService = FirebaseAuthService()
}

extension EnvironmentValues {
    var authService: AuthService {
        get { self[AuthServiceKey.self] }
        set { self[AuthServiceKey.self] = newValue }
    }
}
