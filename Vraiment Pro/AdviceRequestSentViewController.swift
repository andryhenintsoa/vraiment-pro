//
//  AdviceRequestSentViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 04/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class AdviceRequestSentViewController: MainViewController {

    @IBOutlet weak var dataTableView: UITableView!
    
    var adviceSent : [Dictionary<String,Any>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Webservice.adviceSent(self)
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
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            let status = data["status"] as! Bool
            
            if !status{
                alertUser(title: "Pas de données", message: nil)
                normalConnection = true
                return
            }
            
            adviceSent = data["data"] as! [[String:Any]]
            //adviceSent.reverse()
            
            let dataCount = CGFloat(adviceSent.count)
            
            if dataCount <= 4{
                let headerHeight = (dataTableView.frame.size.height - ( dataTableView.rowHeight * dataCount )) / 2
                
                dataTableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
            }
            
            dataTableView.reloadData()
            
            normalConnection = true
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

extension AdviceRequestSentViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return adviceSent.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "waitingItem", for: indexPath) as! AdviceWaitingBillTableViewCell
        let data = adviceSent[indexPath.item]
        
        //cell.contentLabel.text = data["prenom"]! + " " + data["nom"]!
//        cell.nameLabel.text = (data["client_nom"] as! String)
        
        if let client_nom = data["client_nom"]! as? String{
            cell.nameLabel.text = client_nom
        }
        
        var mois = data["mois_prest"] as! String
        mois = mois.replacingOccurrences(of: " ", with: "")
        mois = (mois.characters.count < 2) ? "0\(mois)" : mois
        
        cell.dateLabel.text = mois + "/" + (data["annee_prest"] as! String)
        cell.contentLabel.text = data["nature_prest"] as? String
        cell.contentLabel.sizeToFit()
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1).cgColor
        
        return cell
    }
}
