//
//  DocsSendDocViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class DocsSendDocViewController: MainViewController {

    var imageToSend:UIImage?
    @IBOutlet weak var docsTypeTableView: UITableView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var docsTypeTableView2: UITableView!
    
    var docsTypeList:[String] = []
    var docsTypeList2:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        docsTypeTableView.delegate = self
        docsTypeTableView2.delegate = self
        
        //imagePreview.image = imageToSend
        docsTypeList = Utils.getListDocsType(.documents)
        docsTypeList2 = Utils.getListDocsType(.qualifications)
        
        
        
        docsTypeTableView2.reloadData()
        docsTypeTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }
    
    @IBAction func closeNavController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sendDoc(withType:String) {
        Webservice.docsSendDoc(self, data: ["type":withType], imageToSend : imageToSend)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
                    performSegue(withIdentifier: "toResult", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Echec de l'envoi", completion: { (action) in
                        self.closeController(action)
                    })
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard", completion: { (action) in
                self.closeController(action)
            })
        }
    }
    
    override func reloadMyViewWithError() {
        alertUser(title: "Erreur d'upload", message: "Veuillez réessayer plus tard")
        closeController(self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            let destination = segue.destination as? ResultViewController
            
            destination?.textToDisplay = "Votre document a bien été envoyé\n Il sera publié après authentification"
        }
    }
    
}

extension DocsSendDocViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        var result = 0
        
        if tableView == docsTypeTableView{
            result = docsTypeList.count
        }
        else if tableView == docsTypeTableView2{
            result = docsTypeList2.count
        }
        
        return result
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var data:String = ""
        
        if tableView == docsTypeTableView{
            data = docsTypeList[indexPath.item]
        }
        else if tableView == docsTypeTableView2{
            data = docsTypeList2[indexPath.item]
        }
        
        var cellIdentifier = "docsType"
        
        if(data == "DOCUMENTS" || data == "QUALIFICATIONS / CERTIFICATIONS"){
            cellIdentifier = "docsTypeTitle"
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DocsTypeTableViewCell
        
        cell.content.text = data
        
        return cell
    }
}

extension DocsSendDocViewController : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        var data:String = ""
        
        if tableView == docsTypeTableView{
            data = docsTypeList[indexPath.item]
        }
        else if tableView == docsTypeTableView2{
            data = docsTypeList2[indexPath.item]
        }
        
        //sendDoc(withType: data)
        
        self.alertConfirmUser(title: "Publier ce document", message: nil, customConfirmText: "Envoyer") { (_) in
            self.sendDoc(withType: data)
        }
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
}

