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

    @IBOutlet weak var imageView: UIImageView!
    var url : URL?{
        didSet{
            self.imageView.image = UIImage(contentsOfFile: url!.path)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
