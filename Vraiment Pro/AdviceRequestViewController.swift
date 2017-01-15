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
    @IBOutlet weak var phoneLabel: VSTextField!
    @IBOutlet weak var mailLabel: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ouLabel: UILabel!
    
    @IBOutlet weak var viewToShow: UIView!
    var activeField: UITextField?
    
    var selectedClient: [String:String]?
    var sendingType: SendingType?
    
//For custom textfield
    var num:String = ""
    var numNew:String = ""
    var numDisplay:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //phoneLabel.setFormatting("## ## ## ## ## ##", replacementChar : "#")
        
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
                    
//                    print("Num : \(num)")
//                    print("NumNew : \(numNew)")
//                    print("NumDisplay : \(numDisplay)")
                    
                    sendingType = .sms
                    self.selectedClient?["phone"] = num
                    
                    
                    var phoneToDisplay = ""
                    var counter = 0
                    for char in num.characters{
                        phoneToDisplay.append(char)
                        counter += 1
                        if counter%2 == 0{
                            phoneToDisplay.append(" ")
                        }
                    }
                    
                    self.selectedClient?["phoneToDisplay"] = phoneToDisplay
                    
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
                
                //            print("num")
                //            print(numNew)
                //            print(num.appending("\(lastChar)"))
                //            print()
                
                //let lastChar = numDisplay.remove(at: numDisplay.endIndex)
                
                if (numNew == num.appending("\(lastChar!)")){
                    //Add on last position
                    print("Add on last position")
                    
                    num = numNew
                    
                    //If next char is in a even place so add a blank space
                    //Else don't add a blank space
                    numDisplay += (sizeNum % 2 != 0 && sizeNum != 1) ? " \(lastChar!)" : "\(lastChar!)"
                    
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
                            
                            //                        let dataDisplay = numDisplay.components(separatedBy: " ")
                            //                        var positionOfCharToDelete = 0
                            //                        for itemData in dataDisplay{
                            //                            positionOfCharToDelete += 2
                            //                            if itemData.characters.count > 2{
                            //                                break
                            //                            }
                            //                        }
                            //                        positionOfCharToDelete -= 1
                            //                        numNew.remove(at: numNew.index(numNew.startIndex, offsetBy: positionOfCharToDelete))
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
                    }
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
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height + 50, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.scrollView.scrollRectToVisible(mailLabel.superview!.frame, animated: true)
        
//        self.scrollView.scrollRectToVisible(mailLabel.frame, animated: true)
        
        self.scrollView.isScrollEnabled = false
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height - 50, 0.0)
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
