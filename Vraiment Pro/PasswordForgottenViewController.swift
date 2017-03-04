//
//  PasswordForgottenViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class PasswordForgottenViewController: MainViewController {
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var idUser:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Veuillez saisir votre adresse mail"
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        addBorderToLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkMail(_ sender: Any) {
        if emailLabel.text == ""{
            self.alertUser(title: "Erreur", message: "Veuillez renseigner\n l'adresse mail")
        }
        else{
            emailLabel.resignFirstResponder()
            Webservice.pwdForgottenGetCode(self, data: ["mail":emailLabel.text!])
            //self.performSegue(withIdentifier: "toCodeConfirmation", sender: self)
        }
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addBorderToLabel(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: emailLabel.frame.size.height - width + 1, width:  emailLabel.frame.size.width, height: emailLabel.frame.size.height)
        
        border.borderWidth = width
        emailLabel.layer.addSublayer(border)
        emailLabel.layer.masksToBounds = true
    }

    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let status = data["status"] as? Bool{
                if status{
                    
                    if let dataUser = data["data"] as? [String:Any]{
                        print(dataUser)
                        
                        idUser = dataUser["id"] as! Int
                        
                        performSegue(withIdentifier: "toCodeConfirmation", sender: self)
                    }
                    
                }
                else{
                    alertUser(title: "Erreur", message: "Cet e-mail ne correspond/n à aucun utilisateur connu")
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard")
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCodeConfirmation" {
            let destination = segue.destination as! PasswordForgottenCodeConfirmationViewController
            destination.idUser = self.idUser
        }
    }

}
