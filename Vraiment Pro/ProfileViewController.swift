//
//  ProfileViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 08/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ProfileViewController: MainViewController {
    @IBOutlet weak var profileSelfButton: UIButton!
    @IBOutlet weak var profilePartnerButton: UIButton!
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!

    var selectedClient: [String:String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectClient(_ sender: AnyObject) {
        performSegue(withIdentifier: "toClientChoose", sender: nil)
        if let textField = sender as? UITextField{
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func chooseProfileType(_ sender: UIButton) {
        if(sender == profileSelfButton){
            setActive(sender, otherButton: profilePartnerButton)
        }
        else if(sender == profilePartnerButton){
            setActive(sender, otherButton: profileSelfButton)
        }
        else{
            
        }
    }
    
    @IBAction func chooseSendingType(_ sender: UIButton) {
        if selectedClient == nil {
            self.alertUser(title: "Erreur", message: "Vous devez selectionner un utilisateur")
        }
        else{
            if(sender.currentTitle == "SMS"){
                print("SMS")
            }
            else if(sender.currentTitle == "Mail"){
                print("Mail")
            }
        }
    }
    
    func setActive(_ button: UIButton, otherButton: UIButton? = nil){
        button.backgroundColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        
        otherButton?.backgroundColor = UIColor.white
        otherButton?.setTitleColor(UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1), for: .normal)
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
