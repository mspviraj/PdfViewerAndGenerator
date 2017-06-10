//
//  PDFSinglePageViewer.swift
//  Pods
//
//  Created by Chris Anderson on 3/6/16.
//
//

import UIKit

open class PDFSinglePageViewer: UICollectionView {
    
    open var document: PDFDocument?
    public static var isHorizontal:Bool?
    public var finalImages:[UIImage]?
    public static var flowLayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        if isHorizontal == true
        {
            layout.scrollDirection = .vertical
            isHorizontal = false
        }
        else
        {
             layout.scrollDirection = .horizontal
             isHorizontal = true
        }
        
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        return layout
    }
    
       public init(frame: CGRect, document: PDFDocument) {
        super.init(frame: frame, collectionViewLayout: PDFSinglePageViewer.flowLayout)
        self.document = document
        setupCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        collectionViewLayout = PDFSinglePageViewer.flowLayout
        setupCollectionView()
    }
    
    open func setLayout(layout: UICollectionViewFlowLayout)
    {
        collectionViewLayout = layout
        setupCollectionView()
        
    }
    func setupCollectionView() {
        if isPagingEnabled == false
        {
            isPagingEnabled = true
        }
        else
        {
            isPagingEnabled = false
        }
        backgroundColor = UIColor.groupTableViewBackground
        showsHorizontalScrollIndicator = false
        register(PDFSinglePageCell.self, forCellWithReuseIdentifier: "ContentCell")
        delegate = self
        dataSource = self
    }
    open func indexForPage(_ page: Int) -> Int {
        let currentPage = page - 1
        if currentPage <= 0 {
            return 0
        } else if let pageCount = document?.pageCount, currentPage > pageCount {
            return pageCount - 1
        } else {
            return currentPage
        }
    }
    
   open func getPageContent(_ page: Int) -> PDFPageContentView? {
        if document == nil { return nil }
        let currentPage = indexForPage(page)
        if let cell = self.collectionView(self, cellForItemAt: IndexPath(item: currentPage, section: 0)) as? PDFSinglePageCell,
            let pageContentView = cell.pageContentView {
            return pageContentView
        }
        return nil
    }
}

extension PDFSinglePageViewer: UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        
        
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let document = self.document else {
            return 0
        }
        return document.pageCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! PDFSinglePageCell
        
        let contentSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        var contentFrame = CGRect()
//        if (UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
//        {
//            //code for portrait
//            contentFrame = CGRect(origin: CGPoint(x:(collectionView.frame.width * CGFloat(indexPath.row + 1) / 2),y:0) ,size: contentSize)
//            contentFrame.size = contentSize
//        }
//        else{
            contentFrame = CGRect(origin: CGPoint.zero, size: contentSize)
   //     }
        let page = indexPath.row + 1
        cell.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cell.contentView.backgroundColor = UIColor.darkGray
        cell.pageContentView = PDFPageContentView(frame: contentFrame, document: document!, page: page)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // return CGSize(width: self.frame.width, height: self.frame.height)
        
//        if (UIDeviceOrientationIsLandscape(UIDevice.current.orientation))
//        {
//        return CGSize(width:finalImages![indexPath.row].size.width,height:finalImages![indexPath.row].size.height)
//            
//        }
//        else{
            return CGSize(width: self.frame.width , height: self.frame.height)
//        }
        }
 }
