//  PDFViewController.swift
//  PDFReader
//
//  Created by ALUA KINZHEBAYEVA on 4/19/15.
//  Copyright (c) 2015 AK. All rights reserved.
//

import UIKit
import  Foundation
import AVFoundation

extension PDFViewController {
    /// Initializes a new `PDFViewController`
    ///
    /// - parameter document:            PDF document to be displayed
    /// - parameter title:               title that displays on the navigation bar on the PDFViewController;
    ///                                  if nil, uses document's filename
    /// - parameter actionButtonImage:   image of the action button; if nil, uses the default action system item image
    /// - parameter actionStyle:         sytle of the action button
    /// - parameter backButton:          button to override the default controller back button
    /// - parameter isThumbnailsEnabled: whether or not the thumbnails bar should be enabled
    /// - parameter startPageIndex:      page index to start on load, defaults to 0; if out of bounds, set to 0
    ///
    /// - returns: a `PDFViewController`
    
    public class func createNew(with document: PDFDocument, title: String? = nil, actionButtonImage: UIImage? = nil, actionStyle: ActionStyle = .print, backButton: UIBarButtonItem? = nil, isThumbnailsEnabled: Bool = true, startPageIndex: Int = 0) -> PDFViewController {
        let storyboard = UIStoryboard(name: "PDFReader", bundle: Bundle(for: PDFViewController.self))
        let controller = storyboard.instantiateInitialViewController() as! PDFViewController
        controller.document = document
        
        if let title = title {
            controller.title = title
        } else {
            controller.title = document.fileName
        }
        
        if startPageIndex >= 0 && startPageIndex < document.pageCount {
            controller.currentPageIndex = startPageIndex
        } else {
            controller.currentPageIndex = 0
        }
        
        controller.backButton = backButton
        
        if let actionButtonImage = actionButtonImage {
            controller.actionButton = UIBarButtonItem(image: actionButtonImage, style: .plain, target: controller, action: #selector(actionButtonPressed))
        } else {
            controller.actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: controller, action: #selector(actionButtonPressed))
        }
        controller.isThumbnailsEnabled = isThumbnailsEnabled
        return controller
    }
}

/// Controller that is able to interact and navigate through pages of a `PDFDocument`
public final class PDFViewController: UIViewController {
    /// Action button style
    var bottomView = UIView()
    var isHorizontal : Bool?
    
    public enum ActionStyle {
        /// Brings up a print modal allowing user to print current PDF
        case print
        
        /// Brings up an activity sheet to share or open PDF in another app
        case activitySheet
        
        /// Performs a custom action
        case customAction((Void) -> ())
    }
    
    //MARK:- Designed Outlet
    /// Designed Outlet
    
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var upperViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lowerView: UIView!
    
    
    /// Collection veiw where all the pdf pages are rendered
    @IBOutlet public var collectionView: UICollectionView!
    
    /// Height of the thumbnail bar (used to hide/show)
    @IBOutlet fileprivate var thumbnailCollectionControllerHeight: NSLayoutConstraint!
    
    /// Distance between the bottom thumbnail bar with bottom of page (used to hide/show)
    @IBOutlet fileprivate var thumbnailCollectionControllerBottom: NSLayoutConstraint!
    
    /// Width of the thumbnail bar (used to resize on rotation events)
    @IBOutlet private var thumbnailCollectionControllerWidth: NSLayoutConstraint!
    
    /// PDF document that should be displayed
    fileprivate var document: PDFDocument!
    
    fileprivate var actionStyle = ActionStyle.print
    
    /// Image used to override the default action button image
    fileprivate var actionButtonImage: UIImage?
    
    /// Current page being displayed
    fileprivate var currentPageIndex: Int = 0
    
    /// Bottom thumbnail controller
    // fileprivate var thumbnailCollectionController: PDFThumbnailCollectionViewController?
    
    /// UIBarButtonItem used to override the default action button
    fileprivate var actionButton: UIBarButtonItem?
    
    /// Backbutton used to override the default back button
    fileprivate var backButton: UIBarButtonItem?
    
