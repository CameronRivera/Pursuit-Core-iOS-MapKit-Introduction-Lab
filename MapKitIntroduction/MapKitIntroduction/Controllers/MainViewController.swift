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
        coreLocationHandler.delegate = self
        mainView.mapKitView.showsUserLocation = true
        
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
        DispatchQueue.main.async{
            self.mainView.mapKitView.showAnnotations(self.annotations, animated: false)
        }
    }
}

extension MainViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
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
    
    func locationChanged(_ coreLocationHandler: CoreLocationHandler, _ locations: [CLLocation]) {
        if let newLoc = locations.last {
            let region = MKCoordinateRegion(center: newLoc.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
            mainView.mapKitView.setRegion(region, animated: true)
        }
    }
    
}
