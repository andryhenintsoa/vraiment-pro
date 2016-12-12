//
//  ChooseClientViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 10/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ChooseClientViewController: UIViewController {

    @IBOutlet weak var clientTableView: UITableView!

    var clients : [Dictionary<String,String>] = []
    
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
        clients.append(["name":"test1","mail":"test1@xyz.xy",
                         "id":"1"])
        clients.append(["name":"test2","mail":"test12@xyz.xy",
                         "id":"2"])
        clients.append(["name":"test3","mail":"test03@xyz.xy",
                         "id":"3"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
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
        return clients.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "clientItem", for: indexPath)
        let data = clients[indexPath.item]
        
        cell.textLabel?.text = data["name"]!
        cell.detailTextLabel?.text = data["mail"]!
        
        return cell
    }
}

