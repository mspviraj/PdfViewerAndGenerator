//
//  MyCollectionViewCell.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import PDFGenerator

class MyCollectionViewCell: UICollectionViewCell {
    
    //MARK: Variables
    let resourcesObj = Resources()
    var imagesArr = [UIImage]()
    var transfromArr = [UIImage]()
    
    
    //MARK: Outlets
    @IBOutlet weak var imgView: UIImageView!
    
    //MARK: btnSaveToPdfAct()
    @IBAction func btnSaveToPdfAct(_ sender: UIButton) {
       
       imagesArr = resourcesObj.getResources()
       generatePdf()
    }
    
    //MARK: generatePdf()
    func generatePdf()
    {
        var pagesArr = [PDFPage]()
        for index in 0..<self.imagesArr.count
        {
        let page = PDFPage.view(createViewWithImageandLabel(index:index))
        pagesArr.append(page)
        }
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var documentsDirectory = paths[0]
        documentsDirectory.appendPathComponent("sample1.pdf")
        do {
            try PDFGenerator.generate(pagesArr, to: documentsDirectory)
            print("location: \(documentsDirectory)")
            print("PDF Generate Successfully !!!")
            
        } catch (let e) {
            print(e.localizedDescription)
        }
    }
    
   //MARK: createViewWithImageandLabel
    func createViewWithImageandLabel(index : Int) -> UIView
    {
        let mainView = UIView(frame: CGRect(x: 0.0,y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        mainView.backgroundColor = .white
        
        //UIImageView
        let imageView = UIImageView(frame: CGRect(x: 0.0,y: 0.0, width: 300.0,height: 300.0))
        imageView.center = mainView.center
        imageView.contentMode = .scaleAspectFit
        imageView.image = self.imagesArr[index]
        
        //UILabel
        let label = UILabel(frame: CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 40, width: UIScreen.main.bounds.size.width, height: 40))
        label.textAlignment = .center
        label.text = String("img \(index) .png")
        label.backgroundColor = UIColor.orange
        
        //addToSubView
        mainView.addSubview(imageView)
        mainView.addSubview(label)
        return mainView
    }
    
   
  
}

//func generatePdf()
//{
//    var pagesArr = [PDFPage]()
//    for index in 0..<self.imagesArr.count
//    {
//        let page = PDFPage.view(createViewWithImageandLabel(index:index))
//        pagesArr.append(page)
//    }
//    let dst = NSTemporaryDirectory().appending("sample1.pdf")
//    do {
//        try PDFGenerator.generate(pagesArr, to: dst)
//        print("location: \(dst)")
//        print("PDF Generate Successfully !!!")
//        
//    } catch (let e) {
//        print(e.localizedDescription)
//    }
//}

//MARK:- setImagesInPdfAccordingToTheSize

//
//func createViewWithImageandLabel(index : Int) -> UIView
//{
//    UIView
//    let mainView = UIView(frame: CGRect(x: 0.0,y: 0.0, width: imagesArr[index].size.width, height: imagesArr[index].size.height + 40 ))
//    mainView.backgroundColor = .white
//    
//    UIImageView
//    let imageView = UIImageView(frame: CGRect(x: 0.0,y: 0.0, width: imagesArr[index].size.width, height:imagesArr[index].size.height))
//    imageView.contentMode = .scaleAspectFit
//    imageView.image = self.imagesArr[index]
//    
//    UILabel
//    let label = UILabel(frame: CGRect(x: 0.0, y: imageView.frame.size.height, width: imagesArr[index].size.width, height: 40))
//    label.textAlignment = .center
//    label.text = String("img \(index) .png")
//    label.backgroundColor = UIColor.orange

//    mainView.addSubview(imageView)
//    mainView.addSubview(label)
//    return mainView
//}





//MARK :- to store the single Image in PDF

//func saveToPdf(img: UIImageView)
//{
//    let pdfData = NSMutableData()
//    UIGraphicsBeginPDFContextToData(pdfData, imgView.bounds, nil)
//    UIGraphicsBeginPDFPage()
//    
//    let pdfContext = UIGraphicsGetCurrentContext()
//    
//    if (pdfContext == nil)
//    {
//        return
//    }
//    imgView
//        .layer.render(in: pdfContext!)
//    UIGraphicsEndPDFContext()
//    
//    if let documentDirectories: AnyObject = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as AnyObject?
//    {
//        let documentsFileName = (documentDirectories as! String)  + ("/myPDFImage.pdf")
//        debugPrint(documentsFileName, terminator: "")
//        pdfData.write(toFile: documentsFileName, atomically: true)
//    }
//}
