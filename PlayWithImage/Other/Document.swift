//
//  Document.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 25/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import Foundation
import UIKit

class Document
{
    //MARK:- getDocumentsDirectory()
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
