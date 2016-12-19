//
//  MessagesClientDetailViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class MessagesClientDetailViewController: UIViewController {
    
    @IBOutlet weak var messagesClientButton: UIButton!
    @IBOutlet weak var messagesVPButton: UIButton!
    @IBOutlet weak var messageContent: UITextView!
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var senderPhone: UILabel!
    @IBOutlet weak var senderMail: UILabel!
    
    var message: [String:String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        senderName.text = message["name"]
        messageContent.text = message["content"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
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
