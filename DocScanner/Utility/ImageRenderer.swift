//
//  ImageRenderer.swift
//  DocScanner
//
//  Created by Vivek Kumar on 20/06/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import CoreImage
public class ImageRenderer {
    public static let shared = ImageRenderer()
    let a4Size = CGSize(width: 595, height: 842)
    func renderToA4(image inputImage:UIImage) -> UIImage {
        let size = inputImage.size
        let widthRatio  = a4Size.width  / size.width
        let heightRatio = a4Size.height / size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio,height: size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio, height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0,y:0,width:newSize.width,height:newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        inputImage.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func renderToA4(image inputImages:[UIImage]) -> [UIImage] {
        var outputImages = [UIImage]()
        for item in inputImages{
            outputImages.append(self.renderToA4(image: item))
        }
        return outputImages
    }
    func renderExistingImage(at filePath:URL) {
        if let image = UIImage(contentsOfFile: filePath.path){
            print(FileUtility.shared.writeFile(directory: filePath, file: UIImagePNGRepresentation(self.renderToA4(image: image))!))
        }
    }
    func fixOrientation(image inputImage:UIImage) -> UIImage {
        if inputImage.imageOrientation == UIImageOrientation.up {
            return inputImage
        }else{
            UIGraphicsBeginImageContextWithOptions(inputImage.size, false, inputImage.scale)
            inputImage.draw(in: CGRect(x: 0, y: 0, width: inputImage.size.width, height: inputImage.size.height))
            if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                return normalizedImage
            } else {
                UIGraphicsEndImageContext()
                return inputImage
            }
        }
    }
}
