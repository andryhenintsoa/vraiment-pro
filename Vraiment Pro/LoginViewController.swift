//
//  LoginViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 05/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class LoginViewController: MainViewController {
    
    //let testValue = ["test","123456"]
    let testValue = ["",""]
    
// IBOutlet des deux champs
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var pwdLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSFontAttributeName: emailLabel.font!.italic() ,NSForegroundColorAttributeName: UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1) ])
            
        pwdLabel.attributedPlaceholder = NSAttributedString(string: "Mot de passe", attributes: [NSFontAttributeName: pwdLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1) ])
        
        let userDefaults: UserDefaults = UserDefaults.standard

        if userDefaults.string(forKey: prefKey.userKey.rawValue) != nil{
            Utils.userKey = userDefaults.string(forKey: prefKey.userKey.rawValue)!
            Utils.userId = userDefaults.integer(forKey: prefKey.userId.rawValue)
            
//            print("Utils.userKey : \(Utils.userKey)")
//            print("Utils.userId : \(Utils.userId)")
        }
        
// For tests
//        emailLabel.text = "rjeanlaza@gmail.com"
//        pwdLabel.text = "123456"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(Utils.userKey != "" && Utils.userId != 0){
            performSegue(withIdentifier: "toMenu", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// When "Se connecter" is clicked
    @IBAction func connect(_ sender: AnyObject) {
        print("Connect")
        //spinnerLoad()
        
        let email = emailLabel.text
        let mdp = pwdLabel.text
        
        if(email == "" || mdp == ""){
            spinnerLoad(false)
            alertUser(title: "Informations manquantes", message: "Vous devez fournir une adresse email et un mot de passe")
        }
        else{
            Webservice.authentification(self, email: email!, mdp: mdp!)
        }
        
//        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.reloadMyView), userInfo: nil, repeats: false)
    }

// When "Mot de passe oublié" is clicked
    @IBAction func forgottenPwd(_ sender: AnyObject) {
        print("Forgotten Password")
    }

// When end editing for the two textfields
    @IBAction func emailEndEdit(_ sender: AnyObject) {
        emailLabel.resignFirstResponder()
        pwdLabel.becomeFirstResponder()
    }
    
    @IBAction func pwdEndEdit(_ sender: AnyObject) {
        pwdLabel.resignFirstResponder()
    }
    
// Logging out the account
    @IBAction func logOut(sender: UIStoryboardSegue) {
        
        self.clearAccountPreferences()
        
        Utils.userKey = ""
        Utils.userId = 0
    }
    
// MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let loginStatus = data["status"] as? Bool{
                if loginStatus{
                    
                    if let dataUser = data["data"] as? [String:Any]{
                        //userDefaults.setValuesForKeys(dataUser)
                        
                        self.saveAccountPreferences(dataUser)
                    }
                    

                    performSegue(withIdentifier: "toMenu", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Email et/ou mot de passe erroné")
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard")
        }
    }
    
    private func saveAccountPreferences(_ dataUser:[String:Any]) {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        userDefaults.set(dataUser["id"], forKey: prefKey.userId.rawValue)
        userDefaults.set(dataUser["key"], forKey: prefKey.userKey.rawValue)
        userDefaults.set(dataUser["prenom"], forKey: prefKey.userFirstName.rawValue)
        userDefaults.set(dataUser["nom"], forKey: prefKey.userSurName.rawValue)
        //userDefaults.set(dataUser["adresse"], forKey: prefKey.userAddress.rawValue)
        userDefaults.set(dataUser["ville"], forKey: prefKey.userCity.rawValue)
        userDefaults.set(dataUser["email"], forKey: prefKey.userMail.rawValue)
        userDefaults.set(dataUser["compte"], forKey: prefKey.userAccount.rawValue)
        userDefaults.set(dataUser["tel_mobile"], forKey: prefKey.userPhone.rawValue)
        userDefaults.set(dataUser["civilite"], forKey: prefKey.userCivility.rawValue)
        
        
        
        userDefaults.synchronize()
    }
    
    func clearAccountPreferences() {
        let userDefaults: UserDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: prefKey.userId.rawValue)
        userDefaults.removeObject(forKey: prefKey.userKey.rawValue)
        userDefaults.removeObject(forKey: prefKey.userFirstName.rawValue)
        userDefaults.removeObject(forKey: prefKey.userSurName.rawValue)
        userDefaults.removeObject(forKey: prefKey.userAddress.rawValue)
        userDefaults.removeObject(forKey: prefKey.userCity.rawValue)
        userDefaults.removeObject(forKey: prefKey.userMail.rawValue)
        userDefaults.removeObject(forKey: prefKey.userAccount.rawValue)
        userDefaults.removeObject(forKey: prefKey.userPhone.rawValue)
        userDefaults.removeObject(forKey: prefKey.userCivility.rawValue)
        
        userDefaults.synchronize()
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
