//
//  AdviceRequestViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 08/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceRequestViewController: UIViewController {

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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
