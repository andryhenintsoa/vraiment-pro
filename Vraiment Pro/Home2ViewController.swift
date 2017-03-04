//
//  Home2ViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit
import UserNotifications

class Home2ViewController: MainViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menu : [Dictionary<String,String>] = []
    
    var test = 0
    let categoryIdentifier = "blablabla"
    var updateBadgeTimer:Timer!
    
    deinit{
        Utils.getInstance().removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.getInstance().addObserver(self)
        
        Webservice.numberNotifications(self)
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self

        createButtonsInfo()
        menuCollectionView.reloadData()
        
        //updateBadgeNumber()
        
        updateBadgeTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateBadgeNumber), userInfo: nil, repeats: true)
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
    
    func updateBadgeNumber() {
        if Utils.userId == 0{
            updateBadgeTimer.invalidate()
        }
        Webservice.numberNotifications(self)
        
//        print("test update")
//        Utils.messagesNumber = 3
        
//        let scheduledAlert: UILocalNotification = UILocalNotification()
//        UIApplication.shared.cancelAllLocalNotifications()
//        scheduledAlert.applicationIconBadgeNumber=1
//        scheduledAlert.fireDate=Date(timeIntervalSinceNow: 15)
//        scheduledAlert.timeZone = NSTimeZone.default
//        scheduledAlert.repeatInterval=NSCalendar.Unit.day
//        scheduledAlert.alertBody="Vous avez reçu une demande de contact"
//        UIApplication.shared.scheduleLocalNotification(scheduledAlert)
    }
    
    // MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            if let status = data["status"] as? Bool{
                if !status{
                    normalConnection = true
                    return
                }
                
                //print(data)
                
                if let notifData = data["data"] as? [String:Int]{
                    Utils.adviceWaitingBills = notifData["nbr_fact"]!
                    Utils.adviceWaitingMediation = notifData["avis_mediation"]!
                    Utils.messagesNumber = notifData["messages"]!
                }
                
                Utils.getInstance().notifyAll()
                //menuCollectionView.reloadData()
                
                normalConnection = true
            }
            
            else{
                //alertUser(title: "Erreur données", message: nil)
            }
            
        }
        
        if(!normalConnection){
//            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer\n plus tard")
        }
    }
    
    override func reloadFromNotification(){
        menuCollectionView.reloadData()
    }
    
    // MARK: - Navigation
    
    @IBAction func toHome(sender: UIStoryboardSegue) {
    
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail2" {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.menuCollectionView.indexPath(for: cell)
            let destinationController = segue.destination as! UITabBarController
            
            destinationController.tabBar.items?[3].title = "Photos & Documents"
            
            if #available(iOS 10.0, *) {
                destinationController.tabBar.unselectedItemTintColor = UIColor(red: 86/255.0, green: 90/255.0, blue: 91/255.0, alpha: 1)
            } else {
                for item in destinationController.tabBar.items! as [UITabBarItem] {
                    if let image = item.image {
                        item.image = image.withRenderingMode(.alwaysOriginal)
                    }
                }
            }
            
            destinationController.tabBar.tintColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1)
            
            destinationController.selectedIndex = (indexPath?.row)!
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
            
            //print(adviceNumber)
            
            if adviceNumber != 0{
                cell.notification.text = String(adviceNumber)
                cell.displayNotification(true)
            }else{
                cell.displayNotification(false)
            }
        }
            
        else if(indexPath.row == 2){
            let messagesNumber = Utils.messagesNumber
            
            //print(messagesNumber)
            
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