    /// Background color to apply to the collectionView.
    public var backgroundColor: UIColor? = UIColor.lightGray{
        didSet {
            collectionView?.backgroundColor = backgroundColor
        }
    }
    
    /// Whether or not the thumbnails bar should be enabled
    fileprivate var isThumbnailsEnabled = true {
        didSet {
            if thumbnailCollectionControllerHeight == nil {
                _ = view
            }
            if !isThumbnailsEnabled {
                thumbnailCollectionControllerHeight.constant = 0
            }
        }
    }
    
    //    /// Slides horizontally (from left to right, default) or vertically (from top to bottom)
    public var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet {
            if collectionView == nil {  // if the user of the controller is trying to change the scrollDiecton before it
                _ = view                                  // is on the sceen, we need to show it ofscreen to access it's collectionView.
            }
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = scrollDirection
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                collectionView.isPagingEnabled = true
            }
        }
    }
    
    //MARK: -  calculatedHeightAndGetPdfImages()
    //Calculate Visible Height and Convert PDF Page into Images
    
    public func calculatedHeightAndGetPdfImages() -> (pdfImagesArr:[UIImage],visibleHeightArr:[CGFloat])
    {
        var visibleHeightArray = [CGFloat]()
        var pdfImagesArr = [UIImage]()
        for pageNumber in 0 ..< document.pageCount
        {
            guard let height = document.coreDocument.page(at: pageNumber + 1)?.originalPageRect.size.height else
            {return (pdfImagesArr:[UIImage()],visibleHeightArr:[CGFloat()])}
            guard let width = document.coreDocument.page(at: pageNumber + 1)?.originalPageRect.size.width else
            {return (pdfImagesArr:[UIImage()],visibleHeightArr:[CGFloat()])}
            
            let visibleRect = AVMakeRect(aspectRatio: CGSize(width: width, height: height), insideRect: UIScreen.main.bounds)
            visibleHeightArray.append(visibleRect.size.height)
            pdfImagesArr.append(convertPDFPageToImage(pageNumber: pageNumber,visibleHeight: visibleRect.height)!)
            
            //pdfImagesArr.append(convertPDFPageToImage(page: pageNumber,visibleHeight: visibleRect.height))
        }
        return (pdfImagesArr:pdfImagesArr,visibleHeightArr:visibleHeightArray)
    }
    
    var initialUpperViewHeight : CGFloat?
    var initialBottomViewHeight : CGFloat?
    var pdfImagesArray : [UIImage]?
    var visibleHeightArray : [CGFloat]?
    
    //MARK: - viewDidLoad()
    override public func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = backgroundColor
        collectionView.isPagingEnabled = true
        isHorizontal = true
        collectionView.register(PDFPageCollectionViewCell.self, forCellWithReuseIdentifier: "page")
        initialUpperViewHeight = self.upperView.frame.size.height
        initialBottomViewHeight = self.lowerView.frame.size.height
        let formedData = calculatedHeightAndGetPdfImages()
        pdfImagesArray = formedData.pdfImagesArr
        visibleHeightArray = formedData.visibleHeightArr
        navigationItem.rightBarButtonItem = actionButton
        if let backItem = backButton {
            navigationItem.leftBarButtonItem = backItem
        }
    }
    
    //MARK: - ResizeImage (According to the Size)
    func resizeImage(image:UIImage?,visibleHeight:CGFloat?) -> UIImage
    {
        guard let image = image else {return UIImage()}
        
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = Float(visibleHeight ?? 0.0)                    //your choose height
        let maxWidth:Float = Float(UIScreen.main.bounds.width)                //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect:CGRect = CGRect(x:0.0,y:0.0, width:CGFloat(actualWidth) ,height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        guard let img:UIImage = UIGraphicsGetImageFromCurrentImageContext() else {return UIImage()}
        guard let imageData:NSData = UIImageJPEGRepresentation(img, 1.0) as NSData? else {return UIImage()}
        UIGraphicsEndImageContext()
        guard let resizedImage = UIImage(data: imageData as Data) else {return UIImage()}
        return resizedImage
    }
    
    //MARK: - convertPDFPageToImage
    func convertPDFPageToImage(pageNumber:Int,visibleHeight:CGFloat) -> UIImage? {
        guard let pageRef = document.coreDocument.page(at: pageNumber + 1) else { fatalError() }
        let pdfPage = pageRef
        var pdfImage = UIImage()
        var pageRect = pdfPage.getBoxRect(.mediaBox)
        pageRect.size = CGSize(width: UIScreen.main.bounds.width, height: visibleHeight)
        var imageData: Data?
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(size: pageRect.size)
            imageData = renderer.jpegData(withCompressionQuality: 1.0, actions: { cnv in
                UIColor.white.set()
                cnv.cgContext.saveGState()
                cnv.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
                cnv.cgContext.scaleBy(x: 1.0, y: -1.0);
                cnv.cgContext.concatenate(pdfPage.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
                cnv.cgContext.drawPDFPage(pdfPage)
                cnv.cgContext.restoreGState()
            })
        }
        else {
            // Fallback on earlier versions
        }
        if let imageData = imageData{
       // guard let img2 = UIImage(data:imageData) else {return nil}
        pdfImage = resizeImage(image:UIImage(data: imageData) ?? nil,visibleHeight:visibleHeight)
        }
      return pdfImage
    }
    
    //MARK: - Back Button Action
    @IBAction func btnBack(_ sender: UIButton)
    {
        AppUtility.lockOrientation(.portrait)
        isHorizontal = true
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Change Orientation from Continuous to  LandScape
    @IBAction func changeOrientation(_ sender: UIButton)
    {
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        collectionView.reloadData()
    }
    
    //MARK: - viewWillAppear
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
        
    }
    
    //MARK: - viewWillDisappear
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.portrait)
        
    }
    
    //MARK: - changeCollectionFlow Layout (OWN)
    public  var flowLayout: UICollectionViewFlowLayout {
        
        var flowLayout = UICollectionViewFlowLayout()
        
        if let layout = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout){
            if isHorizontal == true
            {
                layout.scrollDirection = .vertical
                isHorizontal = false
                collectionView.isPagingEnabled = false
            }
            else{
                layout.scrollDirection = .horizontal
                isHorizontal = true
                collectionView.isPagingEnabled = true
            }
            layout.sectionInset = UIEdgeInsets.zero
            layout.minimumLineSpacing = 0.0
            layout.minimumInteritemSpacing = 0.0
            flowLayout = layout
        }
        return flowLayout
    }
    
    //MARK: - viewDidLayoutSubviews()
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let oriantation = UIDevice.current.orientation
        if oriantation.isLandscape {
            setupViewInLandScape()
            
        }else if oriantation.isPortrait {
            setupViewInPortrait()
        }
        self.view.layoutIfNeeded()
    }
    
    //MARK:- setupViewInLandScape
    func setupViewInLandScape()
    {
        bottomViewHeight.constant = initialBottomViewHeight! - 10.0
        upperViewHeight.constant = initialUpperViewHeight! - 10.0
    }
    
    //MARK: - setupViewInPortrait
    func setupViewInPortrait()
    {
        bottomViewHeight.constant = initialBottomViewHeight!
        upperViewHeight.constant = initialBottomViewHeight!
    }
    
    //MARK: - prefersStatusBarHidden
    override public var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden == true
    }
    
    //MARK: - preferredStatusBarUpdateAnimation
    override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    //MARK: - shouldPerformSegue
    public override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return isThumbnailsEnabled
    }
    
    //MARK: - viewWillTransition
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        let offset = collectionView?.contentOffset
        let width  = collectionView?.bounds.size.width
        
        let index     = round(offset!.x / width!)
        let newOffset = CGPoint(x: index * size.width, y: offset!.y)
        coordinator.animate(alongsideTransition: { context in
            self.collectionView?.reloadData()
            self.collectionView?.setContentOffset(newOffset, animated: false)
        }) { context in
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    
    /// Takes an appropriate action based on the current action style
    func actionButtonPressed() {
        switch actionStyle {
        case .print:
            print()
        case .activitySheet:
            presentActivitySheet()
        case .customAction(let customAction):
            customAction()
        }
    }
    
    /// Presents activity sheet to share or open PDF in another app
    private func presentActivitySheet() {
        let controller = UIActivityViewController(activityItems: [document.fileData], applicationActivities: nil)
        controller.popoverPresentationController?.barButtonItem = actionButton
        present(controller, animated: true, completion: nil)
    }
    
    // Presents print sheet to print PDF
    private func print() {
        guard UIPrintInteractionController.isPrintingAvailable else { return }
        guard UIPrintInteractionController.canPrint(document.fileData) else { return }
        guard document.password == nil else { return }
        let printInfo = UIPrintInfo.printInfo()
        printInfo.duplex = .longEdge
        printInfo.outputType = .general
        printInfo.jobName = document.fileName
        
        let printInteraction = UIPrintInteractionController.shared
        printInteraction.printInfo = printInfo
        printInteraction.printingItem = document.fileData
        printInteraction.showsPageRange = true
        printInteraction.present(animated: true, completionHandler: nil)
    }
}

