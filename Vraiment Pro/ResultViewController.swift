//
//  ResultViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 18/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class ResultViewController: MainViewController {

    @IBOutlet weak var resultLabel : UILabel!
    var textToDisplay : String = ""
    var autoHide:Bool = true
    
    override func viewDidLoad() {
        resultLabel.text = textToDisplay
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if autoHide{
            let _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.closeNavController), userInfo: nil, repeats: false)
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
    
    @IBAction func closeNavController(_ sender: AnyObject) {
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
