//
//  LocationManager.swift
//  SwiftUiUber
//
//  Created by Shaik Ahron on 05/02/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        guard !location.isEmpty else { return }
        locationManager.stopUpdatingLocation()
    }
}