//MARK: - Extension PDFViewController  CollectionViewDataSource -
extension PDFViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return document.pageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "page", for: indexPath) as! PDFPageCollectionViewCell
        cell.setup(indexPath.row, collectionViewBounds: collectionView.bounds, document: document, pageCollectionViewCellDelegate: self,isHorizontal:isHorizontal,pdfImage:pdfImagesArray?[indexPath.row])
        return cell
    }
}

//MARK: - Extension PDFViewController PDFCollectionViewCellDelegate -
extension PDFViewController: PDFPageCollectionViewCellDelegate {
    
    private func hideThumbnailController(_ shouldHide: Bool) {
        self.thumbnailCollectionControllerBottom.constant = shouldHide ? -thumbnailCollectionControllerHeight.constant : 0
    }
    
    func handleSingleTap(_ cell: PDFPageCollectionViewCell, pdfPageView: PDFPageView) {
        var shouldHide: Bool {
            guard let isNavigationBarHidden = navigationController?.isNavigationBarHidden else {
                return false
            }
            return !isNavigationBarHidden
        }
        UIView.animate(withDuration: 0.25) {
            self.hideThumbnailController(shouldHide)
            self.navigationController?.setNavigationBarHidden(shouldHide, animated: true)
        }
    }
}

//MARK: - Extension PDFViewController -(CollectionViewDelegateFlowLayout)
extension PDFViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let orientation = UIDevice.current.orientation
        
        //case 2 (Mode - landscape  Orientation - single)
        if orientation.isLandscape && isHorizontal == true
        {
            return CGSize(width:collectionView.frame.size.width,height:collectionView.frame.size.height)
        }
            
            //case 4 (Mode - landscape  Orientation - continuous)
        else if orientation.isLandscape && isHorizontal == false
        {
            return CGSize(width:UIScreen.main.bounds.width, height: visibleHeightArray?[indexPath.row] ?? collectionView.frame.size.height)
        }
            
            //case 3 (Mode - portrait Orientation - continuous)
        else if isHorizontal == false
        {
            return CGSize(width: UIScreen.main.bounds.width, height: visibleHeightArray?[indexPath.row] ?? collectionView.frame.size.height)
            
        }
        else
        {
            //case 1 (Mode - portrait  Orientation - Single)
            return CGSize(width:collectionView.frame.size.width,height:collectionView.frame.size.height)
        }
    }
}


//MARK: - extension PDFViewController - (scroll View Delegate)
extension PDFViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let updatedPageIndex: Int
        if self.scrollDirection == .vertical {
            updatedPageIndex = Int(round(max(scrollView.contentOffset.y, 0) / scrollView.bounds.height))
        } else {
            updatedPageIndex = Int(round(max(scrollView.contentOffset.x, 0) / scrollView.bounds.width))
        }
        
        if updatedPageIndex != currentPageIndex {
            currentPageIndex = updatedPageIndex
        }
    }
}
