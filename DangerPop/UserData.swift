//
//  UserData.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/20/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import Foundation
import Firebase

class UserData {
    static var uid:String?
    static var name:String?
    static var address:String = ""
    
    static func upload() {
        if let uid = UserData.uid {
            let ref = FIRDatabase.database().reference(withPath: "/Users/\(uid)")
            if let name = UserData.name {
                let dic = ["name": name, "address": UserData.address]
                ref.setValue(dic)
            }
        }
    }
    
    static func update(with snapshot: FIRDataSnapshot) {
        if let info = snapshot.value as? [String:String] {
            UserData.name = info["name"]
            UserData.address = info["address"] ?? ""
        } else {
            print("Something went wrong with the snapshot")
        }
        
    }
}
