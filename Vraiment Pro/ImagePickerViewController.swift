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
    
    var timer:Timer!
    var countTimer:Int = 0
    
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
        
        
        if goNext{
            performSegue(withIdentifier: segueNextName, sender: self)
        }
        else{
            self.takePicture(with: .photoLibrary)
        }
        
        
        if imagePreviewVC != nil{
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidePreview), userInfo: nil, repeats: false)
        }
        
    }
    
    func hidePreview(){
        
//        if countTimer == 0{
        
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                //self.imagePreviewVC?.view.bounds.origin.x = self.view.bounds.width
                self.imagePreviewVC?.view.alpha = 0
            }, completion: { (_) in
                let currentWindow = UIApplication.shared.keyWindow
                let imagePreviewView = self.imagePreviewVC!.view!
                currentWindow?.sendSubview(toBack: imagePreviewView)
                self.imagePreviewVC = nil
            })
            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {})
//                
//                
//                
//            UIView.animate(withDuration: 0.5, animations: {
//                self.imagePreviewVC?.view.bounds.origin.x = self.view.bounds.width
//                self.countTimer += 1
//            })
//        }
//        else{
//            let currentWindow = UIApplication.shared.keyWindow
//            currentWindow?.sendSubview(toBack: self.imagePreviewVC!.view!)
//            self.imagePreviewVC = nil
//            self.timer.invalidate()
//        }
        
        
        
        
        
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
    
    func hidePicker(){
        dismiss(animated: true, completion: nil)
    }
    
    func radians (_ degrees:Double) -> Double {return degrees * Double.pi/180;}
    
    func rotateImageFromCamera(_ theImage:UIImage) ->  UIImage{
        
        print("Orientation image: \(theImage.imageOrientation.rawValue)")
        
        if (theImage.imageOrientation == .up || theImage.imageOrientation == .down){
            return theImage
        }
        
        UIGraphicsBeginImageContext(theImage.size)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        
        context.rotate(by: CGFloat(radians(0)))
        
        theImage.draw(at: CGPoint(x: 0, y: 0))
        
//        let areaSize = CGRect(x: 0, y: 0, width: theImage.size.width, height: theImage.size.height)
//        theImage.draw(in: areaSize)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
        
//        let oldImage:UIImage = theImage
//        let degrees:CGFloat = 90.0
//        
//        
//        
//        let rotatedViewBox: UIView = UIView(frame: CGRect(x:0, y:0, width:oldImage.size.width, height:oldImage.size.height))
////        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(M_PI / 180))
////        
////        rotatedViewBox.transform = t
//        
//        print("width \(rotatedViewBox.frame.size.width)")
//        print("height \(rotatedViewBox.frame.size.height)")
//        
////        let rotatedSize: CGSize = rotatedViewBox.frame.size
//        let rotatedSize: CGSize = oldImage.size
//        //Create the bitmap context
//        UIGraphicsBeginImageContext(rotatedSize)
//        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
//        //Move the origin to the middle of the image so we will rotate and scale around the center.
//        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
//        //Rotate the image context
//        bitmap.rotate(by: (degrees * CGFloat(M_PI / 180)))
//        //Now, draw the rotated/scaled image into the context
//        //bitmap.scaleBy(x: 1.0, y: -1.0)
//        bitmap.draw(oldImage.cgImage!, in: CGRect(x:-oldImage.size.width / 2, y:-oldImage.size.height / 2, width:oldImage.size.width, height:oldImage.size.height))
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return newImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //dismiss(animated: true, completion: nil)
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hidePicker), userInfo: nil, repeats: false)
        
        if imageSource == .camera {
            
            let theImage = rotateImageFromCamera(info[UIImagePickerControllerOriginalImage] as! UIImage!)
            
            if let data = UIImageJPEGRepresentation(theImage, 1){
                let paths = FileManager.default.urls(for: .picturesDirectory, in: .userDomainMask)
                let documentsDirectory = paths[0]
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let filename = documentsDirectory.appendingPathComponent("VraimentPro", isDirectory: true).appendingPathComponent("VP-\(dateFormatter.string(from: date)).jpeg")
                
                try? data.write(to: filename)
            }
            
            self.imageToSend = theImage
            performNext()
            //displayPreview()
            
        } else if imageSource == .photoLibrary{
            self.imageToSend = info[UIImagePickerControllerOriginalImage] as! UIImage!
            displayPreview()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


private extension UIStoryboard {
    
    class func imagePreviewViewController() -> ImagePreviewViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "imagePreview") as? ImagePreviewViewController
    }
    
}
