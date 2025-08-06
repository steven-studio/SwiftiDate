//
//  CLAuthorizationStatus+Extensions.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/5.
//

// CLAuthorizationStatus+Extensions.swift
import CoreLocation

extension CLAuthorizationStatus {
    var isAuthorized: Bool {
        self == .authorizedWhenInUse || self == .authorizedAlways
    }
}
