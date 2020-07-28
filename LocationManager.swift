//
//  LocationManager.swift
//
//  Created by Василий Савчук on 07/03/2019.
//  Copyright © 2019
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {

    private let manager = CLLocationManager()
    private let gpsManager: GpsManager
    private var geoType = GeolocationType.regular.rawValue
    private var coordinates: CLLocationCoordinate2D?
    private var coordinatesRecieved: ((CLLocationCoordinate2D?, Error?) -> Void)?

    init(gpsManager: GpsManager = GpsManager(), geoType: GeolocationType) {
        self.gpsManager = gpsManager
        self.geoType = geoType.rawValue
        super.init()
        manager.requestAlwaysAuthorization()
    }

    private func configLocationManager() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = false
        manager.startUpdatingLocation()
        manager.startMonitoringSignificantLocationChanges()
    }

    func getCurrentLocation(handler: @escaping ((CLLocationCoordinate2D?, Error?) -> Void)) {
        coordinatesRecieved = handler
        if CLLocationManager.locationServicesEnabled() {
            configLocationManager()
        } else {
            coordinatesRecieved?(nil, CLError(.locationUnknown))
        }
    }

    private func stopMonitoringLocationChanges() {
        let timeForStopMonitoringLocation = Calendar.current.component(.hour, from: Date())
        if timeForStopMonitoringLocation >= 18 {
            manager.stopMonitoringSignificantLocationChanges()
        }
    }

    func havePermissions() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            @unknown default:
                fatalError("\(#function) ==> Unknown CLLocationManager.authorizationStatus")
            }
        } else {
            return false
        }
    }

    private func sendGpsDataToTracker(with currentCoordinates: CLLocationCoordinate2D, geoType: String) {
        guard let isGeolocationPermissionEnabled = isGeolocationPermissionEnabled() else { return }
        if isGeolocationPermissionEnabled {
            gpsManager.sendGps(with: currentCoordinates, geoType: geoType)
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentCoordinates = manager.location?.coordinate else { return }
        coordinatesRecieved?(currentCoordinates, nil)
        coordinatesRecieved = nil
        manager.stopUpdatingLocation()
        stopMonitoringLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesRecieved?(nil, error)
        coordinatesRecieved = nil
        manager.stopUpdatingLocation()
        manager.stopMonitoringSignificantLocationChanges()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        status == CLAuthorizationStatus.authorizedAlways ? setAuthorizedAlways(true) : setAuthorizedAlways(false)
    }
}
