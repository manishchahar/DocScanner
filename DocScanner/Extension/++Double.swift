//
//  ++Double.swift
//  DocScanner
//
//  Created by Vivek Kumar on 20/06/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import Foundation
extension Double{
    func formateNumber()->String{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        let formatString = formatter.string(from: self as NSNumber) ?? ""
        return formatString
    }
    
    func rounded(places:Int) ->Double{
        if let rounded = Double(String(format: "%.\(places)f", self)){
            return rounded
        }else{
            return self
        }
    }
    
}
