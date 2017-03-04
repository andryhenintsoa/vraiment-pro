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
    @IBOutlet weak var phoneLabel: VSTextField!
    @IBOutlet weak var mailLabel: UITextField!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ouLabel: UILabel!
    
    //For custom textfield
    var num:String = ""
    var numNew:String = ""
    var numDisplay:String = ""
    
    var activeField: UITextField?
    
    var selectedClient: [String:String]?
    var selectedPartners: [[String:Any]] = []
    
    var profileSend = 0
    
    var sendingProfileType: SendingProfileType = .selfProfile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //phoneLabel.setFormatting("## ## ## ## ## ##", replacementChar : "#")
        
        ouLabel.text = "ou"
        
        registerForKeyboardNotifications()

        nameLabel.attributedPlaceholder = NSAttributedString(string: "Nom du client", attributes: [NSFontAttributeName: nameLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
        phoneLabel.attributedPlaceholder = NSAttributedString(string: "N° de portable", attributes: [NSFontAttributeName: phoneLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
        mailLabel.attributedPlaceholder = NSAttributedString(string: "E-mail", attributes: [NSFontAttributeName: mailLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
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
        if selectedClient == nil || nameLabel.text == "" {
            self.alertUser(title: "Erreur", message: "Vous devez renseigner\n le nom du client")
        }
        else if( sendingProfileType == .partnersProfile && selectedPartners.count == 0){
            self.alertUser(title: "Erreur", message: "Vous devez selectionner\n les partenaires dont vous voulez\n envoyer le profil")
        }
        else{
            var data:[String:Any] = [:]
            if(sender.currentTitle == "SMS"){
                print("SMS")
                if phoneLabel.text == ""{
                    self.alertUser(title: "Erreur", message: "Vous devez renseigner\n le numéro du client")
                }
                else{
                    //sendingType = .sms
                    self.selectedClient?["phone"] = num
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
                    self.alertUser(title: "Erreur", message: "Vous devez renseigner\n l'adresse mail du client")
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
    
    @IBAction func editNum(_ sender: UITextField?) {
        if sender != nil{
            numDisplay = sender!.text!
            
            //            print()
            //            print(numDisplay)
            var cursorOffsetModified:Bool = false
            var cursorOffset = 0
            
            numNew = numDisplay.replacingOccurrences(of: " ", with: "")
            
            let sizeNum = numNew.characters.count
            let sizeNumBefore = num.characters.count
            
            
            //            print(num)
            //            print(numNew)
            //            print("sizeNum : \(sizeNumBefore)")
            //            print("sizeNewNum : \(sizeNum)")
            
            
            if sizeNum == 0{
                numDisplay = numNew
                num = numNew
            }
            else{
                
                let lastChar = numDisplay.characters.last
                numDisplay = String(numDisplay.characters.dropLast())
                
                if (numNew == num.appending("\(lastChar!)")){
                    //Add on last position
                    print("Add on last position")
                    
                    if sizeNum == 11{
                        numNew = String(numNew.characters.dropLast())
                        num = numNew
                    }
                    else{
                        num = numNew
                        
                        //If next char is in a even place so add a blank space
                        //Else don't add a blank space
                        numDisplay += (sizeNum % 2 != 0 && sizeNum != 1) ? " \(lastChar!)" : "\(lastChar!)"
                    }
                    
                    
                }
                else if sizeNum <= sizeNumBefore{
                    //Suppress
                    let lastCharData  = num.characters.last
                    
                    if (num == numNew.appending("\(lastCharData!)")){
                        //Suppress on the last char
                        print("Suppress on the last char")
                        if lastChar! != " "{
                            numDisplay.append("\(lastChar!)")
                        }
                        num = numNew
                    }
                    else{
                        
                        
                        if sizeNum == sizeNumBefore{
                            print("Suppress a space char")
                            
                            var cursorPosition = 0
                            
                            if let selectedRange = sender!.selectedTextRange {
                                
                                cursorPosition = sender!.offset(from: sender!.beginningOfDocument, to: selectedRange.start)
                            }
                            numDisplay.append(lastChar!)
                            print(numDisplay)
                            numDisplay.remove(at: numDisplay.index(numDisplay.startIndex, offsetBy: cursorPosition-1))
                            print(numDisplay)
                            
                            numNew = numDisplay.replacingOccurrences(of: " ", with: "")
                            
                            let chars = numNew.characters
                            var count = 0
                            numDisplay = ""
                            for char in chars{
                                if count % 2 == 0 && count != 0{
                                    numDisplay += " "
                                }
                                numDisplay += "\(char)"
                                count += 1
                            }
                            
                            cursorOffsetModified = true
                            cursorOffset = cursorPosition - 1
                        }
                        else{
                            print("Suppress a non space char")
                            var chars = numNew.characters
                            var charsPrev = num.characters
                            
                            cursorOffset = 0
                            
                            for _ in 0 ... sizeNum{
                                if chars.count == 0 {break}
                                if(charsPrev.popFirst()! != chars.popFirst()!){
                                    break
                                }
                                cursorOffset += 1
                                if (cursorOffset % 3) % 2 == 0 {cursorOffset += 1}
                            }
                            
                            cursorOffsetModified = true
                        }
                        
                        var count = 0
                        numDisplay = ""
                        let charsNum = numNew.characters
                        for char in charsNum{
                            if count % 2 == 0 && count != 0{
                                numDisplay += " "
                            }
                            numDisplay += "\(char)"
                            count += 1
                        }
                        
                        num = numNew
                        
                    }
                }
                else{
                    //Add character not in the last position
                    print("Add character not in the last position")
                    num = numNew
                    
                    var cursorPosition = 0
                    
                    if let selectedRange = sender!.selectedTextRange {
                        
                        cursorPosition = sender!.offset(from: sender!.beginningOfDocument, to: selectedRange.start)
                    }
                    
                    cursorOffsetModified = true
                    cursorOffset = (cursorPosition  % 3 == 0) ? cursorPosition + 1 : cursorPosition
                    
                    let chars = numNew.characters
                    var count = 0
                    numDisplay = ""
                    for char in chars{
                        if count % 2 == 0 && count != 0{
                            numDisplay += " "
                        }
                        numDisplay += "\(char)"
                        count += 1
                        if count == 10{
                            break
                        }
                    }
                    numNew = numDisplay.replacingOccurrences(of: " ", with: "")
                    num = numNew
                }
            }
            
            print("numDisplay = \(numDisplay)")
            sender!.text = numDisplay
            if (cursorOffsetModified){
                
                if let newPosition = sender!.position(from: sender!.beginningOfDocument, offset: cursorOffset) {
                    
                    sender!.selectedTextRange = sender!.textRange(from: newPosition, to: newPosition)
                }
            }
        }
            
        else{
            numDisplay = phoneLabel!.text!
            
            numNew = numDisplay.replacingOccurrences(of: " ", with: "")
            
            numDisplay = ""
            let charsNum = numNew.characters
            var count = 0
            for char in charsNum{
                if count % 2 == 0 && count != 0{
                    numDisplay += " "
                }
                numDisplay += "\(char)"
                count += 1
            }
            num = numNew
            phoneLabel.text = numDisplay
        }
        
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
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
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard")
        }
    }
    
    func setActive(_ button: UIButton, otherButton: UIButton? = nil){
        button.backgroundColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        
        otherButton?.backgroundColor = UIColor.white
        otherButton?.setTitleColor(UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1), for: .normal)
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
        
        var toFocus = mailLabel.superview!.frame
        toFocus.origin.y += mailLabel.superview!.superview!.frame.origin.y
        
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
