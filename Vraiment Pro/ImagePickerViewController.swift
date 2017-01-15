//
//  CustomImagePicker.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 17/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

class ImagePickerViewController: MainViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imageToSend:UIImage?
    var segueNextName:String!
    var validateImage:Bool! = false
    var imageSource:UIImagePickerControllerSourceType!
    var imagePreviewVC:ImagePreviewViewController? = nil
    
    func chooseTakingPictureMode(_ title:String? = nil, withCancelButton:Bool = true) {
        let alertController = UIAlertController(title: title,
                                                message: nil,
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let nowAction = UIAlertAction(title: "Appareil photo",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alertAction: UIAlertAction) in
                                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                                            self.imageSource = .camera
                                            self.takePicture(with: .camera)
                                        }
                                        else{
                                            self.alertUser(title: "Appareil photo non disponible", message: "Votre appareil photo n'est pas disponible, essayer la galerie photo")
                                        }
                                        
                                    
                                        
        })
        
        let laterAction = UIAlertAction(title: "Galerie photo",
                                        style: UIAlertActionStyle.default,
                                        handler: {(alertAction: UIAlertAction) in
                                            self.imageSource = .photoLibrary
                                            self.takePicture(with: .photoLibrary)
        })

        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: UIAlertActionStyle.cancel,
                                         handler: {(alertAction: UIAlertAction) in
                                            //self.userOutput.text="Pressed Never"
        })
        
        if title != nil{
            let customTitle:String = "\(title!)" // Use NSString, which lets you call rangeOfString()
            let attributedString = NSMutableAttributedString(string: customTitle, attributes:[:])
            let customFont = [
                NSFontAttributeName: UIFont(name: "Rubik-Regular", size: 17)!,
                NSForegroundColorAttributeName : UIColor.black
            ]
            let matchRange = NSRange(location: 0, length: customTitle.characters.count)
            
            attributedString.addAttributes(customFont, range: matchRange)
            alertController.setValue(attributedString, forKey: "attributedTitle")
            
            
        }
        
        
        alertController.addAction(nowAction)
        alertController.addAction(laterAction)
        if withCancelButton{
            alertController.addAction(cancelAction)
        }
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    func takePicture(with:UIImagePickerControllerSourceType, sender:AnyObject? = nil){
        let imagePicker: UIImagePickerController = UIImagePickerController()
        
        imagePicker.sourceType = with
        
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.popover
        if (imagePicker.popoverPresentationController != nil) {
//            imagePicker.popoverPresentationController!.sourceView = sender as! UIButton
//            imagePicker.popoverPresentationController!.sourceRect = (sender as! UIButton).bounds
            
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func performNext(_ goNext:Bool = true){
        let currentWindow = UIApplication.shared.keyWindow
        if imagePreviewVC != nil{
            currentWindow?.sendSubview(toBack: imagePreviewVC!.view!)
            imagePreviewVC?.view.bounds.origin.x = self.view.bounds.width
            imagePreviewVC = nil
        }
        
        
        if goNext{
            performSegue(withIdentifier: segueNextName, sender: self)
        }
        else{
            self.takePicture(with: .photoLibrary)
        }
    }
    
    func displayPreview(){
        if (imagePreviewVC == nil) {
            imagePreviewVC = UIStoryboard.imagePreviewViewController()
            
            if self.navigationController != nil {
                
                let currentWindow = UIApplication.shared.keyWindow
                
                imagePreviewVC?.callerController = self
                imagePreviewVC?.imageToPreview = imageToSend
                
                currentWindow?.addSubview(imagePreviewVC!.view!)
                
//                imagePreviewVC?.view.bounds = CGRect(x: 0, y: 20, width: (currentWindow?.bounds.width)!, height: (currentWindow?.bounds.height)!)
                
//                self.navigationController?.view.addSubview(imagePreviewVC!.view!)
//                
//                imagePreviewVC!.view.frame = CGRect(x: 0, y: 20, width: self.view.bounds.width, height: UIScreen.main.bounds.height - 20)
//                self.navigationController?.addChildViewController(imagePreviewVC!)
            }
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        dismiss(animated: true, completion: nil)
        
        self.imageToSend = info[UIImagePickerControllerOriginalImage] as! UIImage!
        
        if imageSource == .camera {
            performNext()
        } else if imageSource == .photoLibrary{
            displayPreview()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func imagePreviewViewController() -> ImagePreviewViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "imagePreview") as? ImagePreviewViewController
    }
    
}
