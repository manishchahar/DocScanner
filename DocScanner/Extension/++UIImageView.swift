//
//  ++UIImageView.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/8/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
