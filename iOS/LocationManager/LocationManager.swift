//
//  LocationManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    // 使用 @Published 發布用戶位置和授權狀態
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var hasLoggedLocationEvent = false // 控制只發一次事件

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        authorizationStatus = locationManager.authorizationStatus
    }
    
    // 請求使用者授權
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // 開始更新位置
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    // 停止更新位置
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
        
        if !hasLoggedLocationEvent {
            hasLoggedLocationEvent = true
            AnalyticsManager.shared.trackEvent("location_update_first_time", parameters: [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ])
        }
    }
    
    // CLLocationManagerDelegate 方法，當授權狀態改變時被呼叫
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        AnalyticsManager.shared.trackEvent("location_auth_changed", parameters: [
            "new_status": "\(status)"
        ])
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else {
            stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
        AnalyticsManager.shared.trackEvent("location_failed", parameters: [
            "error": error.localizedDescription
        ])
    }
}
