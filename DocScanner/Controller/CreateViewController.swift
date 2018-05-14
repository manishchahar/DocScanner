//
//  CreateViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/6/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import PDFKit
class CreateViewController: UIViewController {
    
    var pdfDocument = PDFDocument()
    var workingDirectory : URL?
    
    @IBOutlet weak var saveBtnOutlet: UIBarButtonItem!
    
    @IBAction func saveBtnAction(_ sender: UIBarButtonItem) {
        AlertUtil.shared.alertWithTextField(parent: self, title: "Save", message: "Enter name for your new document", placeholder: "File Name", value: "", proceedTitle: "Save", cancelTitle: "Later", didProceed: { (fileName) in
            self.storeDocument(fileName: fileName)
        }, didCancel: nil)
    }
    func storeDocument(fileName:String) {
        let allImageFiles = FileUtility.shared.scanDirectory(directory: FileUtility.shared.getCachedDirectory()!)
        var imageCount = 0
        for file in allImageFiles{
            if let image = UIImage(contentsOfFile: file.path){
                let page = PDFPage(image: image)
                self.pdfDocument.insert(page!, at: imageCount)
                imageCount += 1
            }
            let errorMsg = FileUtility.shared.writeFile(directory: self.workingDirectory!, file: self.pdfDocument.dataRepresentation()!, fileName: "\(fileName).pdf")
            if(errorMsg != ""){
                self.presentAlert(title: "Failed", message: errorMsg.appending("\n Please try Again!"))
            }else{
                self.presentAlert(title: "Success", message: "File saved successfully")
                DispatchQueue.main.async {
                    self.deleteAllImages()
                }
            }
        }
    }
    
    func deleteAllImages(){
        let allImageFiles = FileUtility.shared.scanDirectory(directory: FileUtility.shared.getCachedDirectory()!)
        for file in allImageFiles{
            FileUtility.shared.deleteFile(url: file.url)
        }
    }
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtnOutlet.isEnabled = false
        editBtnOutlet.isEnabled = false
        // Do any additional setup after loading the view.
        clearCache()
        
        self.libraryAction(self.libraryBtn)
        Animation.shared.make(dragableView: self.capturedImageView, onView: self.view)
        self.capturedImageView.frame = CGRect(x: 0, y: self.view.frame.height-144, width: 90, height: 100)
        self.capturedImageView.layer.cornerRadius = 10
        self.capturedImageView.image = nil
        self.capturedImageView.backgroundColor = UIColor.clear
        self.capturedImageView.clipsToBounds = true
        self.capturedImageView.layer.shadowRadius = 50
        self.capturedImageView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func clearCache() {
        FileUtility.shared.deleteFile(url: FileUtility.shared.getCachedDirectory()!)
    }
    
    func checkAndRemoveExtraPickerView(){
        for v in self.container.subviews{
            v.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(view.tag == 0){
            view.tag = 1
        }else{
            self.libraryAction(self.libraryBtn)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Toolbar
    
    @IBOutlet weak var libraryBtn: UIBarButtonItem!
    
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    
    @IBOutlet weak var downloadBtn: UIBarButtonItem!
    
    @IBAction func libraryAction(_ sender: UIBarButtonItem) {
        libraryBtn.tintColor = UIColor.blue
        libraryBtn.isEnabled = false
        cameraBtn.tintColor = UIColor.darkGray
        cameraBtn.isEnabled = true
        downloadBtn.tintColor = UIColor.darkGray
        downloadBtn.isEnabled = true
        
        removeExistingSubviews()
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LibraryViewController") as! LibraryViewController
        vc.delegate = self
        vc.view.frame = CGRect(x: 0, y: 0, width: self.container.frame.width, height: self.container.frame.height)
        self.container.addSubview(vc.view)
        self.addChildViewController(vc)
    }
    @IBAction func cameraAction(_ sender: UIBarButtonItem) {
        libraryBtn.tintColor = UIColor.darkGray
        libraryBtn.isEnabled = true
        cameraBtn.tintColor = UIColor.blue
        cameraBtn.isEnabled = false
        downloadBtn.tintColor = UIColor.darkGray
        downloadBtn.isEnabled = true
        
        removeExistingSubviews()
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        vc.view.frame = CGRect(x:0,y:0,width:self.container.frame.width,height:self.container.frame.height)
        self.addChildViewController(vc)
        vc.delegate = self
        self.container.addSubview(vc.view)
    }
    
    @IBAction func downloadAction(_ sender: UIBarButtonItem) {
        libraryBtn.tintColor = UIColor.darkGray
        libraryBtn.isEnabled = true
        cameraBtn.tintColor = UIColor.darkGray
        cameraBtn.isEnabled = true
        downloadBtn.tintColor = UIColor.blue
        downloadBtn.isEnabled = false
        
        removeExistingSubviews()
        
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DownloadViewController") as! DownloadViewController
        vc.view.frame = CGRect(x:0,y:0,width:self.container.frame.width,height:self.container.frame.height)
        self.addChildViewController(vc)
        vc.delegate = self
        self.container.addSubview(vc.view)
    }
    func removeExistingSubviews() {
        for v in self.container.subviews{
            v.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? DocumentViewController{
            vc.workingFilePath = FileUtility.shared.getCachedDirectory()
        }
    }
    
    
    
    //MARK:Edit operation
    
    
    @IBOutlet weak var editBtnOutlet: UIBarButtonItem!
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        
    }
    //MARK: Capture delegate
    var allImage : [UIImage] = []
    var imageCount = 0
    let capturedImageView = UIImageView()
    let imageTapGesture = UITapGestureRecognizer()
}
extension CreateViewController:ImageCaptureDelegate{
    func didCaptured(image: UIImage) {
        self.capturedImageView.image = image
        Animation.shared.popUp(parentView: self.view, childView: self.capturedImageView)
        let imageRepresentation = UIImagePNGRepresentation(image)
        let errorMsg = FileUtility.shared.writeFile(directory: FileUtility.shared.getCachedDirectory()!, file: imageRepresentation!, fileName: "\(imageCount).png")
        
        if(errorMsg != ""){
            self.presentAlert(title: "Failed", message: errorMsg)
        }else{
            imageCount += 1
        }
        saveBtnOutlet.isEnabled = true
        editBtnOutlet.isEnabled = true
    }
    @objc func tappeCapturedImageView(gesture:UITapGestureRecognizer){
//        Animation.shared.scale(view: self.capturedImageView)
    }
}


