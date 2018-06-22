//
//  ++WKWebView.swift
//  DocScanner
//
//  Created by Vivek Kumar on 21/06/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import Foundation
import WebKit
extension WKWebView{
    func setBgColor(id elementId:String,color hexColorCode:String,completion:@escaping ((Any?, Error?)->Void)) {
        let script = """
        document.getElementById("\(elementId)").style.backgroundColor = "\(hexColorCode)";
        """
        self.evaluateJavaScript(script) { (result, error) in
            completion(result,error)
        }
    }
    
    func setBgColor(id elementId:String,color newColor:UIColor ,completion:@escaping ((Any?, Error?)->Void)) {
        let script = """
        document.getElementById("\(elementId)").style.backgroundColor = "\(newColor.htmlRGBColor)";
        """
        self.evaluateJavaScript(script) { (result, error) in
            completion(result,error)
        }
    }
    
    func setFontColor(id elementId:String,color hexColorCode:String,completion:@escaping ((Any?, Error?)->Void)) {
        let script = """
        document.getElementById("\(elementId)").style.color = "\(hexColorCode)";
        """
        self.evaluateJavaScript(script) { (result, error) in
            completion(result,error)
        }
    }
    
    func setFontColor(id elementId:String,color newColor:UIColor ,completion:@escaping ((Any?, Error?)->Void)) {
        let script = """
        document.getElementById("\(elementId)").style.color = "\(newColor.htmlRGBColor)";
        """
        self.evaluateJavaScript(script) { (result, error) in
            completion(result,error)
        }
    }
    
}
