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
    
    func chooseTakingPictureMode() {
        let alertController = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let nowAction = UIAlertAction(title: "Appareil photo",
                                      style: UIAlertActionStyle.default,
                                      handler: {(alertAction: UIAlertAction) in
                                        if UIImagePickerController.isSourceTypeAvailable(.camera){
                                            self.takePicture(with: .camera)
                                        }
                                        else{
                                            self.alertUser(title: "Appareil photo non disponible", message: "Votre appareil photo n'est pas disponible, essayer la galerie photo")
                                        }
                                        
                                    
                                        
        })
        
        let laterAction = UIAlertAction(title: "Gallerie photo",
                                        style: UIAlertActionStyle.default,
                                        handler: {(alertAction: UIAlertAction) in
                                            self.takePicture(with: .photoLibrary)
        })

        let cancelAction = UIAlertAction(title: "Annuler",
                                         style: UIAlertActionStyle.cancel,
                                         handler: {(alertAction: UIAlertAction) in
                                            //self.userOutput.text="Pressed Never"
        })
        
        alertController.addAction(nowAction)
        alertController.addAction(laterAction)
        alertController.addAction(cancelAction)
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        dismiss(animated: true, completion: nil)
        
        self.imageToSend = info[UIImagePickerControllerOriginalImage] as! UIImage!
        
        performSegue(withIdentifier: segueNextName, sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
