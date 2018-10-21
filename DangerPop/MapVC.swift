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
            //mapView.camera = GMSCameraPosition(target: mapView.myLocation!.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        }
        layoutUI(viewSize: viewSize)
        
        //removes a default gesture recognizer blocker from the mapview so that other ui elements can be interacted with
        for gesture in mapView.gestureRecognizers! {
            mapView.removeGestureRecognizer(gesture)
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CLLocationManager.locationServicesEnabled() {
            // 4
            locMan.startUpdatingLocation()
            //5
            
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            view = mapView
        }
        
    }
    
    private func layoutUI(viewSize: CGSize) {
        let size = viewSize
        self.revealViewController()?.rearViewRevealWidth = 280
        slideMenu.setImage(UIImage(named: "SlideMenuIcon"), for: .normal)
        slideMenu.frame = CGRect(x: 10, y: 40, width: size.width / 12, height: size.width / 12)
        slideMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addSubview(slideMenu)
    }
}

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        return true
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locMan.startUpdatingLocation()
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            mapView.animate(to:GMSCameraPosition(target: locValue, zoom: 15, bearing: 0, viewingAngle: 0))
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("\n\n\nUPDATING LOCATION\n\n\n")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        mapView.animate(to:GMSCameraPosition(target: locValue, zoom: 15, bearing: 0, viewingAngle: 0))
    }
}
