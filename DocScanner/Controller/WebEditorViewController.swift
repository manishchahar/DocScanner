//
//  WebEditorViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 21/06/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit
import WebKit
class WebEditorViewController: UIViewController {
    public static let shared = WebEditorViewController()
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet var optionView: UIView!
    
    let baseHtml = """
<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0" />
    </head>
    <body>
        <div id="editor" style="height:842px;" contenteditable="true" data-text="Enter text here"></div>
    </body>
</html>

"""
    
    func loadHtml(html:String) {
        self.webView.loadHTMLString(html, baseURL: nil)
    }
    var isOptionPresented = false
    
    @IBOutlet weak var slideOptionBtnOutlet: UIButton!
    @IBAction func slideOptionBtnAction(_ sender: UIButton) {
        self.slideOptionBtnOutlet.setImage(self.slideOptionBtnOutlet.imageView?.image?.rotate(radians: .pi), for: .normal)
        if(isOptionPresented){
            self.slideOutOptionView()
        }else{
            self.slideInOptionView()
        }
        self.isOptionPresented = !isOptionPresented
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadHtml(html: self.baseHtml)
        // Do any additional setup after loading the view.
        self.optionView.frame = CGRect.zero
        self.view.addSubview(self.optionView)
        self.slideOutOptionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func slideOutOptionView() {
        UIView.animate(withDuration: 0.2) {
            self.optionView.frame = CGRect(x: self.view.frame.width - 32, y: 0, width: 190, height: self.view.frame.width)
        }
    }
    
    func slideInOptionView() {
        UIView.animate(withDuration: 0.3) {
            self.optionView.frame = CGRect(x: self.view.frame.width-190, y: 0, width: 190, height: self.view.frame.height)
        }
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
    
    @IBOutlet weak var backgroundOptionView: UIView!
    @IBOutlet weak var backgroundOptionViewLabel: UILabel!
    @IBOutlet weak var backgroundOptionViewBtn: UIButton!
    @IBAction func backgroundOptionViewBtnClicked(_ sender: UIButton) {
        
        let popoverVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 430)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverVC.didSelect = {color in
                self.webView.setBgColor(id: "editor", color: color, completion: { (result, error) in
                    sender.backgroundColor = color
                })
            }
        }
        self.present(popoverVC, animated: true) {
            
        }
    }
    
    
    @IBOutlet weak var textOptionView: UIView!
    
    @IBOutlet weak var textOptionViewLabel: UILabel!
    @IBOutlet weak var textOptionViewBtn: UIButton!
    @IBAction func textOptionViewBtnClicked(_ sender: UIButton) {
        let popoverVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorPickerViewController") as! ColorPickerViewController
        popoverVC.modalPresentationStyle = .popover
        popoverVC.preferredContentSize = CGSize(width: 284, height: 430)
        if let popoverController = popoverVC.popoverPresentationController {
            popoverController.sourceView = sender
            popoverController.sourceRect = CGRect(x: 0, y: 0, width: 85, height: 30)
            popoverController.permittedArrowDirections = .any
            popoverVC.didSelect = {color in
                self.webView.setFontColor(id: "editor", color: color, completion: { (result, error) in
                    sender.backgroundColor = color
                })
            }
        }
        self.present(popoverVC, animated: true) {
            
        }
    }
    
    @IBOutlet weak var fontSizeView: UIView!
    
    @IBOutlet weak var fontSizeViewLabel: UILabel!
    
    @IBOutlet weak var fontSizeViewTextField: UITextField!
    @IBOutlet weak var fontSizeViewStepper: UIStepper!
    @IBAction func fontSizeViewStepperAction(_ sender: UIStepper) {
        
    }
}
