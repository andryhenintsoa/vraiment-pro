//
//  DOcsSendBAPictureMergerViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/01/2017.
//  Copyright © 2017 Sparks MG. All rights reserved.
//

import UIKit

class DOcsSendBAPictureMergerViewController: MainViewController {

    var imageToSend1:UIImage?
    var imageToSend2:UIImage?
    var imageToSend:UIImage?
    @IBOutlet weak var imagePreview: UIImageView!
    
    let documentToSendType:DocsType = .beforeAfterPic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageToSend = mergePicturesSideBySide(image1:imageToSend1, image2:imageToSend2)
        
        imagePreview.image = imageToSend
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
    
    @IBAction func sendPicture(_ sender: Any) {
        performSegue(withIdentifier: "toSendPicture", sender: nil)
    }
    
    // Merge two pictures
    func mergePictures(image1:UIImage?, image2:UIImage?) ->  UIImage{
        let bottomImage = image1
        let topImage = image2
        
        let size = bottomImage!.size
        let size2 = topImage!.size
        
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        bottomImage!.draw(in: areaSize)
        
        var widthSmallPic:CGFloat = 0
        var heightSmallPic:CGFloat = 0
        
        if size2.width > size2.height{
            widthSmallPic = size.width.divided(by: 3)
            heightSmallPic = size2.height.multiplied(by: widthSmallPic).divided(by: size2.width)
        }
        else{
            heightSmallPic = size.height.divided(by: 3)
            widthSmallPic = size2.width.multiplied(by: heightSmallPic).divided(by: size2.height)
        }
        
        let areaSizeSmallPic = CGRect(x: 0, y: 0, width: widthSmallPic, height: heightSmallPic)
        
        topImage!.draw(in: areaSizeSmallPic, blendMode: .normal, alpha: 0.8)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func mergePicturesSideBySide(image1:UIImage?, image2:UIImage?) ->  UIImage{
        
        let size = image1!.size
        let size2 = image2!.size
        
        var imageSize:CGSize = CGSize(width: 0, height: 0)
        
        if size.height > size2.height{
            imageSize.height = size2.height
            
            imageSize.width = size2.width + size.width.multiplied(by: size2.height).divided(by: size.height)
            
            
        }
        else{
            imageSize.height = size.height
            
            imageSize.width = size.width + size2.width.multiplied(by: size.height).divided(by: size2.height)
        }
        
        UIGraphicsBeginImageContext(imageSize)
        
        var areaSize:CGRect
        
        let widthFirstImage = size.width.multiplied(by: imageSize.height).divided(by: size.height)
        
        areaSize = CGRect(x: 0, y: 0, width: widthFirstImage, height: imageSize.height)
        image1!.draw(in: areaSize)
        
        areaSize = CGRect(x: widthFirstImage, y: 0, width: imageSize.width - widthFirstImage, height: imageSize.height)
        
        image2!.draw(in: areaSize)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            if let dataStatus = data["status"] as? Bool{
                if dataStatus{
                    performSegue(withIdentifier: "toResult", sender: self)
                }
                else{
                    alertUser(title: "Erreur", message: "Echec de l'envoi", completion: { (action) in
                        self.closeController(action)
                    })
                }
                normalConnection = true
            }
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard", completion: { (action) in
                self.closeController(action)
            })
        }
    }
    
    override func reloadMyViewWithError() {
        alertUser(title: "Erreur d'upload", message: "Veuillez réessayer\n plus tard")
        closeController(self)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSendPicture"{
            let destination = segue.destination as? DocsSendPictureViewController
            
            destination?.imageToSend = self.imageToSend
            destination?.documentToSendType = self.documentToSendType
            destination?.navigationItem.title = "Publier un avant/après"
        }
    }
    
}
