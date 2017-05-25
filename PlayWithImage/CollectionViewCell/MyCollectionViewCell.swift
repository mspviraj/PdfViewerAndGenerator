//
//  MyCollectionViewCell.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import PDFGenerator
import AVFoundation

class MyCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Variables
    let resourcesObj = Resources()
    var imagesArr = [UIImage]()
    var transfromArr = [UIImage]()
    var documentObj = Document()
    var mainVCobj = ViewController()
    
    
    //MARK:- Outlets
    @IBOutlet weak var imgView: UIImageView!
    
    
    //MARK:- btnSaveToPdfAct()
    @IBAction func btnSaveToPdfAct(_ sender: UIButton) {
       
     imagesArr = resourcesObj.getResources()
      generatePdf()
    }
    
    
    //MARK:- generatePdf()
    func generatePdf()
    {
        var pagesArr = [PDFPage]()
        var index = 0
        while index < self.imagesArr.count
        {
            
         let page = PDFPage.image(self.createViewWithImageandLabel(index:index))
        pagesArr.append(page)
          
             index = index + 1
        }
        let documentDirectory = documentObj.getDocumentsDirectory()
        var newDir = documentDirectory.appendingPathComponent(Pdf.folderName.rawValue).path
        newDir.append("/\(Pdf.fileName.rawValue)")
        
        do {
            try PDFGenerator.generate(pagesArr, to: newDir)
            print(Pdf.location.rawValue ,newDir)
            mainVCobj.showAlert()
            
        } catch (let e) {
            print(e.localizedDescription)
       }
    }
    
   //MARK:- setImagesInPdfAccordingToTheSize
    func createViewWithImageandLabel(index : Int) ->UIImage
    {
        let visibleRect = AVMakeRect(aspectRatio: CGSize(width: imagesArr[index].size.width, height: imagesArr[index].size.height), insideRect: UIScreen.main.bounds)
        
        //UIView
        let mainView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: visibleRect.size.width, height: visibleRect.size.height + 40.0 ))
        //let mainView = UIView(frame:UIScreen.main.bounds)
        mainView.backgroundColor = .red
        

        //UIImageView
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: visibleRect.size.width, height: visibleRect.size.height))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.imagesArr[index]
        
        
        //First UIImageView
        let firstChildImageView = UIImageView(frame:CGRect(x: 0.0, y: imageView.frame.size.height - 80.0, width: 80.0, height: 80.0))
        firstChildImageView.image = self.imagesArr[index]
        
        
        //Second UIImageView
        let secondChildImageView = UIImageView(frame:CGRect(x: firstChildImageView.frame.size.width , y: imageView.frame.size.height - 80.0, width: 80.0, height: 80.0))
        secondChildImageView.image = self.imagesArr[index]
        
        
        
        //UILabel
        let label = UILabel(frame: CGRect(x: 0.0, y: imageView.frame.size.height, width: visibleRect.size.width, height: 40))
        //let label = UILabel(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 40.0,width:UIScreen.main.bounds.size.width, height: 40))
        
        label.textAlignment = .center
        label.text = String("img \(index) .png")
        label.backgroundColor = UIColor.orange
        
        mainView.addSubview(imageView)
        mainView.addSubview(label)
        mainView.addSubview(firstChildImageView)
        mainView.addSubview(secondChildImageView)
        
        //convert into image
        let convertedImage = convertViewIntoImage(view:mainView)
        return convertedImage
    }
    
    
    //MARK:- convertViewIntoImage
    func convertViewIntoImage(view:UIView) -> UIImage
    {
       UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 2.0)
       view.layer.render(in: UIGraphicsGetCurrentContext()!)
       let image = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()
       return image!
    }
}
