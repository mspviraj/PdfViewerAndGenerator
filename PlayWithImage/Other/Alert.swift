//
//  Alert.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 25/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit
class Alert{
    
//MARK:- showAlert
class func showAlert(Title : String , Des : String , obj : UIViewController)
{
    let alert = UIAlertController(title:Title, message:Des ,preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: nil))
    alert.view.tintColor = UIColor.brown  // change text color of the buttons
    obj.present(alert, animated: true, completion: nil)

}
}
