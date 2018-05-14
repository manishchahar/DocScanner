//
//  EditorViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/12/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import CoreImage
class EditorViewController: UIViewController {
    
    @IBOutlet weak var cancelOutlet: UIBarButtonItem!
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var undoOutlet: UIBarButtonItem!
    @IBAction func undoAction(_ sender: UIBarButtonItem) {
        self.imageView.image = UIImage(contentsOfFile: self.workingFile!.path)
    }
    @IBOutlet weak var saveOutlet: UIBarButtonItem!
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let imageRepresentation = UIImagePNGRepresentation(self.imageView.image!)
       let result = FileUtility.shared.deleteFile(url: self.workingFile!.url)
        
        let errorMsg = FileUtility.shared.writeFile(directory: self.workingFile!.url.deletingLastPathComponent(), file: imageRepresentation!, fileName: self.workingFile!.name)
        if(errorMsg != ""){
            self.presentAlert(title: "Error", message: errorMsg)
        }else{
            self.presentAlert(title: "Success", message: "Edited Image saved successfully") {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBOutlet weak var filtersScrollView: UIScrollView!
    
    var builtInFilters = [
        
        "CISepiaTone",
        "CIVignette",
        
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectMono",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal"
]
    
    
    @IBOutlet weak var imageView: UIImageView!
    var workingFile:File?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = UIImage(contentsOfFile: self.workingFile!.path)
        self.prepareFilters()
        self.title = self.workingFile!.name
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func prepareFilters() {
        var itemCount = 0
        var xCoord: CGFloat = 5
        let yCoord: CGFloat = 5
        let buttonWidth:CGFloat = 70
        let buttonHeight: CGFloat = 70
        let gapBetweenButtons: CGFloat = 5
        var fullWidth:CGFloat = 16
        let croppedImage = self.imageView.image?.renderResizedImage(newWidth: 200)
        let originalImage = CIImage(image: croppedImage!)
        for i in 0..<self.builtInFilters.count {
            itemCount = i
            
            // Button properties
            let filterButton = UIButton(type: .custom)
            filterButton.frame = CGRect(x: xCoord,y: yCoord,width: buttonWidth,height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self, action: #selector(filterButtonTapped(sender:)), for: .touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            // CODE FOR FILTERS WILL BE ADDED HERE...
            // Create filters for each button
            let filter = CIFilter(name: self.builtInFilters[i])
            filter?.setValue(originalImage, forKey: kCIInputImageKey)
            let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])
            let outputImage = context.createCGImage(filter!.outputImage!, from: filter!.outputImage!.extent)
            let newImage = UIImage(cgImage: outputImage!)            // Assign filtered image to the button
            filterButton.setBackgroundImage(newImage, for: .normal)
            // Add Buttons in the Scroll View
            xCoord +=  buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
            // END FOR LOOP
            fullWidth = fullWidth + filterButton.frame.width
        }
        UIGraphicsEndImageContext()
        // Resize Scroll View
        self.filtersScrollView.contentSize = CGSize(width: fullWidth+40, height: self.filtersScrollView.frame.height)
    }
    
    @objc func filterButtonTapped(sender:UIButton) {
        let filter = CIFilter(name: self.builtInFilters[sender.tag])
        let originalImage = CIImage(image: UIImage(contentsOfFile: self.workingFile!.path)!)
        filter?.setValue(originalImage, forKey: kCIInputImageKey)
        let context = CIContext(options: [kCIContextUseSoftwareRenderer: true])
        let outputImage = context.createCGImage(filter!.outputImage!, from: filter!.outputImage!.extent)
        let newImage = UIImage(cgImage: outputImage!)
        self.imageView.image = newImage
        UIGraphicsEndImageContext()

    }
    
    /*
     // MARK: - Navigations
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
