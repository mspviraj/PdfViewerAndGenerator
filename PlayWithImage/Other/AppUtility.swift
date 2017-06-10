//
//  AppUtility.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 06/06/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit
struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
}
