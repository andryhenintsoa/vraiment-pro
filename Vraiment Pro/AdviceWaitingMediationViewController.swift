//
//  AdviceWaitingMediationViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingMediationViewController: UIViewController {
    
    @IBOutlet weak var waitingTableView: UITableView!
    
    var waitingData : [Dictionary<String,String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createData()
        waitingTableView.reloadData()
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
        let data = waitingData[indexPath.item]
        
        cell.nameLabel.text = data["name"]!
        
        cell.contentLabel.text = data["message"]!
        cell.contentLabel.sizeToFit()
        
        cell.ratingElement.rating = Double(data["rating"]!)!
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1).cgColor
        
        return cell
    }
}
