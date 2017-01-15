//
//  ImagePreviewViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 10/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController {

    @IBOutlet weak var imagePreview: UIImageView!
    var callerController: ImagePickerViewController!
    var imageToPreview:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreview.image = imageToPreview
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validate(_ sender: Any) {
        callerController.performNext()
    }
    
    @IBAction func cancel(_ sender: Any) {
        callerController.performNext(false)
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
