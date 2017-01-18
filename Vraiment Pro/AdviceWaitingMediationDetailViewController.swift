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
    
    var selectedAdviceMediation:[String:Any]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rating = selectedAdviceMediation["note"] as? Int{
            self.rating.rating = Double(rating)
        }
        else{
            self.rating.rating = 0
        }
        
        if let com = selectedAdviceMediation["commentaire"] as? String{
            self.message.text = com
            message.scrollsToTop = true
        }
        else{
            self.message.text = ""
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }

    @IBAction func notAnswerWaitingMediation(_ sender: Any) {
        alertConfirmUser(title: "Ne pas répondre", message: "Etes-vous sûr\n de ne pas vouloir répondre ?") { (action) in
            var data:[String:Any] = [:]
            data = self.selectedAdviceMediation
            data["notAnswer"] = "yes"
            print(data)
            //self.closeController(sender as AnyObject)
            Webservice.adviceWaitingMediationNotAnswer(self, data:data)
            //self.performSegue(withIdentifier: "notAnswerAdvice", sender: self)
        }
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
                    Utils.adviceWaitingMediation -= 1
                    
                    Utils.getInstance().notifyAll()
                    
                    self.performSegue(withIdentifier: "notAnswerAdvice", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Echec de l'action")
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWaitingMediationAnswer"{
            
            let destination = segue.destination as? AdviceWaitingMediationAnswerViewController
            
            destination?.selectedAdviceMediation = self.selectedAdviceMediation
        }
        
        else if segue.identifier == "notAnswerAdvice"{
            
            let destination = segue.destination as? ResultViewController
            
            destination?.textToDisplay = "Cet avis sera publié sur votre profil\n" + "vous n'avez pour l'instant\n pas souhaité y répondre"
        }
    }

}
