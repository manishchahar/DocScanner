//
//  BrowserViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/5/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {
    
    @IBOutlet weak var barBackButton: UIBarButtonItem!
    var storedBarItem : UIBarButtonItem?
    @IBAction func barBackButtonAction(_ sender: UIBarButtonItem) {
        returnToPreviousDirectory()
    }
    var workingDirectory : URL?
    var allFiles : [File] = []
    func returnToPreviousDirectory(){
        if(self.workingDirectory?.lastPathComponent == "DocScanner"){
        }else{
            self.workingDirectory?.deleteLastPathComponent()
            self.title = workingDirectory!.lastPathComponent.uppercased()
        }
        self.gotoDirectory(directory: self.workingDirectory!)
    }
    func gotoDirectory(directory:URL) {
        if(directory.lastPathComponent == "DocScanner"){
            self.navigationItem.leftBarButtonItem = nil
            self.title = "HOME"
        }else{
            self.navigationItem.leftBarButtonItem = self.barBackButton
            self.title = directory.lastPathComponent.uppercased()
        }
        self.workingDirectory = directory
        reloadTableData()
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        AlertUtil.shared.alertWithTextField(parent: self, title: "Add Folder", message: "Enter folder name to add new folder \n Please Avoid using characters like .,/';:!`~^@#$%&*(){}[]|", placeholder: "Folder Name", value: "", proceedTitle: "Add", cancelTitle: "Later", didProceed: { (folderName) in
            let errorMessage = FileUtility.shared.createFolder(directory: self.workingDirectory!, name: folderName)
            if(errorMessage != ""){
                self.presentAlert(title: "Failed", message: errorMessage)
            }else{
                //                self.presentAlert(title: "Success", message: "Folder added successfully!")
                self.reloadTableData()
            }
        }) {
            print("canceled")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storedBarItem = self.barBackButton
        self.navigationItem.leftBarButtonItem = nil
        // Do any additional setup after loading the view.
        self.tableView.allowsMultipleSelectionDuringEditing = false
        self.tableView.register(UINib.init(nibName: "FilesTableViewCell", bundle: nil), forCellReuseIdentifier: "FilesTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let directory = self.workingDirectory{
            self.allFiles = FileUtility.shared.scanDirectory(directory: directory)
        }else{
            self.workingDirectory = FileUtility.shared.defaultPath
            self.allFiles = FileUtility.shared.scanDirectory(directory: self.workingDirectory!)
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Navigation
    
    //     In a storyboard-based application, you will often want to do a little preparation before navigation
    var selectedDirectory : URL?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            switch identifier{
            case "CreateViewController":
                if let destinationVc = segue.destination as? CreateViewController ,let directory = self.workingDirectory{
                    destinationVc.workingDirectory = directory
                }
                break
            case "DocumentViewController":
                if let vc = segue.destination as? DocumentViewController{
                    vc.workingFilePath = self.selectedDirectory
                    vc.deleteAllImages()
                }
                break
            default :
                break
            }
        }
    }
}
extension BrowserViewController:UITableViewDelegate,UITableViewDataSource{
    func reloadTableData() {
        self.allFiles.removeAll()
        self.allFiles = FileUtility.shared.scanDirectory(directory: self.workingDirectory!)
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allFiles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FilesTableViewCell") as! FilesTableViewCell
//        cell.fileImageView.image = self.allFiles[indexPath.row].image
//        cell.titleLabel.text = self.allFiles[indexPath.row].name
//        cell.fileSizeLabel.text = self.allFiles[indexPath.row].size
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.imageView?.image = self.allFiles[indexPath.row].image
        cell.textLabel?.text = self.allFiles[indexPath.row].name
        cell.detailTextLabel?.text = self.allFiles[indexPath.row].size
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = self.allFiles[indexPath.row]
        switch  selectedFile.type{
        case .pdf:
            self.presentFile(path: selectedFile.path)
            break
        default:
            self.gotoDirectory(directory: selectedFile.url)
            break
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // action one for delete operation
        let deleteAction = self.contextualDeleteAction(forRowAt: indexPath)
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = self.contextualEditAction(forRowAt: indexPath)
        let renameAction = self.contextRenameAction(forRowAt: indexPath)
        if(self.allFiles[indexPath.row].type == FileType.folder){
            return UISwipeActionsConfiguration(actions: [renameAction])
        }else{
            return UISwipeActionsConfiguration(actions: [renameAction,editAction])
        }
    }
    
    func contextualDeleteAction(forRowAt indexPath : IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Delete") { (contextAction, sourceView, completionHandler) in
            let errorMessage = FileUtility.shared.deleteFile(url: self.allFiles[indexPath.row].url)
            if(errorMessage == ""){
                self.reloadTableData()
                completionHandler(true)
            }else{
                self.presentAlert(title: "Failed", message: errorMessage)
                completionHandler(false)
            }
        }
        action.image = UIImage(named: "delete_forever")
        action.title = "Delete"
        action.backgroundColor = UIColor.red
        return action
    }
    
    func contextualEditAction(forRowAt indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") { (contextAction, sourceView, completionHandler) in
            self.selectedDirectory = self.allFiles[indexPath.row].url
            self.performSegue(withIdentifier: "DocumentViewController", sender: self)
            completionHandler(true)
        }
        action.title = "Edit"
        action.backgroundColor = UIColor.green
        return action
    }
    
    func contextRenameAction(forRowAt indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Rename") { (contextAction, sourceView, completionHandler) in
            AlertUtil.shared.alertWithTextField(parent: self, title: "Rename", message: "Please Enter new file name to rename \n Please Avoid using characters like .,/';:!`~^@#$%&*(){}[]|", placeholder: "", value: "\(self.allFiles[indexPath.row].name!)", proceedTitle: "Rename", cancelTitle: "Later", didProceed: { (newName) in
                let selectedFile = self.allFiles[indexPath.row]
                var resultMsg = ""
                switch selectedFile.type{
                case .folder:
                    resultMsg = FileUtility.shared.renameDirectory(atPath: selectedFile.url, newName: newName)
                    break
                case .pdf:
                    resultMsg = FileUtility.shared.renameFile(atPath: selectedFile.url, newName: newName)
                    break
                default:
                    break
                }
                if(resultMsg != ""){
                    completionHandler(false)
                    self.presentAlert(title: "Failed", message: resultMsg)
                }else{
                    self.reloadTableData()
                    completionHandler(true)
                }
                completionHandler(true)
            }, didCancel: {
                completionHandler(false)
            })
        }
        action.backgroundColor = UIColor.blue
        return action
    }
}
extension BrowserViewController:UIDocumentInteractionControllerDelegate {
    func presentFile(path:String) {
        let documentInteractionController = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
        documentInteractionController.delegate = self
        documentInteractionController.presentPreview(animated: true)
    }
    //MARK: UIDocumentInteractionController delegates
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

