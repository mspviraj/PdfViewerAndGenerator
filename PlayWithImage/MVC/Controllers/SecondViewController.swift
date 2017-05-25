//
//  SecondViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 23/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    //MARK:-  Variables
    var image: UIImage?
    
    //MARK:-  Outlets
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = image
    }

    //MARK:-  btnBack
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
