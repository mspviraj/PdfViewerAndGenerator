//
//  ViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Variables
    let resourceObj = Resources()
    var imageArr = [UIImage]()
    
    //MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArr = resourceObj.getResources()
       
     }
    
    @IBAction func btnAct(_ sender: UIButton) {
        let cell = collectionView.visibleCells.first as? MyCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell!)
        guard let i = indexPath?.row else
        {
            return
        }
        let index = i
        UIImageView.animate(withDuration: 1.0,
                       animations:({
                        cell?.imgView.transform = (cell?.imgView.transform.rotated(by: CGFloat(M_PI_2)))!
                        let rotateImage = self.imageRotatedByDegrees(oldImage: self.imageArr[index], degrees: 90.0)
                        self.imageArr[index] = rotateImage
    }))
    }
    
      
    func imageRotatedByDegrees(oldImage: UIImage, degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    @IBAction func btnOpenPdfAct(_ sender: UIButton) {
        var file:URL =  self.getDocumentsDirectory()
        file.appendPathComponent("sample1.pdf")
        //let path = Bundle.main.path(forResource: "sample", ofType: "pdf")!
        //let url = URL(fileURLWithPath: file)
        print("file URL",file)
        let pdfViewController = UIStoryboard(name: "Pdf", bundle: nil).instantiateInitialViewController() as! PdfViewController
        pdfViewController.url = file
        present(pdfViewController, animated: true, completion: nil)
   
    }
      func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}

