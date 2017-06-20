//
//  LocationPickerViewController.swift
//  Pods
//
//  Created by Paul Von Schrottky on 6/18/17.
//
//

import UIKit
import MapKit

class LocationPickerViewController: UIViewController {
    
    var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapView]|", options: [], metrics: nil, views: ["mapView": mapView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapView]|", options: [], metrics: nil, views: ["mapView": mapView]))
    }
}
