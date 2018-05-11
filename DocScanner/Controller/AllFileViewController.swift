//
//  FileViewController.swift
//  DocScanner
//
//  Created by Vivek Kumar on 5/5/18.
//  Copyright © 2018 Vivek. All rights reserved.
//

import UIKit

class AllFileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var workingDirectory : URL?
    var allFiles :[File] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.allFiles = FileUtility.shared.scanDirectory(directory: self.workingDirectory!)
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

}

extension AllFileViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allFiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fileCell")
        cell?.textLabel?.text = self.allFiles[indexPath.row].name
        return cell!
    }
    
    
    
}
