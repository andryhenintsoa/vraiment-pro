//
//  PasswordForgottenViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class PasswordForgottenViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        
        addBorderToLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addBorderToLabel(){
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1).cgColor
        border.frame = CGRect(x: 0, y: emailLabel.frame.size.height - width + 1, width:  emailLabel.frame.size.width, height: emailLabel.frame.size.height)
        
        border.borderWidth = width
        emailLabel.layer.addSublayer(border)
        emailLabel.layer.masksToBounds = true
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
