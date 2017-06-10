//
//  BottomView.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 10/06/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit

class BottomView: UIView {

    @IBOutlet public var collectionView: UICollectionView!
    public var isHorizontal :Bool?
    @IBAction func changeOrientation(_ sender: UIButton) {
        print("function called",collectionView)
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
    }

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
}
