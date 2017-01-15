//
//  MessagesClientDetailViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit
import AddressBook
import MessageUI

class MessagesClientDetailViewController: MainViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var messagesClientButton: UIButton!
    @IBOutlet weak var messagesVPButton: UIButton!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderPhone: UIButton!
    @IBOutlet weak var senderMail: UIButton!
    
    @IBOutlet weak var notificationMessagesClient: UILabel!
    @IBOutlet weak var notificationMessagesClientContainer: UIView!
    
    @IBOutlet weak var notificationMessagesVP: UILabel!
    @IBOutlet weak var notificationMessagesVPContainer: UIView!
    
    var notificationMessagesClientNumber = 0
    var notificationMessagesVPNumber = 0
    
    var message: Message!
    
    
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesClientButton.setTitle("Contacts clients", for: .normal)
        messagesVPButton.setTitle("Infos VraimentPro", for: .normal)
        
        senderName.text = message.clientCivility + " " + message.clientName
        senderPhone.setTitle(message.clientNum, for: .normal)
        senderPhone.sizeToFit()
        senderMail.setTitle(message.clientMail, for: .normal)
        senderMail.sizeToFit()
        messageContent.text = message.content
        
        reloadNotifications()
        
        messageContent.sizeToFit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadNotifications(){
        setNumberOfNotification(notificationMessagesVPNumber, messageType: .vp)
        setNumberOfNotification(notificationMessagesClientNumber, messageType: .client)
    }
    
    func setNumberOfNotification(_ number:Int, messageType:MessagesType){
        if messageType == .client{
            if number == 0 {
                notificationMessagesClientContainer.alpha = 0
                return
            }
            notificationMessagesClientContainer.alpha = 1
            notificationMessagesClient.text = "\(number)"
        }
        else{
            if number == 0 {
                notificationMessagesVPContainer.alpha = 0
                return
            }
            notificationMessagesClientContainer.alpha = 1
            notificationMessagesVP.text = "\(number)"
        }
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }
    
    @IBAction func displayMessagesList(_ sender: UIButton) {
        let n = self.navigationController?.viewControllers.count
        let previousVC = self.navigationController?.viewControllers[n!-2] as! MessagesViewController
        if(sender == messagesClientButton){
            previousVC.chooseMessageType(index: 0)
        }
        else if(sender == messagesVPButton){
            previousVC.chooseMessageType(index: 1)
        }
        else{
            
        }
        closeController(sender)
    }
    
    @IBAction func performCall(_ sender: UIButton) {
        let phoneNumber = message.clientNum.replacingOccurrences(of: " ", with: "")
        
        if let phoneCallURL:URL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                self.alertConfirmUser(title: "Appel", message: "\(message.clientNum)", customConfirmText: "Appeler", completion: { (action) in
                    application.openURL(phoneCallURL)
                })
            }
            else{
                self.alertUser(title: "Erreur", message: "Cet appel ne peut être effectué")
            }
        }
        else{
            print("Error on number")
        }
    }
    
    @IBAction func sendMail(_ sender: UIButton) {
        let emailAddresses:[String]=[message.clientMail]
        let mailComposer:MFMailComposeViewController = MFMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail(){
            mailComposer.mailComposeDelegate=self;
            mailComposer.setToRecipients(emailAddresses)
            present(mailComposer, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func addContact(_ sender: UIButton) {
        
//        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
//        
//        switch authorizationStatus {
//        case .denied, .restricted:
//            //1
//            print("Denied")
//            self.alertUser(title: "Erreur", message: "Vous ne pouvez pas avoir accès à vos contacts")
//        case .authorized:
//            //2
//            print("Authorized")
//            performAddingContact()
//        case .notDetermined:
//            //3
//            print("Not Determined")
//            promptForAddressBookRequestAccess()
//        }
        
        
        
    }
    
    func performAddingContact(){
        
        let userRecord: ABRecord = ABPersonCreate().takeRetainedValue()
        ABRecordSetValue(userRecord, kABPersonFirstNameProperty, message.clientName as CFTypeRef!, nil)
        ABRecordSetValue(userRecord, kABPersonLastNameProperty, "" as CFTypeRef!, nil)
        ABRecordSetValue(userRecord, kABPersonEmailProperty, message.clientMail as CFTypeRef, nil)
        
        let phoneNumbers: ABMutableMultiValue = ABMultiValueCreateMutable(ABPropertyType(kABMultiStringPropertyType)).takeRetainedValue()
        ABMultiValueAddValueAndLabel(phoneNumbers, message.clientNum as CFTypeRef!, kABPersonPhoneMainLabel, nil)
        ABRecordSetValue(userRecord, kABPersonPhoneProperty, phoneNumbers, nil)
        
        ABAddressBookAddRecord(addressBookRef, userRecord, nil)
        saveAddressBookChanges()
        
        self.alertUser(title: "\(message.clientName) a été ajouté dans vos contacts.", message: nil)
    }
    
    func promptForAddressBookRequestAccess() {
        
        ABAddressBookRequestAccessWithCompletion(addressBookRef) { (granted, error) in
            DispatchQueue.main.async {
                if !granted {
                    // 1
                    print("Just denied")
                    self.alertUser(title: "Erreur", message: "Vous ne pouvez pas avoir accès à vos contacts")
                } else {
                    // 2
                    print("Just authorized")
                    self.performAddingContact()
                }
            }
        }
    }
    
    func saveAddressBookChanges() {
        if ABAddressBookHasUnsavedChanges(addressBookRef){
            var err: Unmanaged<CFError>? = nil
            
            let savedToAddressBook = ABAddressBookSave(addressBookRef, &err)
            if savedToAddressBook {
                print("Successully saved changes.")
            } else {
                print("Couldn't save changes.")
            }
        } else {
            print("No changes occurred.")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .sent{
            self.alertUser(title: "Votre e-mail a été envoyé", message: nil)
        }
        else if result == .failed{
            self.alertUser(title: "Votre e-mail n'a pas été envoyé", message: nil)
        }
        else if result == .cancelled{
            controller.dismiss(animated: true, completion: nil)
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
