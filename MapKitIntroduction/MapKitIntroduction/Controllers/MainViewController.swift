//
//  ViewController.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/24/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {

    private let mainView = MainView()
    private let coreLocationHandler = CoreLocationHandler()
    private var highSchools = [NYCHighSchool](){
        didSet{
            annotations = makeAnnotations()
        }
    }
    private var annotations = [MKPointAnnotation](){
        didSet{
            showAnnotations()
        }
    }
    private var isShowingNewAnnotations = false
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .darkGray
        navigationItem.title = "NYC High Schools"
        setUp()
    }
    
    private func setUp(){
        mainView.mapKitView.delegate = self
        mainView.mapKitView.showsUserLocation = true
        coreLocationHandler.delegate = self
        NYCHighSchoolAPIClient.getHighSchoolData { [weak self] result in
            switch result{
            case .failure(let netError):
                print("Encountered error whilte loading high school data: \(netError)")
            case .success(let schools):
                self?.highSchools = schools
            }
        }
    }
    
    private func makeAnnotations() -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for school in highSchools{
            let annotation = MKPointAnnotation()
            annotation.title = school.schoolName
            if let lat = Double(school.latitude), let long = Double(school.longitude){
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            }
            annotations.append(annotation)
        }
        isShowingNewAnnotations = true
        return annotations
    }
    
    private func showAnnotations(){
        mainView.mapKitView.addAnnotations(annotations)
    }
}

extension MainViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Generic identifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphText = "Secondary School"
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        if isShowingNewAnnotations{
            mainView.mapKitView.showAnnotations(annotations, animated: false)
        }
        isShowingNewAnnotations = false
    }
}

extension MainViewController: CoreLocationHandlerDelegate{
    func locationUseAuthorized(_ coreLocationHandler: CoreLocationHandler, _ status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways, .authorizedWhenInUse:
            let region = MKCoordinateRegion(center: mainView.mapKitView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mainView.mapKitView.setRegion(region, animated: true)
        default:
            break
        }
    }
}
