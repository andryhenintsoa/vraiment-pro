//
//  AdviceWaitingMediationViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingMediationViewController: MainViewController {
    
    @IBOutlet weak var waitingTableView: UITableView!
    
    var waitingData : [Dictionary<String,Any>] = []
    
    var noDataViewController:ResultViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createData()
//        waitingTableView.reloadData()
        Webservice.adviceWaitingMediation(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Poser les informations de chaque menu
    func createData(){
        waitingData.append(["name":"Xavier","message":"Publier une photo","rating":"\((Double(arc4random()) / 0xFFFFFFFF) * 5)",
                            "id":"1"])
        waitingData.append(["name":"Alexandre","message":"Publier Avant / Après, roufr aar g zrg zeronfv. Odpvke g ngjnz tng fd,fgn zjtg jzht aevb dbdf hab gare. ahebjbhrf qbr fnq b rfha zr","rating":"\((Double(arc4random()) / 0xFFFFFFFF) * 5)",
                            "id":"2"])
        waitingData.append(["name":"Benoit","message":"Publier un document","rating":"\((Double(arc4random()) / 0xFFFFFFFF) * 5)",
                            "id":"3"])
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
            
//            if !status{
//                alertUser(title: "Pas de données", message: nil)
//                normalConnection = true
//                return
//            }
            
            if !status{
                //alertUser(title: "Pas de données", message: nil)
                normalConnection = true
                
                //let n = self.navigationController?.viewControllers.count
                //let previousVC = self.navigationController?.viewControllers[n!-2] as! AdviceWaitingViewController
                
                //_ = navigationController?.popViewController(animated: false)
                
                //previousVC.performSegue(withIdentifier: "noData", sender: nil)
                
                displayNoDataViewController()
                return
            }
            
            waitingData = data["data"] as! [[String:Any]]
            
            waitingData.sort(by: { (element1, element2) -> Bool in
                var mois  = ""
                mois = element1["mois_prest"] as! String
                mois = mois.replacingOccurrences(of: " ", with: "")
                mois = (mois.characters.count < 2) ? "0\(mois)" : mois
                
                let date1 = (element1["annee_prest"]! as? String)! + mois
                
                mois = element2["mois_prest"] as! String
                mois = mois.replacingOccurrences(of: " ", with: "")
                mois = (mois.characters.count < 2) ? "0\(mois)" : mois
                
                let date2 = (element2["annee_prest"]! as? String)! + mois
                
                return date1 < date2
            })
            
            //images.sorted({ $0.fileID > $1.fileID })
            
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
        if segue.identifier == "toMediationDetail" {
            let destination = segue.destination as? AdviceWaitingMediationDetailViewController
            
            let data = waitingData[(waitingTableView.indexPathForSelectedRow?.row)!]
            
            destination?.selectedAdviceMediation = data
            
        }
    }
    
}

extension AdviceWaitingMediationViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return waitingData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "waitingItem", for: indexPath) as! AdviceWaitingMediationTableViewCell
        var data = waitingData[indexPath.item]
        
        //        cell.nameLabel.text = (data["prenom"] as! String) + " " + (data["nom"] as! String)
//        cell.nameLabel.text = (data["client_nom"] as! String)
        
        if let client_nom = data["client_nom"]! as? String{
            cell.nameLabel.text = client_nom
        }
        
        cell.contentLabel.text = data["nature_prest"] as? String
        
        var mois = data["mois_prest"] as! String
        mois = mois.replacingOccurrences(of: " ", with: "")
        mois = (mois.characters.count < 2) ? "0\(mois)" : mois
        
        data["date"] = mois + "/" + (data["annee_prest"]! as? String)!
        cell.dateLabel.text = data["date"]! as? String
        
        if let note = data["note"] as? Int{
            cell.ratingElement.rating = Double(note)
        }
        else{
            cell.ratingElement.rating = 0
        }
        
        
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1).cgColor
        
        return cell
    }
}
