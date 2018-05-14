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
    var workingFilePath : URL?
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
        loadImages()
    }
    
    func loadImages() {
        self.allFiles.removeAll()
        self.allFiles = FileUtility.shared.scanDirectory(directory: self.workingFilePath!)
        allFiles = allFiles.sorted(by: { (file1, file2) -> Bool in
            return Int(file1.name)!<Int(file2.name)!
        })
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.view.tag == 0{
            self.view.tag = 1
        }else{
            self.loadImages()
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

