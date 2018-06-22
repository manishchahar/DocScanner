//
//  DocumentViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/8/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import PDFKit
class DocumentViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var pdfDocument = PDFDocument()
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        var imageCount = 0
        for file in self.allFiles{
            if let image = UIImage(contentsOfFile: file.path){
                let page = PDFPage(image: image)
                self.pdfDocument.insert(page!, at: imageCount)
                imageCount += 1
            }
        }
        let errorMsg = FileUtility.shared.writeFile(directory: self.workingFilePath!, file: self.pdfDocument.dataRepresentation()!)
        if(errorMsg != ""){
            self.presentAlert(title: "Failed", message: errorMsg.appending("\n Please try Again!"))
        }else{
            self.presentAlert(title: "Success", message: "File saved successfully")
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func deleteAllImages(){
        let allImageFiles = FileUtility.shared.scanDirectory(directory: FileUtility.shared.getCachedDirectory()!)
        for file in allImageFiles{
            FileUtility.shared.deleteFile(url: file.url)
        }
    }
    var workingFilePath : URL?
    let cachedDirectory = FileUtility.shared.getCachedDirectory()
    var allFiles : [File] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let size = self.view.frame.size.width/3.1
        let cellSize = CGSize(width:size , height:size)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 2, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        DispatchQueue.main.async {
            self.loadImages()
        }
    }
    
    func loadImages() {
        self.allFiles.removeAll()
        switch self.workingFilePath!.pathExtension {
        case "pdf":
            self.extractImages(pdfUrl: self.workingFilePath!)
            break
        default:
            self.loadImages(from: self.workingFilePath!)
        }
    }
    func loadImages(from targetDirectory:URL) {
        self.allFiles = FileUtility.shared.scanDirectory(directory: targetDirectory)
        allFiles = allFiles.sorted(by: { (file1, file2) -> Bool in
            return Int(file1.name)!<Int(file2.name)!
        })
        self.collectionView.reloadData()
    }
    func extractImages(pdfUrl:URL) {
        if let pdf = CGPDFDocument(self.workingFilePath! as CFURL){
            let pageCount = pdf.numberOfPages
            for i in 0..<pageCount{
                if let page = pdf.page(at: i+1){
                    let imageName = i.description + ".png"
                    FileUtility.shared.writeFile(directory: self.cachedDirectory!, file: UIImagePNGRepresentation(page.image(size:ImageRenderer.shared.a4Size))!, fileName: imageName)
                }
            }
            self.loadImages(from: self.cachedDirectory!)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.view.tag == 0{
            self.view.tag = 1
        }else{
            if(self.workingFilePath!.pathExtension == "pdf"){
                self.loadImages(from: self.cachedDirectory!)
            }else{
                self.loadImages()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? EditorViewController,let targetFile = self.selectedFile{
            vc.workingFile = targetFile
        }
    }
    
    var selectedFile : File?
}
extension DocumentViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.url = self.allFiles[indexPath.row].url
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFile = self.allFiles[indexPath.row]
        self.performSegue(withIdentifier: "EditorViewController", sender: self)
    }
    
}

