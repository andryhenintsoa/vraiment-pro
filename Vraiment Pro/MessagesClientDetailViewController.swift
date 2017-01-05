//
//  MessagesClientDetailViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class MessagesClientDetailViewController: MainViewController {
    
    @IBOutlet weak var messagesClientButton: UIButton!
    @IBOutlet weak var messagesVPButton: UIButton!
    @IBOutlet weak var messageContent: UILabel!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderPhone: UILabel!
    @IBOutlet weak var senderMail: UILabel!
    
    @IBOutlet weak var notificationMessagesClient: UILabel!
    @IBOutlet weak var notificationMessagesClientContainer: UIView!
    
    @IBOutlet weak var notificationMessagesVP: UILabel!
    @IBOutlet weak var notificationMessagesVPContainer: UIView!
    
    var notificationMessagesClientNumber = 0
    var notificationMessagesVPNumber = 0
    
    var message: Message!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesClientButton.setTitle("Contacts clients", for: .normal)
        messagesVPButton.setTitle("Infos VraimentPro", for: .normal)
        
        senderName.text = message.clientName
        senderPhone.text = message.clientNum
        senderMail.text = message.clientMail
        messageContent.text = message.content
        
        reloadNotifications()
        
        message.state = "0"
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
