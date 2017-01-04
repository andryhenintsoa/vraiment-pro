//
//  AdviceSummaryViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 08/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceSummaryViewController: MainViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var mailIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var prestationLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var fileIcon: UIImageView!

    var selectedClient: [String:String]!
    var prestationDate: String!
    var prestationMonth: String!
    var prestationYear: String!
    var prestationNature: String!
    var sendingType: SendingType!
    var joiningBillOption: JoiningBillOption!
    var imageToSend:UIImage?
    var imageName:String = ""
    
    var data:[String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
// Name
        nameLabel.text = selectedClient["name"]
        data["name"] = selectedClient["name"]
        
// Sending Type
        data["sendingType"] = sendingType.rawValue
        if sendingType == .mail {
            mailLabel.text = selectedClient["mail"]
            data["mail"] = selectedClient["mail"]
        } else {
            mailIcon.image = UIImage(named: "ic_cellphone_android")
            mailLabel.text = selectedClient["phone"]
            data["phone"] = selectedClient["phone"]
        }
// Prestation date
        dateLabel.text = prestationDate
        data["date"] = prestationDate
        data["prestationMonth"] = prestationMonth
        data["prestationYear"] = prestationYear
        
// Prestation nature
        prestationLabel.text = prestationNature
        data["prestation"] = prestationNature
        
// Joining Bill
        if joiningBillOption == .now {
            data["withFile"] = "yes"
            imageName = "\(prestationNature!)-\(prestationDate!).jpg"
            fileLabel.text = imageName
            data["fileName"] = imageName
        } else {
            data["withFile"] = "no"
            fileLabel.text = "Plus tard"
            fileLabel.textColor = UIColor.red
            fileIcon.image = UIImage(named: "ic_warning")
        }
        
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

    @IBAction func sendAdvice(_ sender: Any) {
        print(data)
        Webservice.adviceSendAdvice(self, data: data, imageToSend : imageToSend)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
                    performSegue(withIdentifier: "toSendingAdviceRequest", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Echec de l'envoi")
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSendingAdviceRequest"{
            
            print(data)
            
        }
    }
    

}
