//
//  MapVC.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/20/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import CoreLocation

class MapVC: UIViewController {
    let mapView = GMSMapView()
    let locMan = CLLocationManager()
    let slideMenu = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewSize = view.frame.size
        mapView.delegate = self
        locMan.delegate = self
        locMan.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locMan.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            view = mapView
        }
        layoutUI(viewSize: viewSize)
        
    }
    
    private func layoutUI(viewSize: CGSize) {
        let size = viewSize
        print("\n\n\n + \(size) + \n\n\n")
        slideMenu.setImage(UIImage(named: "SlideMenuIcon"), for: .normal)
        slideMenu.frame = CGRect(x: 10, y: 40, width: size.width / 12, height: size.width / 12)
        view.addSubview(slideMenu)
    }
}

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
}

extension MapVC: CLLocationManagerDelegate {
    private func locationManager1(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locMan.startUpdatingLocation()
            
        }
    }
}
