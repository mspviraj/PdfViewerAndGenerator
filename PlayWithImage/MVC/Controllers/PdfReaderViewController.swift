//
//  PdfReaderViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 24/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit

class PdfReaderViewController: UIViewController {

    //MARK:- variables
    var isInitiated : Bool?
    var documentObj = Document()
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: PDFSinglePageViewer!
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPdf()
      }
    
    //MARK:- loadPdf()
    func loadPdf()
    {
        var fileUrl:URL =  documentObj.getDocumentsDirectory()
        fileUrl.appendPathComponent("\(Pdf.folderName.rawValue)/\(Pdf.fileName.rawValue)")
        let document = try! PDFDocument(filePath: fileUrl, password: OtherUtility.blank.rawValue)
        self.collectionView.document = document
    }
    
    //MARK:- btnActToChangeOrientation
    @IBAction func btnActToChangeOrientation(_ sender: UIButton) {
        let collectionlayout = PDFSinglePageViewer.flowLayout
        collectionView.setLayout(layout: collectionlayout)
    }
    
    //MARK:- btnBack()
    @IBAction func btnBack(_ sender: UIButton)
    {
        PDFSinglePageViewer.isHorizontal = false
        self.dismiss(animated: true, completion: nil)
    }
}
