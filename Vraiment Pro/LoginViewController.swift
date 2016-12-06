//
//  LoginViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 05/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
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
    
// Quand le bouton "Se connecter" est cliqué
    @IBAction func connect(_ sender: AnyObject) {
        print("Connect")
    }

// Quand le bouton "Mot de passe oublié" est cliqué
    @IBAction func forgottenPwd(_ sender: AnyObject) {
        print("Forgotten Password")
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
