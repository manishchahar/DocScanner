//
//  ++UIViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/7/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
extension UIViewController{
    func presentAlert(title:String,message:String) {
        let genericAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        genericAlert.addAction(okAction)
        self.present(genericAlert, animated: true, completion: nil)
    }
}
