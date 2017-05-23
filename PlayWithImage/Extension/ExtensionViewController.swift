//
//  ExtensionViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit

//MARK: extension
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        guard let cell:MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewIdentifier.cellIdentifier.rawValue, for: indexPath) as? MyCollectionViewCell
            else{
                return MyCollectionViewCell()
        }
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: Selector("performSegue"))
        cell.imgView.isUserInteractionEnabled = true
        cell.imgView.addGestureRecognizer(tap)
        cell.imgView.image = imageArr[indexPath.row]
        cell.imgView.transform = .identity
        return cell
    }
   
    func performSegue()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController
        let cell = collectionView.visibleCells.first as? MyCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell!)
        vc?.image = imageArr[(indexPath?.row)!]
        self.present(vc!, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}


