//
//  Colors.swift
//  DangerPop
//
//  Created by Rahil Patel on 10/20/18.
//  Copyright © 2018 DangerPros. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    static let orange = UIColor.init(r: 255, g: 157, b: 45, a: 1)
    static let black = UIColor.init(r: 0, g: 0, b: 0, a: 1)
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}
