//
//  CoreLocationHandler.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/25/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import Foundation
import CoreLocation

protocol CoreLocationHandlerDelegate: AnyObject{
    func locationChanged(_ coreLocationHandler: CoreLocationHandler, _ locations: [CLLocation])
}

class CoreLocationHandler: NSObject {
    
    public var locationHandler: CLLocationManager
    weak var delegate: CoreLocationHandlerDelegate?
    override init(){
        locationHandler = CLLocationManager()
        super.init()
        locationHandler.delegate = self
        
        locationHandler.requestAlwaysAuthorization()
        locationHandler.requestWhenInUseAuthorization()
        
        startSignificantLocationChanges()
        startMonitoringRegion()
    }
    
    private func startSignificantLocationChanges(){
        if !CLLocationManager.significantLocationChangeMonitoringAvailable(){
            return
        }
        locationHandler.startMonitoringSignificantLocationChanges()
    }
    
    private func startMonitoringRegion(){
        let location = CLLocationCoordinate2D(latitude: 40.782865, longitude: -73.967544)
        let identifier = "Circular Region"
        let region = CLCircularRegion(center: location, radius: 500, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        locationHandler.startMonitoring(for: region)
    }
    
    private func convertCoordinateIntoPlacemark(_ coordinate: CLLocationCoordinate2D, completion: @escaping (Result<CLPlacemark, Error>) -> ()){
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse Geocode Location Error: \(error)")
                completion(.failure(error))
            }
            
            if let firstPlacemark = placemarks?.first {
                print("Placemark is: \(firstPlacemark)")
                completion(.success(firstPlacemark))
            }
        }
    }
    
    private func convertPlacemarkIntoCoordinate(_ placename: String, completion: @escaping (Result<CLLocationCoordinate2D,Error>) -> ()){
        CLGeocoder().geocodeAddressString(placename) { (placemark, error) in
            if let error = error {
                print("Geocode Error: \(error)")
                completion(.failure(error))
            }
            
            if let firstPlacemark = placemark?.first, let location = firstPlacemark.location {
                print("Placename coordinate is: \(location.coordinate)")
                completion(.success(location.coordinate))
            }
        }
    }
}

extension CoreLocationHandler: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationChanged(self, locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationHandler.requestLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
}
