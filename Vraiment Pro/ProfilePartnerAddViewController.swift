//
//  ProfilePartnerAddViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ProfilePartnerAddViewController: UIViewController {
    
    @IBOutlet weak var partnerTableView: UITableView!

    var partnerData : [Dictionary<String,String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        partnerTableView.delegate = self
        createData()
        partnerTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Poser les informations de chaque menu
    func createData(){
        partnerData.append(["name":"Test 1","statut":"0",
                            "id":"1"])
        partnerData.append(["name":"Test 2","statut":"0",
                            "id":"2"])
        partnerData.append(["name":"Test 3","statut":"1",
                            "id":"3"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func choosePartners(_ sender: AnyObject) {
        let n = self.navigationController?.viewControllers.count
        let previousVC = self.navigationController?.viewControllers[n!-2] as! ProfileViewController
        var selectedPartners: [[String:String]] = []
        
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
        
        cell.name.text = data["name"]!
        
        let rate = (Double(arc4random()) / 0xFFFFFFFF) * 5
        cell.rate.rating = rate
        print("Rating = \(rate)")
        
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
