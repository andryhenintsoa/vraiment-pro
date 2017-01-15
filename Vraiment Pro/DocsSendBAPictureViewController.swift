//
//  DocsSendBAPictureViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class DocsSendBAPictureViewController: ImagePickerViewController {

    var imageToSend1:UIImage?
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //imagePreview.image = imageToSend1
        
        nextButton.bounds = self.view.bounds
        nextButton.alpha = 0
        
        self.segueNextName = "toPictureMerger"
        chooseTakingPictureMode("Selectionnez photo \"après\"", withCancelButton: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toNext(_ sender: Any) {
        self.segueNextName = "toPictureMerger"
        chooseTakingPictureMode("Selectionnez photo \"après\"", withCancelButton: true)
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPictureMerger"{
            let destination = segue.destination as? DOcsSendBAPictureMergerViewController
            
            destination?.imageToSend1 = self.imageToSend1
            destination?.imageToSend2 = self.imageToSend
        }
    }
    
}

