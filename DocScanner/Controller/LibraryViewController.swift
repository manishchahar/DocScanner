//
//  LibraryViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/10/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
class LibraryViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    public static let shared = LibraryViewController()
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
    
    let imagePicker = UIImagePickerController()

    func startPhotoAlbum() {
        self.addChildViewController(imagePicker)
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            if let margin = self.navigationController?.navigationBar.frame.height{
                imagePicker.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }else{
                imagePicker.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            }
            self.view.addSubview(imagePicker.view)
            let cancel = UILabel()
            cancel.frame = CGRect(x: imagePicker.view.frame.width*0.7, y: 0, width: imagePicker.view.frame.width*0.3, height: 44)
            cancel.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            imagePicker.view.addSubview(cancel)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            CaptureImageSharing.shared.image = image.fixOrientation()
        }
    }
}
