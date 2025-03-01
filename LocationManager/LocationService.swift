//
//  LocationService.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import CoreLocation
import UIKit

class LocationService: NSObject, CLLocationManagerDelegate {
    
    private var locationManager: CLLocationManager
    private let geocoder = CLGeocoder()
    
    // 這裡可用自訂 closure 或 Notification 來回傳更新的地址或緯經度
    var onLocationUpdate: ((CLLocation) -> Void)?
    var onPlacemarkUpdate: ((CLPlacemark) -> Void)?
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    func start() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // 可以透過 closure 或 Notification 傳遞給外部
        onLocationUpdate?(location)
        
        // 埋點：成功取得經緯度
        AnalyticsManager.shared.trackEvent("location_update", parameters: [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ])
        
        // 反向地理編碼
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
                // 可以在失敗時也做事件紀錄
                AnalyticsManager.shared.trackEvent("reverse_geocode_failed", parameters: [
                    "error": error.localizedDescription
                ])
                return
            }
            if let placemark = placemarks?.first {
                self?.onPlacemarkUpdate?(placemark)
                
                AnalyticsManager.shared.trackEvent("reverse_geocode_success", parameters: [
                    "country": placemark.country ?? "unknown",
                    "locality": placemark.locality ?? "unknown",
                    "coordinate": "\(location.coordinate.latitude),\(location.coordinate.longitude)"
                ])
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
