//
//  SecondViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 23/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    var image: UIImage?
    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func btnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
