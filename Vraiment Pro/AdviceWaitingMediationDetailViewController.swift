//
//  AdviceWaitingMediationDetailViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingMediationDetailViewController: MainViewController {
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var message: UITextView!
    
    var selectedAdviceMediation:[String:String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rating.rating = Double(selectedAdviceMediation["rating"]!)!
        self.message.text = selectedAdviceMediation["message"]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func notAnswerWaitingMediation(_ sender: Any) {
        alertConfirmUser(title: "Ne pas répondre", message: "Etes-vous sûr de ne pas vouloir répondre?") { (action) in
            var data:[String:String] = [:]
            data = self.selectedAdviceMediation
            data["notAnswer"] = "yes"
            print(data)
            self.closeController(sender as AnyObject)
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWaitingMediationAnswer"{
            
            let destination = segue.destination as? AdviceWaitingMediationAnswerViewController
            
            destination?.selectedAdviceMediation = self.selectedAdviceMediation
        }
        
    }

}
