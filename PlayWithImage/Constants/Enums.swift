//
//  Enums.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 23/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//


enum CollectionViewIdentifier : String
{
    case cellIdentifier = "cell"
}

enum Pdf : String
{
    case Title = "Success"
    case success = "PDF Generate Successfully"
    case location = "location: "
    case fileName = "myPDFImage.pdf"
    case folderName = "CodeBrew"
}

enum VCIdentifier : String
{
        case PdfReaderViewController = "PdfReaderViewController"
        case SecondViewController = "SecondViewController"
}

enum OtherUtility : String
{
    case Main = "Main"
    case error = "Error"
    case blank = ""
    case failure = "Failure"
    case Success = "Success"
}

enum FileNotExist : String
{
    case Title = "Attention!"
    case Message = "No File Exists"
}

enum CheckMimeType : String
{
    case jpg = "image/jpg"
    case jpeg = "image/jpeg"
    case png = "image/png"
}
enum GoogleDrive : String
{
    case FileName = "myPDF.pdf"
    case mimeType = "application/pdf"
    case FileID = "FileID"
}

enum DropBox : String
{
    case uploadedFilenName = "myPDF.pdf"
    case FolderCreated = "CodeBrew"
}

enum  Url : String
{
    case retrieveUrl =  "https://www.googleapis.com/drive/v3/files/"
    case mediatype = "?alt=media"
}
