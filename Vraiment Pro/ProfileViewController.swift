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

    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    var selectedClient: [String:String]?
    var selectedPartners: [[String:Any]] = []
    
    var profileSend = 0
    
    var sendingProfileType: SendingProfileType = .selfProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()

        nameLabel.attributedPlaceholder = NSAttributedString(string: "Nom du client", attributes: [NSFontAttributeName: nameLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1) ])
        phoneLabel.attributedPlaceholder = NSAttributedString(string: "N° de portable", attributes: [NSFontAttributeName: phoneLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1) ])
        mailLabel.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSFontAttributeName: mailLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1) ])
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
    
    @IBAction func selectClient(_ sender: AnyObject) {
        closeKeyboards(nil)
        performSegue(withIdentifier: "toClientChoose", sender: nil)
        if let textField = sender as? UITextField{
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func chooseProfileType(_ sender: UIButton?) {
        closeKeyboards(nil)
        if(sender == profileSelfButton){
            sendingProfileType = .selfProfile
            setActive(sender!, otherButton: profilePartnerButton)
        }
        else if(sender == profilePartnerButton){
            sendingProfileType = .partnersProfile
            setActive(sender!, otherButton: profileSelfButton)
        }
        else{
            
        }
    }
    
    @IBAction func chooseSendingType(_ sender: UIButton) {
        closeKeyboards(nil)
        if selectedClient == nil {
            self.alertUser(title: "Erreur", message: "Vous renseigner le nom du client")
        }
        else if( sendingProfileType == .partnersProfile && selectedPartners.count == 0){
            self.alertUser(title: "Erreur", message: "Vous devez selectionner les partenaires dont vous voulez envoyer le profil")
        }
        else{
            var data:[String:Any] = [:]
            if(sender.currentTitle == "SMS"){
                print("SMS")
                if phoneLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez renseigner le numéro du client")
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
                    //self.alertUser(title: "Envoi", message: message)
                    Webservice.sendProfile(self, data: data)
                }
            }
            else if(sender.currentTitle == "Mail"){
                print("Mail")
                if mailLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez renseigner l'adresse email du client")
                }
                else{
                    //sendingType = .mail
                    self.selectedClient?["mail"] = mailLabel.text
                    data = self.selectedClient!
                    data["sendingType"] = "Mail"
                    data["sendingProfile"] = sendingProfileType.rawValue
                    
                    var message = "Mail \(sendingProfileType.rawValue)"
                    profileSend = 0
                    if(sendingProfileType == .partnersProfile){
                        message += " \(selectedPartners.count)"
                        data["profile"] = self.selectedPartners
                    }
                    
                    print(data)
                    //self.alertUser(title: "Envoi", message: message)
                    Webservice.sendProfile(self, data: data)
                }
            }
        }
    }
    
    @IBAction func closeKeyboards(_ sender: UIButton?) {
        nameLabel.resignFirstResponder()
        phoneLabel.resignFirstResponder()
        mailLabel.resignFirstResponder()
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
                    if(sendingProfileType == .selfProfile){
                        performSegue(withIdentifier: "toResult", sender: self)
                    }
                    else if(sendingProfileType == .partnersProfile){
                        profileSend += 1
                        if profileSend == selectedPartners.count{
                            performSegue(withIdentifier: "toResult", sender: self)
                        }
                    }
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
    
    func setActive(_ button: UIButton, otherButton: UIButton? = nil){
        button.backgroundColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        
        otherButton?.backgroundColor = UIColor.white
        otherButton?.setTitleColor(UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1), for: .normal)
    }

    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.superview!.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        closeKeyboards(nil)
        
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseClient" {
            let destination = segue.destination as? ChooseClientViewController
            destination?.textToDisplay = self.nameLabel.text!
        }
        
        else if segue.identifier == "toResult"{
            let destination = segue.destination as? ResultViewController
            if(sendingProfileType == .selfProfile){
                destination?.textToDisplay = "Votre profil a bien été envoyé"
            }
            else if(sendingProfileType == .partnersProfile){
                destination?.textToDisplay = "Profil(s) partenaire(s) bien envoyé(s)"
            }
        }
    }
 

}
