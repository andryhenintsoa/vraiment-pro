//
//  AdviceWaitingMediationAnswerViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingMediationAnswerViewController: MainViewController {
    
    @IBOutlet weak var answerTextView: UITextView!
    
    var selectedAdviceMediation:[String:Any]!
    var data : [String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        data = selectedAdviceMediation
        answerTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
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
    
    @IBAction func send(_ sender: Any) {
        if answerTextView.text == "" {
            self.alertUser(title: "Erreur", message: "Vous n'avez rien répondu")
        } else {
            data["answerText"] = answerTextView.text
            print(data)
            answerTextView.resignFirstResponder()
            Webservice.adviceMediationAnswer(self, data: data)
            //performSegue(withIdentifier: "toResultAnswerWaitingMediation", sender: sender)
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
                    
                    performSegue(withIdentifier: "toResultAnswerWaitingMediation", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Echec de l'envoi")
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard")
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultAnswerWaitingMediation"{
            
        }
    }
    

}
