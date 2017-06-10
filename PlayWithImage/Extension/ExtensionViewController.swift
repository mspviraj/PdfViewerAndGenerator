//
//  ExtensionViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 22/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit

//MARK:- extension
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
        tap.addTarget(self, action: #selector(self.performSegue(_ :)))
        cell.imgView.isUserInteractionEnabled = true
        cell.imgView.addGestureRecognizer(tap)
        cell.imgView.image = imageArr[indexPath.row]
        cell.imgView.transform = .identity
        cell.mainVCobj = self
        return cell
    }
    
    //MARK:-
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    //MARK:- performSegue
    func performSegue(_ sender: UITapGestureRecognizer)
    {
        let vc = UIStoryboard(name: OtherUtility.Main.rawValue, bundle: nil).instantiateViewController(withIdentifier: VCIdentifier.SecondViewController.rawValue) as? SecondViewController
        let cell = collectionView.visibleCells.first as? MyCollectionViewCell
        let indexPath = collectionView.indexPath(for: cell!)
        vc?.image = cell?.thumbImage
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    
}


