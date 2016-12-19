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
    
    var selectedAdviceMediation:[String:String]!
    var data : [String:String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        data = selectedAdviceMediation
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func send(_ sender: Any) {
        if answerTextView.text == "" {
            self.alertUser(title: "Erreur", message: "Vous n'avez encore rien écrit")
        } else {
            data["answerText"] = answerTextView.text
            performSegue(withIdentifier: "toResultAnswerWaitingMediation", sender: sender)
        }
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResultAnswerWaitingMediation"{
            print(data)
        }
    }
    

}
