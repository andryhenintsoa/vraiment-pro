//
//  AdviceNoWaitingViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class AdviceNoWaitingViewController: MainViewController {

    @IBOutlet weak var resultLabel : UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "Vous n'avez pas\n d'avis en attente"
        
        resultLabel.sizeToFit()
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
    
    func closeNavController() {
        self.dismiss(animated: true, completion: nil)
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
