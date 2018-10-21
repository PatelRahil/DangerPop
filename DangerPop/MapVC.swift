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
import Firebase
import Speech

class MapVC: UIViewController, SFSpeechRecognizerDelegate {
    let mapView = GMSMapView()
    let locMan = CLLocationManager()
    let slideMenu = UIButton()
    let reportBtn = UIButton()
    let textLbl = UILabel()
    let micBtn = UIButton()
    let fieldView = UIView()
    let nearbyThreatsBtn = UIButton()
    
    var currentCoords = CLLocationCoordinate2D()
    
    // speech recognition
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewSize = view.frame.size
        mapView.delegate = self
        locMan.delegate = self
        speechRecognizer!.delegate = self
        
        //location authorization
        locMan.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locMan.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            view = mapView
        }
        
        layoutUI(viewSize: viewSize)
        
        //removes a default gesture recognizer blocker from the mapview so that other ui elements can be interacted with
        for gesture in mapView.gestureRecognizers! {
            mapView.removeGestureRecognizer(gesture)
        }
        
        // speech recognitation authorication
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            self.micBtn.isEnabled = false
            switch authStatus {
            case .authorized:
                self.micBtn.isEnabled = true
                
            case .denied:
                self.micBtn.isEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                self.micBtn.isEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                self.micBtn.isEnabled = false
                print("Speech recognition not yet authorized")
            }

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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextVC = segue.destination as? ReportVC {
            nextVC.coords = currentCoords
        }
    }
    
    private func layoutUI(viewSize: CGSize) {
        let size = viewSize
        self.revealViewController()?.rearViewRevealWidth = 280
        slideMenu.setImage(UIImage(named: "SlideMenuIcon"), for: .normal)
        slideMenu.frame = CGRect(x: 10, y: 40, width: size.width / 12, height: size.width / 12)
        slideMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        var offset:CGFloat = 40
        let height:CGFloat = 40
        let width:CGFloat = 120
        reportBtn.frame = CGRect(x: offset/3, y: viewSize.height - height - offset, width: width, height: height)
        reportBtn.backgroundColor = Colors.burntRed
        reportBtn.setTitle("Report", for: .normal)
        reportBtn.layer.cornerRadius = 5
        reportBtn.addTarget(self, action: #selector(reportThreat), for: .touchUpInside)
        
        offset = 20
        nearbyThreatsBtn.frame = CGRect(x: reportBtn.frame.minX, y: reportBtn.frame.minY - reportBtn.frame.height - offset, width: reportBtn.frame.width, height: reportBtn.frame.height)
        nearbyThreatsBtn.backgroundColor = Colors.orange
        nearbyThreatsBtn.setTitle("Check nearby", for: .normal)
        nearbyThreatsBtn.layer.cornerRadius = 5
        nearbyThreatsBtn.addTarget(self, action: #selector(checkThreats), for: .touchUpInside)
        
        micBtn.frame = CGRect(x: slideMenu.frame.minX + slideMenu.frame.width / 6, y: slideMenu.frame.maxY + 30, width: 2 * slideMenu.frame.width / 3, height: slideMenu.frame.height)
        micBtn.setImage(UIImage(named: "mic"), for: .normal)
        micBtn.addTarget(self, action: #selector(listen), for: .touchUpInside)
        print(viewSize)
        let xPos = CGFloat(micBtn.frame.maxX) + 10
        //let xPos = viewSize.width - 20
        textLbl.frame = CGRect(x: xPos, y: micBtn.frame.minY, width: viewSize.width - xPos  - 20, height: micBtn.frame.height)
        textLbl.backgroundColor = UIColor.clear
        
        /*
        fieldView.frame = CGRect(x: micBtn.frame.minX, y: micBtn.frame.minY, width: micBtn.frame.width, height: micBtn.frame.height)
        fieldView.backgroundColor = UIColor.clear
        //fieldView.layer.anchorPoint = CGPoint(x: micBtn.frame.midX, y: fieldView.frame.midY)
        fieldView.setAnchorPoint(CGPoint(x: micBtn.frame.midX, y: fieldView.frame.midY))
        fieldView.layer.borderWidth = 2
        fieldView.layer.borderColor = UIColor.red.cgColor
        fieldView.layer.cornerRadius = fieldView.frame.height / 8
    */
 
        view.addSubview(slideMenu)
        view.addSubview(reportBtn)
        //view.addSubview(fieldView)
        view.addSubview(micBtn)
        view.addSubview(textLbl)
        view.addSubview(nearbyThreatsBtn)
    }
    
    @objc private func reportThreat() {
        print("Current location is: \(currentCoords)")
        performSegue(withIdentifier: "ReportSegue", sender: nil)
    }
    
    @objc private func checkThreats() {
        mapView.clear()
        getNearbyThreats(location: currentCoords)
    }
    
    @objc func listen() {
        /*
        print("LISTENING")
        //animate fieldView to extend horizontally
        if fieldView.frame.width > micBtn.frame.width {
            print("TRANSFORM: SHRINK")
            UIView.animate(withDuration: 0.5) {
                self.fieldView.transform = CGAffineTransform.identity
            }
        } else {
            print("TRANSFORM: GROW")
            UIView.animate(withDuration: 0.5) {
                let xScale = (self.view.frame.width - 2 * self.slideMenu.frame.minX) / self.micBtn.frame.width
                print(xScale)
                self.fieldView.transform = CGAffineTransform(scaleX: xScale, y: 1)
                self.fieldView.transform = CGAffineTransform(
                self.fieldView.backgroundColor = UIColor.white
                print(self.fieldView.frame)
            }
        }
        
 
        var xScale = (self.view.frame.width - 2 * self.slideMenu.frame.minX) / self.micBtn.frame.width
        print(xScale)
        print(self.fieldView.frame)
        //xScale = log2(xScale) / log2(10)
        self.fieldView.transform = CGAffineTransform.identity.scaledBy(x: xScale, y: 1)
        print(self.fieldView.frame)
         */
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            micBtn.isEnabled = false
            textLbl.text = ""
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            //try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textLbl.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.micBtn.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textLbl.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            micBtn.isEnabled = true
        } else {
            micBtn.isEnabled = false
        }
    }
    
    func getNearbyThreats(location:CLLocationCoordinate2D) {
        let threatBlock = "\(Int(location.latitude)),\(Int(location.longitude))"
        var ref = FIRDatabase.database().reference(withPath: "/Threats/\(threatBlock)")
        let data = ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let tids = (snapshot.value as AnyObject).allKeys
            for tid in tids! {
                ref = FIRDatabase.database().reference(withPath: "/Threats/\(threatBlock)/\(tid)")
                ref.observeSingleEvent(of: .value, with: { (snap) in
                    print("\n\n\n\(snap)\n\n\n\(Threat(snapshot: snap))")
                    let threat = Threat(snapshot: snap)
                    self.placePin(for: threat)
                }, withCancel: { (error) in
                    print(error)
                })
            }
        }) { (error) in
            print("Error:\n\(error)")
        }
    }
    
    func placePin(for threat: Threat) {
        let marker = GMSMarker(position: threat.getCoords())
        print(threat.getCoords())
        marker.userData = threat.tid
        marker.title = threat.type
        marker.snippet = threat.description
        marker.map = mapView
        marker.appearAnimation = kGMSMarkerAnimationPop
        print(marker.position)
        
        switch threat.type {
        case "Crime":
            marker.icon = GMSMarker.markerImage(with: .blue)
            return
        case "Accident":
            marker.icon = GMSMarker.markerImage(with: .green)
            return
        case "Natural Cause":
            marker.icon = GMSMarker.markerImage(with: .red)
        default:
            marker.icon = GMSMarker.markerImage(with: .red)
        }
        
    }
}

extension MapVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
            locMan.startUpdatingLocation()
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            mapView.animate(to:GMSCameraPosition(target: locValue, zoom: 15, bearing: 0, viewingAngle: 0))
            currentCoords = locValue
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        if Int(locValue.latitude * 100) != Int(currentCoords.latitude * 100) || Int(locValue.longitude * 100) != Int(currentCoords.longitude * 100) {
            mapView.animate(to:GMSCameraPosition(target: locValue, zoom: 15, bearing: 0, viewingAngle: 0))
        }
        currentCoords = locValue
    }
}

extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
