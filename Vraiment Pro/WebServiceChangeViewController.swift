//
//  WebServiceChangeViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/03/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class WebServiceChangeViewController: MainViewController {

    var imageToSend:UIImage?
    @IBOutlet weak var docsTypeTableView: UITableView!
    
    var docsTypeList:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docsTypeTableView.delegate = self
        
        //imagePreview.image = imageToSend
        docsTypeList = Utils.getListDocsType(.webservice)
        
        docsTypeTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        //self.dismiss(animated: true, completion: nil)
    }
    
    func changeWS(with domain:String) {
        Utils.wsDomain = domain
    }
    
}

extension WebServiceChangeViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return docsTypeList.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let data:String = docsTypeList[indexPath.item]
        
        let cellIdentifier = "docsType"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DocsTypeTableViewCell
        
        cell.content.text = data

//        if data == Utils.wsDomain{
//            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//        }
        
        return cell
    }
}

extension WebServiceChangeViewController : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        var data:String = ""
        
        data = docsTypeList[indexPath.item]
        
        self.alertConfirmUser(title: "Changer webservice", message: "Voulez-vous changer\n le webservice en :\n \(data) ?", customConfirmText: "Accepter") { (_) in
            self.changeWS(with: data)
            self.performSegue(withIdentifier: "logOut", sender:self)
        }
        
    }
}
