//
//  MainView.swift
//  MapKitIntroduction
//
//  Created by Cameron Rivera on 2/25/20.
//  Copyright © 2020 Cameron Rivera. All rights reserved.
//

import UIKit
import MapKit

class MainView: UIView {
    
    public lazy var mapKitView: MKMapView = {
       let mv = MKMapView()
        return mv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setUpMapKitViewConstraints()
    }
    
    private func setUpMapKitViewConstraints() {
        addSubview(mapKitView)
        mapKitView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([mapKitView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor), mapKitView.leadingAnchor.constraint(equalTo: leadingAnchor), mapKitView.trailingAnchor.constraint(equalTo: trailingAnchor), mapKitView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)])
    }
}
