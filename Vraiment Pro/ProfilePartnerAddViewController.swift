//
//  ProfilePartnerAddViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ProfilePartnerAddViewController: MainViewController {
    
    @IBOutlet weak var partnerTableView: UITableView!
    @IBOutlet weak var validateButton: UIButton!

    var partnerData : [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateButton.setTitle("Valider", for: .normal)
        
        partnerTableView.delegate = self
        Webservice.partners(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Poser les informations de chaque menu
    func createData(){
        partnerData.append(["nom":"Test 1","prenom":"0",
                            "id":"1"])
        partnerData.append(["nom":"Test 2","prenom":"0",
                            "id":"2"])
        partnerData.append(["nom":"Test 3","prenom":"1",
                            "id":"3"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }
    
    @IBAction func choosePartners(_ sender: AnyObject) {
        let n = self.navigationController?.viewControllers.count
        let previousVC = self.navigationController?.viewControllers[n!-2] as! ProfileViewController
        var selectedPartners: [[String:Any]] = []
        
        for cellItem in partnerTableView.visibleCells {
            let cell = cellItem as! ProfilePartnerAddTableViewCell
            
            if cell.checkBox.isSelected{
                selectedPartners.append(partnerData[(partnerTableView.indexPath(for: cell)?.row)!])
            }
        }
        previousVC.selectedPartners = selectedPartners
        
        print(previousVC.selectedPartners)
        
        closeController(sender)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            if let status = data["status"] as? Bool{
            
                if !status{
                    alertUser(title: "Pas de données", message: nil)
                    normalConnection = true
                    return
                }
                
                partnerData = data["data"] as! [[String:Any]]
                
                let partnersCount = CGFloat(partnerData.count)
                
                if partnersCount <= 4{
                    let headerHeight = (partnerTableView.frame.size.height - ( partnerTableView.rowHeight * partnersCount )) / 2
                    
                    partnerTableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
                }
                
                partnerTableView.reloadData()
                
                normalConnection = true
            }
            else{
                normalConnection = true
                alertUser(title: "Pas de données", message: nil)
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard")
        }
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

extension ProfilePartnerAddViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return partnerData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "partnerItem", for: indexPath) as! ProfilePartnerAddTableViewCell
        let data = partnerData[indexPath.item]
        
        var nameToDisplay = ""
        if let firstName = data["prenom"] as? String{
            nameToDisplay += firstName
        }
        if let surName = data["nom"] as? String{
            if nameToDisplay != ""{
                nameToDisplay += " "
            }
            nameToDisplay += surName
        }
        
        cell.name.text = nameToDisplay
        
        let rate = (Double(arc4random()) / 0xFFFFFFFF) * 5
        cell.rate.rating = rate
        print("Rating = \(rate)")
        
        cell.function.text = "Metier"
        
        cell.checkBox.isMultipleSelectionEnabled = true
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1).cgColor
        
        return cell
    }
}

extension ProfilePartnerAddViewController : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let cell = tableView.cellForRow(at: indexPath) as! ProfilePartnerAddTableViewCell
    
        cell.checkBox.isSelected = !(cell.checkBox.isSelected)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
