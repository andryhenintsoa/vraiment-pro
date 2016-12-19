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
    var selectedPartners: [[String:String]] = []
    
    var sendingProfileType: SendingProfileType = .selfProfile
    
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
        closeKeyboards(nil)
        performSegue(withIdentifier: "toClientChoose", sender: nil)
        if let textField = sender as? UITextField{
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func chooseProfileType(_ sender: UIButton) {
        closeKeyboards(nil)
        if(sender == profileSelfButton){
            sendingProfileType = .selfProfile
            setActive(sender, otherButton: profilePartnerButton)
        }
        else if(sender == profilePartnerButton){
            sendingProfileType = .partnersProfile
            setActive(sender, otherButton: profileSelfButton)
        }
        else{
            
        }
    }
    
    @IBAction func chooseSendingType(_ sender: UIButton) {
        closeKeyboards(nil)
        if selectedClient == nil {
            self.alertUser(title: "Erreur", message: "Vous devez selectionner un utilisateur")
        }
        else if( sendingProfileType == .partnersProfile && selectedPartners.count == 0){
            self.alertUser(title: "Erreur", message: "Vous devez selectionner les partenaires dont vous voulez envoyer le profil")
        }
        else{
            var data:[String:Any] = [:]
            if(sender.currentTitle == "SMS"){
                print("SMS")
                if phoneLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez poser le numéro du client")
                }
                else{
                    //sendingType = .sms
                    self.selectedClient?["phone"] = phoneLabel.text
                    data = self.selectedClient!
                    data["sendingType"] = "SMS"
                    data["sendingProfile"] = sendingProfileType.rawValue
                    
                    var message = "SMS \(sendingProfileType.rawValue)"
                    if(sendingProfileType == .partnersProfile){
                        message += " \(selectedPartners.count)"
                        data["profile"] = self.selectedPartners
                    }
                    
                    print(data)
                    self.alertUser(title: "Envoi", message: message)
                }
            }
            else if(sender.currentTitle == "Mail"){
                print("Mail")
                if mailLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez poser l'adresse email du client")
                }
                else{
                    //sendingType = .mail
                    self.selectedClient?["mail"] = phoneLabel.text
                    data = self.selectedClient!
                    data["sendingType"] = "Mail"
                    data["sendingProfile"] = sendingProfileType.rawValue
                    
                    var message = "Mail \(sendingProfileType.rawValue)"
                    if(sendingProfileType == .partnersProfile){
                        message += " \(selectedPartners.count)"
                        data["profile"] = self.selectedPartners
                    }
                    
                    print(data)
                    self.alertUser(title: "Envoi", message: message)
                }
            }
        }
    }
    
    @IBAction func closeKeyboards(_ sender: UIButton?) {
        nameLabel.resignFirstResponder()
        phoneLabel.resignFirstResponder()
        mailLabel.resignFirstResponder()
    }
    
    
    func setActive(_ button: UIButton, otherButton: UIButton? = nil){
        button.backgroundColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        
        otherButton?.backgroundColor = UIColor.white
        otherButton?.setTitleColor(UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1), for: .normal)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseClient" {
            let destination = segue.destination as? ChooseClientViewController
            destination?.textToDisplay = self.nameLabel.text!
        }
    }
 

}
