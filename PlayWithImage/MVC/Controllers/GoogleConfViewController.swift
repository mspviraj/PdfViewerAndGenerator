//
//  GoogleConfViewController.swift
//  PlayWithImage
//
//  Created by Sierra 4 on 26/05/17.
//  Copyright © 2017 code.brew. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMOAuth2
import Google
import GoogleToolboxForMac

class GoogleConfViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate{

   
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    //MARK:- Variables
    private let scopes = [kGTLRAuthScopeDriveReadonly,kGTLRAuthScopeDriveAppdata,kGTLRAuthScopeDriveMetadata]
    public var imagesArr  = [UIImage]()
    public var clientID =  GIDSignIn.sharedInstance().clientID
    public var authToken : String?
    public var documentObj = Document()
    private let service:GTLRDriveService = GTLRDriveService()
    let signInButton = GIDSignInButton()
    
    
    //MARK:- viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        self.service.authorizer  = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychain(forName: " " as String!,clientID: clientID,clientSecret: "")
      //  signInButton.frame = CGRect(x: 0.0,y: 10.0, width: 50.0,height: 50.0)
         view.addSubview(signInButton)
    }
    
    //MARK:- viewDidAppear 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    //MARK:- viewWillDisappear()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }

    
    //MARK:- googleSignInDelegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        }
        else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            self.authToken = user.serverAuthCode
    
            // get the google drive files
            listFiles()
          }
    }
    
    //MARK:- listFiles
    func listFiles() {
        let query = GTLRDriveQuery_FilesList.query()
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:))
        )
    }
    
    
    //MARK:- displayResultWithTicket
    func displayResultWithTicket(ticket: GTLRServiceTicket,
                                 finishedWithObject result : GTLRDrive_FileList,
                                 error : NSError?) {
        if let error = error {
            showAlert(title: OtherUtility.error.rawValue, message: error.localizedDescription)
            return
        }
          if let files = result.files, !files.isEmpty{
            for file in files{
                if file.mimeType == CheckMimeType.jpeg.rawValue || file.mimeType == CheckMimeType.jpg.rawValue || file.mimeType == CheckMimeType.png.rawValue
                {
                   retrieveFile(file:file)
                }
            }
        }
    }

    
    //MARK:- retrieveFile()
    func retrieveFile(file:GTLRDrive_File)
    {
        let url = "\(Url.retrieveUrl.rawValue)\(file.identifier!)\(Url.mediatype.rawValue)"
        let fetcher = service.fetcherService.fetcher(withURLString: url)
        fetcher.beginFetch(withDelegate: self, didFinish: #selector(self.finishedFileDownload(fetcher:finishedWithData:error:)))
    }
    
    
    //MARK:- finishedFileDownload
    func finishedFileDownload(fetcher: GTMSessionFetcher, finishedWithData data: NSData, error: NSError?){
        if let error = error {
            //show an alert with the error message or something similar
            print("\(OtherUtility.error.rawValue) :",error)
            return
        }
        convertNSDataIntoImage(data : data)
    }
    
    
    //MARK:- convertNSDataIntoImage
    func convertNSDataIntoImage(data :NSData)
    {
            if let image = UIImage(data: data as Data)
            {
                imagesArr.append(image)
                collectionView.reloadData()
            }
    }
   
    
    //MARK:- showAlert()
    func showAlert(title : String, message: String)
    {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK:- upload pdf file on Google Drive
    @IBAction func btnUploadPdf(_ sender: UIButton)
    {
        //GIDSignIn.sharedInstance().signOut()
        EZLoadingActivity.show("Please Wait..", disableUI: false)
        uploadFileOnGoogleDrive()
    }

    
    //MARK:- uploadFiles
    func uploadFileOnGoogleDrive()
    {
            let documentUrl:URL =  documentObj.getDocumentsDirectory()
            let fileUrl = (documentUrl.appendingPathComponent("\(Pdf.folderName.rawValue)")).appendingPathComponent("\(Pdf.fileName.rawValue)")
            print()
            guard let data = try? Data(contentsOf: fileUrl) else {
                EZLoadingActivity.hide(false, animated: true)
                return
            }
        let fileData = data
        let metadata = GTLRDrive_File()
        metadata.name = GoogleDrive.FileName.rawValue
        let  uploadParameters = GTLRUploadParameters(data: fileData, mimeType: GoogleDrive.mimeType.rawValue)
        uploadParameters.shouldUploadWithSingleRequest = true
        let  query = GTLRDriveQuery_FilesCreate.query(withObject: metadata, uploadParameters: uploadParameters)
        //query.fields = "id"
        service.executeQuery(query, completionHandler: {(_ callbackTicket : GTLRServiceTicket, _ object: Any?, _ callbackError: Error?) -> Void in
            let myFile = object as? GTLRDrive_File
            if callbackError == nil {
                print("\(GoogleDrive.FileID.rawValue) : \(String(describing: myFile?.identifier))")
                EZLoadingActivity.hide(true, animated: true)
            }
            else {
                 print("\(OtherUtility.error.rawValue) : \(String(describing: callbackError?.localizedDescription))")
                 EZLoadingActivity.hide(false, animated: true)
            }
        })
    }
}
