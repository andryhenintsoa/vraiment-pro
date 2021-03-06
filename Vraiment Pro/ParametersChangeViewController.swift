//
//  ParametersChangeViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ParametersChangeViewController: MainViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    
    @IBOutlet weak var pwdOldLabel: UITextField!
    @IBOutlet weak var pwdNew1Label: UITextField!
    @IBOutlet weak var pwdNew2Label: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pwdOldLabel.delegate = self
        pwdNew1Label.delegate = self
        pwdNew2Label.delegate = self
        
        registerForKeyboardNotifications()
        
        let userDefaults = UserDefaults.standard
        
        var nameToDisplay = ""
        var addressToDisplay = ""
        var mailToDisplay = ""
        var phoneToDisplay = ""
        
        let userBusiness = userDefaults.string(forKey: prefKey.userBusiness.rawValue)
        //        let firstName = userDefaults.string(forKey: prefKey.userFirstName.rawValue)
        //        let surName = userDefaults.string(forKey: prefKey.userSurName.rawValue)
        let address = userDefaults.string(forKey: prefKey.userAddress.rawValue)
        let city = userDefaults.string(forKey: prefKey.userCity.rawValue)
        let mail = userDefaults.string(forKey: prefKey.userMail.rawValue)
        let phone = userDefaults.string(forKey: prefKey.userPhone.rawValue)
        
        //        if firstName != nil{
        //            nameToDisplay += firstName!
        //        }
        //        if surName != nil{
        //            if nameToDisplay != ""{
        //                nameToDisplay += " "
        //            }
        //            nameToDisplay += surName!
        //        }
        
        if userBusiness != nil{
            nameToDisplay += userBusiness!
        }
        if address != nil{
            addressToDisplay = address!
        }
        if city != nil{
            if addressToDisplay != ""{
                addressToDisplay += "\n"
            }
            addressToDisplay += city!
        }
        
        if mail != nil{
            mailToDisplay = mail!
        }
        if phone != nil{
            
            phoneToDisplay = NumberFormatter.format(phone!, withSpace: true)
            
            //            var tempData = ""
            //            var count = 0
            //            for char in phone!.characters{
            //                if count % 2 == 0 && count != 0{
            //                    tempData.append(" ")
            //                }
            //                tempData.append(char)
            //                count += 1
            //            }
            //
            //            phoneToDisplay = tempData
        }
        
        nameLabel.text = (nameToDisplay == "") ? "Nom de l'entreprise" : nameToDisplay
        addressLabel.text = (addressToDisplay == "") ? "Adresse postale\nde l'utilisateur" : addressToDisplay
        phoneLabel.text = phoneToDisplay
        mailLabel.text = mailToDisplay
        
        pwdOldLabel.attributedPlaceholder = NSAttributedString(string: "Ancien mot de passe", attributes: [NSFontAttributeName: pwdOldLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
        pwdNew1Label.attributedPlaceholder = NSAttributedString(string: "Nouveau mot de passe", attributes: [NSFontAttributeName: pwdNew1Label.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
        pwdNew2Label.attributedPlaceholder = NSAttributedString(string: "Confirmer le nouveau mot de passe", attributes: [NSFontAttributeName: pwdNew2Label.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
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
    
    @IBAction func performChanges(_ sender: Any) {
        Webservice.getPreviousPwd(self, data:["pwd":pwdOldLabel.text!])
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
        
        var toFocus = pwdNew2Label.superview!.frame
        toFocus.origin.y += pwdNew2Label.superview!.superview!.frame.origin.y
        
        self.scrollView.scrollRectToVisible(toFocus, animated: true)
        
        self.scrollView.isScrollEnabled = false
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
        pwdOldLabel.resignFirstResponder()
        pwdNew1Label.resignFirstResponder()
        pwdNew2Label.resignFirstResponder()
        
        if textField == pwdOldLabel{
            pwdNew1Label.becomeFirstResponder()
        }
        else if textField == pwdNew1Label{
            pwdNew2Label.becomeFirstResponder()
        }
        else{
            pwdNew2Label.resignFirstResponder()
        }
        
        
        return true
    }

    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            print("param \(param)")
            print("data \(data)")
            
            let status = data["status"] as! Bool
            
            print(status)
            
            if !status{
                
                if let dataKey = param["dataKey"] as? String{
                    if dataKey == "oldPwd"{
                        alertUser(title: "Erreur", message: "Le mot de passe que vous avez écrit\n ne correspond pas au votre")
                    }
                    
                    else if dataKey == "newPwd"{
                        alertUser(title: "Erreur", message: "Le changement de mot de passe\n n'a pas été effectué")
                    }
                }
                
                normalConnection = true
                return
            }
            
            if let dataKey = param["dataKey"] as? String{
                if dataKey == "oldPwd"{
                    
                    if pwdNew1Label.text == ""{
                        alertUser(title: "Erreur", message: "Le nouveau mot de passe\n est vide")
                    }
                    
                    else if pwdNew1Label.text != pwdNew2Label.text{
                        alertUser(title: "Erreur", message: "Veuillez revérifier le nouveau\n mot de passe")
                    }
                    else{
                        Webservice.changePwd(self, data: ["pwd":pwdNew1Label.text!])
                    }
                }
                    
                else if dataKey == "newPwd"{
                    alertUser(title: "Succès", message: "Le mot de passe a été changé\n avec succès", completion: { (_) in
                            self.performSegue(withIdentifier: "toHome", sender: nil)
                        })
                }
            }
            
            else{
                
            }
            
            
            
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
