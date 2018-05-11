//
//  ImageCollectionViewCell.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/8/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import WebKit
class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var webView: WKWebView!
    var url : URL?{
        didSet{
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
