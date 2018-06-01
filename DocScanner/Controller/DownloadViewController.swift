//
//  DownloadViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/12/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class DownloadViewController: UIViewController {
    
    var delegate : ImageCaptureDelegate?
    @IBOutlet weak var downlaodOptionView: UIView!
    @IBOutlet weak var urlTextField: UITextField!
    
    @IBOutlet weak var downloadBtnOutlet: UIButton!
    
    @IBAction func downloadBtnAction(_ sender: UIButton) {
        WebService.shared.get(fromUrl: self.urlValue) { (status, image) in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.delegate = self
        downloadBtnOutlet.isEnabled = false
        // Do any additional setup after loading the view.
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
    
    //MARK:URL implementation
    var urlValue = "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png"
}
extension DownloadViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let urlFieldVal = textField.text{
            self.urlValue = urlFieldVal
            self.downloadBtnOutlet.isEnabled = true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let urlFieldVal = textField.text{
            self.urlValue = urlFieldVal
            if(urlFieldVal != ""){
                self.downloadBtnOutlet .isEnabled = true
            }else{
                self.downloadBtnOutlet.isEnabled = false
            }
        }else{
            self.downloadBtnOutlet.isEnabled = false
        }
    }
}


extension DownloadViewController{
    
}
