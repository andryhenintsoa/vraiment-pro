//
//  PasswordForgottenCodeConfirmationViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 24/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class PasswordForgottenCodeConfirmationViewController: MainViewController {

    // IBOutlet des deux champs
    @IBOutlet weak var codeLabel: UITextField!
    
    var idUser:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeLabel.attributedPlaceholder = NSAttributedString(string: "Code de confirmation", attributes: [NSFontAttributeName: codeLabel.font!.italic() ,NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When "Verifier" is clicked
    @IBAction func confirmCode(_ sender: AnyObject) {
        closeKeyboards(sender)
        
        let code = codeLabel.text
        
        if(code == ""){
            self.alertUser(title: "Erreur", message: "Veuillez renseigner\n le code de confirmation")
        }
        else{
            //performSegue(withIdentifier: "toChangePwd", sender: self)
            
            Webservice.pwdForgottenConfirmCode(self, data: ["code":code!,"idUser":idUser])
        }
    }
    
    @IBAction func closeKeyboards(_ sender: AnyObject) {
        codeLabel.resignFirstResponder()
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let status = data["status"] as? Bool{
                if status{
                    
//                    if let dataUser = data["data"] as? [String:Any]{
//                        print(dataUser)
//                        
//                        idUser = dataUser["idUser"] as! Int
                        
                        performSegue(withIdentifier: "toChangePwd", sender: self)
//                    }
                    
                }
                else{
                    alertUser(title: "Erreur", message: "Ce code n'est pas\n le bon code")
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
        if segue.identifier == "toChangePwd" {
            let destination = segue.destination as! PasswordForgottenChangeViewController
            destination.idUser = self.idUser
        }
    }

}
