//
//  Threat.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/21/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class Threat {
    var lat: CGFloat, long: CGFloat, type: String, description: String, tid: String
    
    init(snapshot:FIRDataSnapshot) {
        self.tid = snapshot.key
        let val = snapshot.value as! [String:Any]
        self.type = val["type"] as! String
        self.description = val["description"] as! String
        let loc = val["location"] as! [String:String]
        self.lat = NumberFormatter().number(from: loc["lat"]!)  as! CGFloat
        self.long = NumberFormatter().number(from: loc["long"]!) as! CGFloat
    }
    
    func getCoords() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(self.lat), longitude: CLLocationDegrees(self.long))
    }
}
