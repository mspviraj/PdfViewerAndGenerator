//
//  ExtensionViewControllerRetrieveImages.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 31/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import Foundation
import SwiftyDropbox
extension ViewController {
    
    //MARK:- isClientAuthorized
    func getImageFromDropbox() {
        
        let client = DropboxClientsManager.authorizedClient
        
        //Get list of folder of dropbox by set (path: "/")
        //Or you can get folder inside a folder by set (path: "/Photos")
        client?.files.listFolder(path: "").response(queue: DispatchQueue(label: "MyCustomSerialQueue")) { response, error in
            if let result = response {
                print(Thread.current)  // Output: <NSThread: 0x61000007bec0>{number = 4, name = (null)}
                print(Thread.main)     // Output: <NSThread: 0x608000070100>{number = 1, name = (null)}
                print(result)
            }
        }
        client?.files.listFolder(path: "/Photos").response{ (objList, error) in
            if let resultList = objList {
                
                //Create a for loop for getting all the entities individually
                for entry in resultList.entries {
                    
                    //Check if file have metadata or not
                    if let fileMetadata = entry as? Files.FileMetadata {
                        
                        //Check file type by extention .jpg/.png
                        //You can check this by your own added extention
                        if self.isFileImage(filename: fileMetadata.name) == true {
                            //Get Path for save image in document directory
                            let destination : (URL, HTTPURLResponse) -> URL  = { temporaryURL, response in
                                return self.getDocumentDirectoryPath(fileName: fileMetadata.name)
                            }
                            client?.files.download(path: "/Photos", overwrite: true, destination: destination)
                                .response { response, error in
                                    if let response = response {
                                        print(response)
                                    } else if let error = error {
                                        print(error)
                                    }
                                }
                                .progress { progressData in
                                    print(progressData)
                                    
                                    
                                    //Download Image on destination path
                            }
                        }
                    }
                }
            }}}
    
    
    //MARK: check for file type
    func isFileImage(filename:String) -> Bool {
        let lastPathComponent = (filename as NSString).pathExtension.lowercased()
        return lastPathComponent == "jpg" || lastPathComponent == "png"
    }
    
    //to get document directory path
    func getDocumentDirectoryPath(fileName:String) -> URL {
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let UUID = NSUUID().uuidString
        let pathComponent = "\(UUID)-\(fileName)"
        return directoryURL.appendingPathComponent(pathComponent)
    }
}


//                                if let url = fileData {
//                                    let data = NSData(contentsOfURL: url)
//                                    let img = UIImage(data: data!)
//
//                                    if !self.arrSelectImages.containsObject(img!) {
//                                        self.arrSelectImages.addObject(img!)
//
//                                    }
//                                    else {
//                                        print("Image already added to array")
//                                    }
//                                }


//                            client.files.download(path: "/test/path/in/Dropbox/account", overwrite: true, destination: destination)
//                                .response { response, error in
//                                    if let response = response {
//                                        print(response)
//                                    } else if let error = error {
//                                        print(error)
//                                    }
//                                }
//                                .progress { progressData in
//                                    print(progressData)
//                            }
//
//                            client?.files.download(path: fileMetadata.pathLower!, destination: destination).response { response, error in
//
//                            }
//                        } else {
//                            //File is not an image
//                        }
//                    } else {
//                        //If file have not metadata it mean it is a folder.
//                    }}
//
//            } else {
//                print(error)
//            }
//        })

//                            client?.files.download(path: "/Photos", rev: <#T##String?#>, overwrite: <#T##Bool#>, destination: <#T##(URL, HTTPURLResponse) -> URL#>)
//                            client?.files.download(path: "/Photos").response(completionHandler: { (fileData, error) in
//                                print("fileData:",fileData ?? "nil")
//                                if error == nil
//                                {
//                                print("Filedata",fileData ?? "nil")
//                                }
//                                else
//                                {
//                                    print(error?.description ?? "nil")
//                                }
//                            })
//                        }

