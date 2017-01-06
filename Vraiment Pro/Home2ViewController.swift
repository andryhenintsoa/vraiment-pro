//
//  Home2ViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class Home2ViewController: MainViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menu : [Dictionary<String,String>] = []
    
    deinit{
        Utils.getInstance().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addImageLogo()
        
        Utils.getInstance().addObserver(self)
        
        Webservice.numberNotifications(self)
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self

        createButtonsInfo()
        menuCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }
    
// Poser les informations de chaque menu
    func createButtonsInfo(){
        menu.append(["name":"Avis","picture":"ic_avis.png",
                                  "id":"1"])
        menu.append(["name":"Profil","picture":"ic_account.png",
                                  "id":"2"])
        menu.append(["name":"Messages","picture":"ic_messages.png",
                                  "id":"3"])
        menu.append(["name":"Photos & Documents","picture":"ic_camera.png",
                                  "id":"4"])
    }
    
    func addImageLogo(){
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage(named: "logo_vp"), for: .normal)
        //button.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 90)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            let status = data["status"] as! Bool
            
            if !status{
                alertUser(title: "Pas de données", message: nil)
                normalConnection = true
                return
            }
            
            print("Innnnnnnnn")
            print(data)
            
            if let notifData = data["data"] as? [String:Int]{
                Utils.adviceWaitingBills = notifData["nbr_fact"]!
                Utils.adviceWaitingMediation = notifData["avis_mediation"]!
                Utils.messagesNumber = notifData["messages"]!
            }
            
            else{
                alertUser(title: "Erreur données", message: nil)
            }
            
            menuCollectionView.reloadData()
            
            normalConnection = true
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard")
        }
    }
    
    override func reloadFromNotification(){
        menuCollectionView.reloadData()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail2" {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.menuCollectionView.indexPath(for: cell)
            let destinationController = segue.destination as! UITabBarController
            destinationController.selectedIndex = (indexPath?.row)!
            //self.present(destinationController, animated: true, completion:nil)
        }
    }
    

}

// MARK: - UICollectionViewDataSource
extension Home2ViewController : UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menu.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var identifier = "menuItem"
        
        if(indexPath.row == 3){
            identifier = "menuItem2"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MenuCollectionViewCell
        let data = menu[indexPath.item]
        
        if(indexPath.row == 0){
            let adviceNumber = Utils.adviceWaitingBills + Utils.adviceWaitingMediation
            
            print(adviceNumber)
            
            if adviceNumber != 0{
                cell.notification.text = String(adviceNumber)
                cell.displayNotification(true)
            }else{
                cell.displayNotification(false)
            }
        }
            
        else if(indexPath.row == 2){
            let messagesNumber = Utils.messagesNumber
            
            print(messagesNumber)
            
            if messagesNumber != 0{
                cell.notification.text = String(messagesNumber)
                cell.displayNotification(true)
            }else{
                cell.displayNotification(false)
            }
        }
        else{
            cell.displayNotification(false)
        }
        //cell.notification.sizeToFit()
        
        cell.image.image = UIImage(named: data["picture"]!)
        cell.titre.text = data["name"]!
        
        //cell.layer.borderWidth = 0.5
        //cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 5
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension Home2ViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picWidth = (self.view.frame.size.width - 60) / 2.0
        return CGSize(width: picWidth, height: picWidth)
    }
}

// MARK: - UICollectionViewDelegate
extension Home2ViewController : UICollectionViewDelegate{
    
}
