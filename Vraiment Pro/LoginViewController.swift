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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// When "Se connecter" is clicked
    @IBAction func connect(_ sender: AnyObject) {
        print("Connect")
        spinnerLoad()
        
        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.reloadData), userInfo: nil, repeats: false)
    }

// When "Mot de passe oublié" is clicked
    @IBAction func forgottenPwd(_ sender: AnyObject) {
        print("Forgotten Password")
    }

    @IBAction func emailEndEdit(_ sender: AnyObject) {
        emailLabel.resignFirstResponder()
        pwdLabel.becomeFirstResponder()
    }
    
    @IBAction func pwdEndEdit(_ sender: AnyObject) {
        pwdLabel.resignFirstResponder()
    }
    
// MARK: - Get result of WS
    override func reloadData() {
        spinnerLoad(false)
        if(emailLabel.text == testValue[0] && pwdLabel.text == testValue[1]){
            performSegue(withIdentifier: "toMenu", sender: self)
        }
        else{
            alertUser(title: "Erreur", message: "Email ou mot de passe erroné")
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
