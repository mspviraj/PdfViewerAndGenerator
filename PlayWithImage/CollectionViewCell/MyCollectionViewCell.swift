//
//  MyCollectionViewCell.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import AVFoundation
import PDFGenerator
import Foundation

class MyCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Variables
    let resourcesObj = Resources()
    var imagesArr = [UIImage]()
    var transfromArr = [UIImage]()
    var documentObj = Document()
    var mainVCobj = ViewController()
    var thumbImage  = UIImage()
    // var finalImage = UIImage()
    
    //MARK: - Outlets 
    @IBOutlet weak var imgView: UIImageView!
    
    
    //MARK: - Save Pdf Action
    @IBAction func btnSaveToPdfAct(_ sender: UIButton) {
        imagesArr = resourcesObj.getResources()
        generatePdf()
    }
    
    //MARK: - Generate Pdf
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
        let documentsDirectory = documentObj.getDocumentsDirectory()
        var dataPath = documentsDirectory.appendingPathComponent("\(Pdf.folderName.rawValue)")
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        dataPath.appendPathComponent("\(Pdf.fileName.rawValue)")
        
        do {
            try PDFGenerator.generate(pagesArr, to: dataPath)
            print(Pdf.location.rawValue ,dataPath)
            mainVCobj.showAlert()
            
        } catch (let e) {
            print(e.localizedDescription)
        }
        let image = self.getThumbnailForPDF(String(describing:dataPath), pageNumber: 1)
        thumbImage = image!
        print("Thumbnail Image",image ?? "nil")
    }
    
    
    //MARK: - setImagesInPdfAccordingToTheSize
    func createViewWithImageandLabel(index : Int) -> UIImage
    {
        //****** Choose Your PDF Page Size *******//
        let width:CGFloat = 794
        let height:CGFloat = 1123
        
        //visibleRect
        let visibleRect = AVMakeRect(aspectRatio: CGSize(width: imagesArr[index].size.width, height: imagesArr[index].size.height), insideRect: CGRect(x: 0.0, y: 0.0, width: width, height: height))
        
        //UIView
        let mainView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: visibleRect.size.width, height: visibleRect.size.height + 40.0 ))
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
    
    
    //MARK: - convertViewIntoImage
    func convertViewIntoImage(view:UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 2.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    //MARK: - generateThumbnail
    func getThumbnailForPDF(_ urlString:String, pageNumber:Int) -> UIImage? {
        let url = NSURL(string: urlString)
        guard let getUrl = url else {return nil}
        let fileUrl = getUrl
        let pdf = CGPDFDocument(fileUrl as CFURL)
        let page = pdf?.page(at: pageNumber)!
        
        let rect = CGRect(x: 0, y: 0, width: 300.0, height: 300.0) //Image size here
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setFillColor(gray: 1.0, alpha: 0.0)
        context.fill(rect)
        let pdfTransform = page?.getDrawingTransform(CGPDFBox.mediaBox, rect: rect, rotate: 0, preserveAspectRatio: false)
        context.concatenate(pdfTransform!)
        context.drawPDFPage(page!)
        let thumbImage = UIGraphicsGetImageFromCurrentImageContext()
        context.restoreGState()
        UIGraphicsEndImageContext()
        return thumbImage
    }
    
    
}
