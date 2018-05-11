//
//  LibraryViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/10/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
class LibraryViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    var delegate : ImageCaptureDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startPhotoAlbum()
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
    
    
    func startPhotoAlbum() {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            if let margin = self.navigationController?.navigationBar.frame.height{
                imagePicker.view.frame = CGRect(x: 0, y: -margin, width: self.view.frame.width, height: self.view.frame.height+margin)
            }else{
                imagePicker.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height+50)
            }
            self.view.addSubview(imagePicker.view)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.delegate?.didCaptured(image: image)
        }
    }
}
