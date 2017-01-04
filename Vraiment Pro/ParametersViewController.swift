//
//  ParametersViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ParametersViewController: MainViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        
        var nameToDisplay = ""
        var addressToDisplay = ""
        var mailToDisplay = ""
        var phoneToDisplay = ""
        
        let firstName = userDefaults.string(forKey: prefKey.userFirstName.rawValue)
        let surName = userDefaults.string(forKey: prefKey.userSurName.rawValue)
        let address = userDefaults.string(forKey: prefKey.userAddress.rawValue)
        let mail = userDefaults.string(forKey: prefKey.userMail.rawValue)
        let phone = userDefaults.string(forKey: prefKey.userPhone.rawValue)
        
        if firstName != nil{
            nameToDisplay += firstName!
        }
        if surName != nil{
            if nameToDisplay != ""{
                nameToDisplay += " "
            }
            nameToDisplay += surName!
        }
        if address != nil{
            addressToDisplay = address!
        }
        if mail != nil{
            mailToDisplay = mail!
        }
        if phone != nil{
            phoneToDisplay = phone!
        }
        
        nameLabel.text = nameToDisplay
        addressLabel.text = addressToDisplay
        phoneLabel.text = phoneToDisplay
        mailLabel.text = mailToDisplay
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
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
