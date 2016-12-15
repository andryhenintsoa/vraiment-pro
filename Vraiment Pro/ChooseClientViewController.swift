//
//  ChooseClientViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 10/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ChooseClientViewController: UIViewController {

    @IBOutlet weak var clientLabel: UITextField!
    @IBOutlet weak var clientTableView: UITableView!

    var clients : [Dictionary<String,String>] = []
    var clientsResearch : [Dictionary<String,String>] = []
    var selectedClient : Dictionary<String,String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createData()
        clientTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Données de test
    func createData(){
        clients.append(["name":"test","mail":"test1@xyz.xy",
                         "phone":"748930298920"])
        clients.append(["name":"essai","mail":"test12@xyz.xy",
                         "phone":"472830010038"])
        clients.append(["name":"andry","mail":"test03@xyz.xy",
                         "phone":"483029837203"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptPick(_ sender: AnyObject) {
        
        let n = self.navigationController?.viewControllers.count
        let previousVC = self.navigationController?.viewControllers[n!-2]
        
        //if selectedClient != nil{
            if let presentingVC = previousVC as? AdviceRequestViewController{
                presentingVC.nameLabel.text = selectedClient?["name"]
                presentingVC.phoneLabel.text = selectedClient?["phone"]
                presentingVC.mailLabel.text = selectedClient?["mail"]
                
                presentingVC.selectedClient = self.selectedClient
            }
            else if let presentingVC = previousVC as? ProfileViewController{
                presentingVC.nameLabel.text = selectedClient?["name"]
                presentingVC.phoneLabel.text = selectedClient?["phone"]
                presentingVC.mailLabel.text = selectedClient?["mail"]
                
                presentingVC.selectedClient = self.selectedClient
            }
            else{
                print("Error")
        }
        //}
        closeController(sender)
    }
    
    @IBAction func doSearch(_ sender: UITextField) {
        print("Text changed : \(sender.text!)")
        clientsResearch = clients.filter { client in
                return client["name"]!.lowercased().contains(sender.text!.lowercased())
            }
            
        clientTableView.reloadData()
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

extension ChooseClientViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return clientsResearch.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientItem", for: indexPath)
        let data = clientsResearch[indexPath.item]
        
        cell.textLabel?.text = data["name"]!
        cell.detailTextLabel?.text = data["mail"]!
        
        return cell
    }
}

extension ChooseClientViewController : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.selectedClient = clientsResearch[indexPath.row]
        self.clientLabel.text = clientsResearch[indexPath.row]["name"]
    }
}

