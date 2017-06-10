//
//  ExtensionGoogleConfViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 29/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit

extension GoogleConfViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard var cell:DriveImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "drivecell", for: indexPath) as? DriveImageCollectionViewCell
            else{
                return DriveImageCollectionViewCell()
        }
        cell.ImgDrive.image =  imagesArr[indexPath.row]
        cell = CustomCellLayout.changeCustom(value: indexPath.row,cell: cell) as! DriveImageCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3)
    }
}
