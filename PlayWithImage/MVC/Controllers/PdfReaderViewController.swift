//
//  PdfReaderViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 24/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import Foundation

class PdfReaderViewController: UIViewController {
    
//    //MARK:- variables
//    var isInitiated : Bool?
//    var documentObj = Document()
//    var scrollPositionBeforeRotation : CGPoint?
//    var updateSize : CGSize?
//    var currentIndex : Int?
//    var initialUpperViewHeight : CGFloat?
//    var initialBottomViewHeight : CGFloat?
//    var finalImage : [UIImage]?
//    
//    //MARK:- Outlets
//    @IBOutlet weak var collectionView: PDFSinglePageViewer!
//    @IBOutlet weak var upperView: UIView!
//    @IBOutlet weak var borderLayerView: UIView!
//    @IBOutlet weak var bottomView: UIView!
//    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
//    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!
//    
//   //MARK:- viewDidLoad
//    override func viewDidLoad()
//    {
//        guard let imagesArr = finalImage else {return }
//        print("Final",imagesArr)
//        super.viewDidLoad()
//        collectionView.finalImages = imagesArr
//        initialUpperViewHeight = self.upperView.frame.size.height
//        initialBottomViewHeight = self.bottomView.frame.size.height
//        loadPdf()
//    }
//    
//   //MARK:- viewWillLayoutSubviews
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let oriantation = UIDevice.current.orientation
//        if oriantation.isLandscape {
//            setupViewInLandScape()
//            
//        }else if oriantation.isPortrait {
//           setupViewInPortrait()
//        }
//        self.view.layoutIfNeeded()
//    }
//
//    //MARK:- setupViewInLandScape
//    func setupViewInLandScape()
//    {
//        bottomViewHeight.constant = initialBottomViewHeight! - 10.0
//        upperViewHeight.constant = initialUpperViewHeight! - 10.0
//    }
//    
//    //MARK:- setupViewInPortrait
//    func setupViewInPortrait()
//    {
//        bottomViewHeight.constant = initialBottomViewHeight!
//        upperViewHeight.constant = initialBottomViewHeight!
//    }
//    
//    //MARK:- viewWillTransition
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        
//        let offset = collectionView?.contentOffset
//        let width  = collectionView?.bounds.size.width
//        
//        let index     = round(offset!.x / width!)
//        let newOffset = CGPoint(x: index * size.width, y: offset!.y)
//        
//        collectionView?.setContentOffset(newOffset, animated: false)
//        coordinator.animate(alongsideTransition: { (context) in
//            self.collectionView?.reloadData()
//            self.collectionView?.setContentOffset(newOffset, animated: false)
//        }, completion: nil)
//    }
//    
//    //MARK:- loadPdf()
//    func loadPdf()
//    {
//        let documentUrl:URL =  documentObj.getDocumentsDirectory()
//        let fileUrl = (documentUrl.appendingPathComponent("\(Pdf.folderName.rawValue)")).appendingPathComponent("\(Pdf.fileName.rawValue)")
//        let document = try! PDFDocument(filePath: fileUrl, password: OtherUtility.blank.rawValue)
//        self.collectionView.document = document
//    }
//    
//    //MARK:- btnActToChangeOrientation
//    @IBAction func btnActToChangeOrientation(_ sender: UIButton) {
//        let collectionlayout = PDFSinglePageViewer.flowLayout
//        collectionView.setLayout(layout: collectionlayout)
//    }
//    
//    //MARK:- btnBack()
//    @IBAction func btnBack(_ sender: UIButton)
//    {
//        PDFSinglePageViewer.isHorizontal = false
//        AppUtility.lockOrientation(.portrait)
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    //MARK:- viewDidAppear()
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        AppUtility.lockOrientation(.all)
//    }
//    
//    //MARK:- viewWillDisappear()
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        AppUtility.lockOrientation(.portrait)
//    }
//    
    
    
}






