//
//  HomeViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 05/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var avisView: UIView!
    @IBOutlet weak var profilView: UIView!
    @IBOutlet weak var messagesView: UIView!
    @IBOutlet weak var docsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureAvis = UITapGestureRecognizer(target: self, action:  #selector (self.goToDetail (_:)))
        self.avisView.addGestureRecognizer(gestureAvis)
        let gestureProfil = UITapGestureRecognizer(target: self, action:  #selector (self.goToDetail (_:)))
        self.profilView.addGestureRecognizer(gestureProfil)
        let gestureMessages = UITapGestureRecognizer(target: self, action:  #selector (self.goToDetail (_:)))
        self.messagesView.addGestureRecognizer(gestureMessages)
        let gestureDocs = UITapGestureRecognizer(target: self, action:  #selector (self.goToDetail (_:)))
        self.docsView.addGestureRecognizer(gestureDocs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func goToDetail(_ sender:UITapGestureRecognizer){
        print("test")
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
