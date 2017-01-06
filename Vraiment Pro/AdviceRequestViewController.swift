//
//  AdviceRequestViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 08/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceRequestViewController: MainViewController, UITextFieldDelegate {
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ouLabel: UILabel!
    
    var activeField: UITextField?
    
    var selectedClient: [String:String]?
    var sendingType: SendingType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ouLabel.text = "ou"
        
        phoneLabel.delegate = self
        mailLabel.delegate = self
        
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
        let _ = navigationController?.popViewController(animated: true)
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
    
    @IBAction func choosePrestation(_ sender: UIButton) {
        closeKeyboards(nil)
        if selectedClient == nil {
            self.alertUser(title: "Erreur", message: "Vous devez renseigner le nom du client")
        } else {
            if(sender.currentTitle == "SMS"){
                print("SMS")
                if phoneLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez renseigner le numéro du client")
                }
                else{
                    sendingType = .sms
                    self.selectedClient?["phone"] = phoneLabel.text
                    performSegue(withIdentifier: "toPrestation", sender: sender)
                }
            }
            else if(sender.currentTitle == "Mail"){
                print("Mail")
                if mailLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez renseigner l'adresse mail du client")
                }
                else{
                    sendingType = .mail
                    self.selectedClient?["mail"] = mailLabel.text
                    performSegue(withIdentifier: "toPrestation", sender: sender)
                }
            }
        }
    }
    
    @IBAction func endEditing(_ sender: Any) {
        closeKeyboards(nil)
    }
    
    @IBAction func closeKeyboards(_ sender: UIButton?) {
        nameLabel.resignFirstResponder()
        phoneLabel.resignFirstResponder()
        mailLabel.resignFirstResponder()
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
        
//        self.scrollView.scrollRectToVisible(mailLabel.superview!.frame, animated: true)
        
        self.scrollView.scrollRectToVisible(mailLabel.frame, animated: true)
        
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
        closeKeyboards(nil)
        
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPrestation" {
            let destination = segue.destination as? AdvicePrestationViewController
            destination?.selectedClient = self.selectedClient
            destination?.sendingType = self.sendingType
        }
        else if segue.identifier == "toChooseClient" {
            let destination = segue.destination as? ChooseClientViewController
            destination?.textToDisplay = self.nameLabel.text!
        }
        
    }
 

}
