//
//  DocsViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 05/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class DocsViewController: ImagePickerViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!

    var menu : [Dictionary<String,String>] = []
    
    var documentToSendType:DocsType?
    
    var listDocsType:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButtonsInfo()
        menuCollectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Poser les informations de chaque menu
    func createButtonsInfo(){
        menu.append(["name":"Publier une photo","picture":"ic_camera_party_mode.png",
                     "id":"1"])
        menu.append(["name":"Publier un avant/après","picture":"ic_image_filter.png",
                     "id":"2"])
        menu.append(["name":"Publier un document","picture":"ic_file_document.png",
                     "id":"3"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSendPicture"{
            let destination = segue.destination as? DocsSendPictureViewController
            
            destination?.imageToSend = self.imageToSend
            destination?.documentToSendType = self.documentToSendType
            destination?.navigationItem.title = "Publier une photo"
        }
        else if segue.identifier == "toSendBAPicture"{
            let destination = segue.destination as? DocsSendBAPictureViewController
            
            destination?.imageToSend1 = self.imageToSend
        }
        else if segue.identifier == "toSendDoc"{
            let destination = segue.destination as? DocsSendDocViewController
            
            destination?.imageToSend = self.imageToSend
        }
    }

}

// MARK: - UICollectionViewDataSource
extension DocsViewController : UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menu.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "docsMenuItem", for: indexPath) as! DocsCollectionViewCell
        let data = menu[indexPath.item]
        
        cell.label.text = data["name"]!
        cell.image.image = UIImage(named: data["picture"]!)
        
        cell.layer.borderWidth = 0.5
        //cell.layer.borderColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1).cgColor
        //cell.layer.cornerRadius = 5
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DocsViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picWidth = (self.view.frame.size.width - 40)
        return CGSize(width: picWidth, height: 55)
    }
}

// MARK: - UICollectionViewDelegate
extension DocsViewController : UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        if indexPath.row == 0{
            documentToSendType = .samplePic
            self.segueNextName = "toSendPicture"
            chooseTakingPictureMode()
        }
            
        else if indexPath.row == 1{
            self.segueNextName = "toSendBAPicture"
            chooseTakingPictureMode("Selectionnez photo \"avant\"", withCancelButton: true)
        }
        
        else if indexPath.row == 2{
            self.segueNextName = "toSendDoc"
            chooseTakingPictureMode()
        }
    }
}







