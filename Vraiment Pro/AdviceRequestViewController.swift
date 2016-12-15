//
//  AdviceRequestViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 08/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceRequestViewController: MainViewController {
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var phoneLabel: UITextField!
    @IBOutlet weak var mailLabel: UITextField!
    
    var selectedClient: [String:String]?
    var sendingType: SendingType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func selectClient(_ sender: AnyObject) {
        performSegue(withIdentifier: "toClientChoose", sender: nil)
        if let textField = sender as? UITextField{
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func choosePrestation(_ sender: UIButton) {
        if selectedClient == nil {
            self.alertUser(title: "Erreur", message: "Vous devez selectionner un utilisateur")
        } else {
            if(sender.currentTitle == "SMS"){
                print("SMS")
                sendingType = .sms
                performSegue(withIdentifier: "toPrestation", sender: sender)
            }
            else if(sender.currentTitle == "Mail"){
                print("Mail")
                sendingType = .mail
                performSegue(withIdentifier: "toPrestation", sender: sender)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPrestation" {
            let destination = segue.destination as? AdvicePrestationViewController
            destination?.selectedClient = self.selectedClient
            destination?.sendingType = self.sendingType
        }
    }
 

}
