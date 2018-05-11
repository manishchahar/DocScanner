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
    let queue = DispatchQueue(label: "DocumentViewController", qos: .userInitiated, attributes: [.concurrent], autoreleaseFrequency: .workItem, target: nil)
    var numberOfPages = 0
    var workingFilePath : URL?
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
            FileUtility.shared.splitPdf(atPath: self.workingFilePath!)
            self.fetchDocument(atPath: self.workingFilePath!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func fetchDocument(atPath path : URL) {
        let count = FileUtility.shared.getPageCount(atPath: self.workingFilePath!)
        if count != 0{
            self.numberOfPages = count
            self.collectionView.reloadData()
        }else{
            self.presentAlert(title: "Failed", message: "Unable to process your request")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
extension DocumentViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfPages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        let url = FileUtility.shared.getSplitedPageUrl(pdfUrl: self.workingFilePath!, pageNumber: indexPath.row)
        let request = URLRequest(url: url)
        cell.webView.load(request)
        return cell
    }
    
}

