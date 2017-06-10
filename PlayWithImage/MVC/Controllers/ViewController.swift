//
//  ViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController {
    
    //MARK:- Variables
    let resourceObj = Resources()
    var imageArr = [UIImage]()
    var rotationObj = Rotation()
    var documentObj = Document()
    let fileManager = FileManager.default
    let arrDropboxImages = NSMutableArray()
    var finalImage = [UIImage]()
    
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnUploadToDbox: UIButton!
    @IBOutlet weak var btnGetDropboxImages: UIButton!
    
    
    //MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageArr = resourceObj.getResources()
        btnUploadToDbox.isHidden = true
        btnGetDropboxImages.isHidden = true
    }
    
    
    //MARk:- viewDidAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    
    //MARK:- viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
//********************
    
    /// Initializes a document with the name of the pdf in the file system
    fileprivate func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        return PDFDocument(url: documentURL)
    }
    
    fileprivate func showDocument(_ document: PDFDocument) {
        let image = UIImage(named: "")
        let controller = PDFViewController.createNew(with: document, title: "", actionButtonImage: image, actionStyle: .activitySheet)
       present(controller, animated: true, completion: nil)
       // navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- btnOpenPdfAct()
    @IBAction func btnOpenPdfAct(_ sender: UIButton) {
        let smallPDFDocumentName = "sample"
        if let doc = document(smallPDFDocumentName) {
            showDocument(doc)
        } else {
            print("Document named \(smallPDFDocumentName) not found in the file system")
        }
    }
    
 //**********************
    //MARK:- btnAct()
    @IBAction func btnAct(_ sender: UIButton) {
        let cell = collectionView.visibleCells.first as? MyCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell!)
        guard let index = indexPath?.row else{return}
        //print(index)
        UIImageView.animate(withDuration: 1.0,
        animations:({
        //cell?.imgView.transform = (cell?.imgView.transform.rotated(by: CGFloat(Double.pi/2)))!
        //let rotateImage = self.rotationObj.imageRotatedByDegrees(oldImage: self.imageArr[index], degrees: 90.0)
        //self.imageArr[index] = rotateImage
        let image = self.imageArr[index].fixedOrientation().imageRotatedByDegrees(degrees: 90.0)
            self.imageArr[index] = image
            self.collectionView.reloadData()
        }))
    }
    
 
    
    
    //MARK:- showAlert()
     func showAlert()
     {
        Alert.showAlert(Title : Pdf.Title.rawValue ,Des : Pdf.success.rawValue,obj : self)
     }
    
    
    //MARK:- btnGenDrive()
    @IBAction func btnGetDrive(_ sender: UIButton) {
        let googleConfViewController = UIStoryboard(name: OtherUtility.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier:"GoogleConfViewController") as! GoogleConfViewController
        present(googleConfViewController, animated: true, completion: nil)
  
    }
 
    //MARK:- btnUploadToDropBox()
    @IBAction func btnUploadToDropBox(_ sender: UIButton) {
        EZLoadingActivity.show("Please Wait..", disableUI: false)
        uploadFileToDropBox()
        
    }
    
    //MARK:- btnDropbox()
    @IBAction func btnDropbox(_ sender: UIButton) {
    DropboxClientsManager.authorizeFromController(UIApplication.shared,
                                                      controller: self,
                                                      openURL: { (url: URL) -> Void in
                                                        UIApplication.shared.openURL(url)
    if let authResult = DropboxClientsManager.handleRedirectURL(url) {
        switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
                self.btnUploadToDbox.isHidden = false
            self.btnGetDropboxImages.isHidden = false
            case .cancel:
                  print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                  print("Error: \(description)")
            }
        }
        })}

    
    //MARK:- uploadFileToDropBox()
    func uploadFileToDropBox()
    {
       let client =  DropboxClientsManager.authorizedClient
        let documentUrl:URL =  documentObj.getDocumentsDirectory()
        let fileUrl = (documentUrl.appendingPathComponent("\(Pdf.folderName.rawValue)")).appendingPathComponent("\(Pdf.fileName.rawValue)")
        guard let data = try? Data(contentsOf: fileUrl) else {
            print("There was an error!")
            return
        }
        let fileData = data
        client?.files.upload(path: "/CodeBrew/MyPDF.pdf", input: fileData).response { response, error in
            if let metadata = response {
                print("Uploaded file name: \(metadata.name)")
                print("Uploaded file revision: \(metadata.rev)")
                EZLoadingActivity.hide(true, animated: true)
                }
            if (error != nil)
            {
                EZLoadingActivity.hide(false, animated: true)
            }
        }
    }
    
    //MARK:- btnActGetDBoxImages
    @IBAction func btnActGetDBoxImages(_ sender: UIButton)
    {
       getImageFromDropbox()
    }
    }


//        let pdfReaderViewController = UIStoryboard(name: OtherUtility.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: VCIdentifier.PdfReaderViewController.rawValue) as! PdfReaderViewController
//        pdfReaderViewController.finalImage = finalImage
//        pdfReaderViewController.isInitiated = true
//        present(pdfReaderViewController, animated: true, completion: nil)






