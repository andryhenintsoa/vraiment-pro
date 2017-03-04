//
//  PasswordForgottenChangeViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 25/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

import UIKit

class PasswordForgottenChangeViewController: MainViewController, UITextFieldDelegate {
    @IBOutlet weak var pwdNew1Label: UITextField!
    @IBOutlet weak var pwdNew2Label: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var idUser:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pwdNew1Label.delegate = self
        pwdNew2Label.delegate = self
        
        registerForKeyboardNotifications()
        
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
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }
    
    @IBAction func performChanges(_ sender: Any) {
        
        pwdNew1Label.resignFirstResponder()
        pwdNew2Label.resignFirstResponder()
        
        let pwd = pwdNew1Label.text!
        let pwd2 = pwdNew2Label.text!
        
        if pwd == "" || pwd2 == ""{
            self.alertUser(title: "Erreur", message: "Veuillez renseigner\n tous les champs")
        }
        else if pwd != pwd2{
            self.alertUser(title: "Erreur", message: "Les champs ne sont pas\n identiques")
        }
        else{
            //performSegue(withIdentifier: "logOut", sender: nil)
            Webservice.pwdForgottenChange(self, data:["pwd":pwd,"idUser":idUser])
        }
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
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool{
        pwdNew1Label.resignFirstResponder()
        pwdNew2Label.resignFirstResponder()
        
        if textField == pwdNew1Label{
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
            
            let status = data["status"] as! Bool
            
            if !status{
                alertUser(title: "Erreur", message: "Une erreur est survenue\n lors du changement de mot de passe")
                
                normalConnection = true
                return
            }
            
            alertUser(title: "Succès", message: "Le mot de passe a été changé\n avec succès", completion:{ (_) in
                self.performSegue(withIdentifier: "logOut", sender: nil)
            })
            
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

