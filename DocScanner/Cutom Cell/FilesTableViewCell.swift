//
//  FilesTableViewCell.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/8/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class FilesTableViewCell: UITableViewCell {
    @IBOutlet weak var fileImageView: UIImageView!
    

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        fileImageView.image = fileImageView.image?.withRenderingMode(.alwaysTemplate)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
