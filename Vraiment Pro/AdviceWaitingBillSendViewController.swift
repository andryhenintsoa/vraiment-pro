//
//  AdviceWaitingBillSendViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 05/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingBillSendViewController: MainViewController {

    var imageToSend:UIImage?
    
    var data:Dictionary<String,Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Webservice.adviceSendBills(self, data: data, imageToSend : imageToSend)
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
    
    @IBAction func closeNavController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
                    Utils.adviceWaitingBills -= 1
                    Utils.getInstance().notifyAll()
                    
                    performSegue(withIdentifier: "toResult", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Echec de l'envoi", completion: { (action) in
                        self.closeController(action)
                    })
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard", completion: { (action) in
                self.closeController(action)
            })
        }
    }
    
    override func reloadMyViewWithError() {
        alertUser(title: "Erreur d'upload", message: "Veuillez réessayer\n plus tard")
        closeController(self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            let destination = segue.destination as? ResultViewController
            
            destination?.textToDisplay = "La facture a bien été envoyée"
        }
    }
}
