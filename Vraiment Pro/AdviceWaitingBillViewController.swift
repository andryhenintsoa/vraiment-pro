//
//  AdviceWaitingBillViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingBillViewController: ImagePickerViewController {

    @IBOutlet weak var waitingTableView: UITableView!
    
    var waitingData : [Dictionary<String,Any>] = []
    
    var noDataViewController:ResultViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingTableView.delegate = self
        
        Webservice.adviceWaitingBill(self)
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
    
    func displayNoDataViewController(){
        if (noDataViewController == nil) {
            noDataViewController = UIStoryboard.resultViewController()
            
            noDataViewController?.textToDisplay = "Vous n'avez pas \n d'avis en attente"
            
            noDataViewController?.autoHide = false
            
            view.addSubview(noDataViewController!.view!)
            
            noDataViewController!.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            addChildViewController(noDataViewController!)
            
        }
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            let status = data["status"] as! Bool
            
            if !status{
                //alertUser(title: "Pas de données", message: nil)
                normalConnection = true
//                    let n = self.navigationController?.viewControllers.count
//                    let previousVC = self.navigationController?.viewControllers[n!-2] as! AdviceWaitingViewController
//                    
//                    _ = self.navigationController?.popViewController(animated: false)
//                    
//                    previousVC.performSegue(withIdentifier: "noData", sender: nil)
                    displayNoDataViewController()
                
                return
            }
            
            waitingData = data["data"] as! [[String:Any]]
            
            let dataCount = CGFloat(waitingData.count)
            
            if dataCount <= 4{
                let headerHeight = (waitingTableView.frame.size.height - ( waitingTableView.rowHeight * dataCount )) / 2
                
                waitingTableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
            }
            //waitingData.reverse()
            waitingTableView.reloadData()
            
            normalConnection = true
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard")
        }
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSendBills"{
            let destination = segue.destination as? AdviceWaitingBillSendViewController
            
            let data = waitingData[(waitingTableView.indexPathForSelectedRow?.row)!]
            print(data)
            destination?.data = data
            
            destination?.imageToSend = self.imageToSend
            
        }
     }
    
}

extension AdviceWaitingBillViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return waitingData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "waitingItem", for: indexPath) as! AdviceWaitingBillTableViewCell
        let data = waitingData[indexPath.item]
    
        //cell.contentLabel.text = data["prenom"]! + " " + data["nom"]!
        
//        cell.nameLabel.text = (data["prenom"] as! String) + " " + (data["nom"] as! String)
        
        if let client_nom = data["client_nom"]! as? String{
            cell.nameLabel.text = client_nom
        }
        
        var mois = data["mois_prest"] as! String
        mois = (mois.characters.count < 2) ? "0\(mois)" : mois
        
        cell.dateLabel.text = mois + "/" + (data["annee_prest"] as! String)
        cell.contentLabel.text = data["nature_prest"] as? String
        cell.contentLabel.sizeToFit()
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1).cgColor
        
        return cell
    }
}

extension AdviceWaitingBillViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.segueNextName = "toSendBills"
        chooseTakingPictureMode()
    }
}
