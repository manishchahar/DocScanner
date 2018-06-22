//
//  ++ PDFPage.swift
//  DocScanner
//
//  Created by Balamurugan V M on 20/06/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import PDFKit
import UIKit
extension CGPDFPage{
    func image() -> UIImage {
        let pageRect = self.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(self)
        }
        UIGraphicsEndImageContext()
        return img
    }
    func image(size:CGSize) -> UIImage {
        let pageRect = self.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size:size)
        let img = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            
            ctx.cgContext.drawPDFPage(self)
        }
        UIGraphicsEndImageContext()
        return img
    }
}
