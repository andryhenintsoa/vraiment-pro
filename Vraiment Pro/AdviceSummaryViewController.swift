//
//  AdviceSummaryViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 08/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceSummaryViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var prestationLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var fileIcon: UIImageView!

    var selectedClient: [String:String]!
    var prestationDate: String!
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
            mailLabel.text = selectedClient["phone"]
            data["phone"] = selectedClient["phone"]
        }
// Prestation date
        dateLabel.text = prestationDate
        data["date"] = prestationDate
        
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSendringAdviceRequest"{
            
            print(data)
            
        }
    }
    

}
