//
//  CustomCellLayout.swift
//  CustomLayout
//
//  Created by Sierra 4 on 03/03/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit

class CustomCellLayout
{

    static func changeCustom(value:Int,cell:UICollectionViewCell) -> UICollectionViewCell
    {
        cell.layer.cornerRadius = 2
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.orange.cgColor
        //cell.layer.backgroundColor = UIColor.orange.cgColor
        return cell
    }
}
