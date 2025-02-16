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
        
        // 反向地理編碼
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Reverse geocode failed: \(error.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first {
                self?.onPlacemarkUpdate?(placemark)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
