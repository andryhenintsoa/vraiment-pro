//
//  DocsSendPictureViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 04/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class DocsSendPictureViewController: MainViewController {

    @IBOutlet weak var resultLabel : UILabel!
    var textToDisplay : String = ""
    
    var imageToSend:UIImage?
    
    var documentToSendType:DocsType!
    
    override func viewDidLoad() {
        resultLabel.text = textToDisplay
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.closeNavController), userInfo: nil, repeats: false)
        
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
    
    func sendAdvice(_ sender: Any) {
        Webservice.adviceSendAdvice(self, data: data, imageToSend : imageToSend)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
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
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard", completion: { (action) in
                self.closeController(action)
            })
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult"{
            let destination = segue.destination as? ResultViewController
            
            let data = waitingData[(waitingTableView.indexPathForSelectedRow?.row)!]
            
            destination?.selectedAdviceMediation = data
        }
    }

}
