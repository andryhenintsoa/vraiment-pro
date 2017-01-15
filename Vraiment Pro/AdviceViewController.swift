//
//  AdviceViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceViewController: MainViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menu : [Dictionary<String,String>] = []

    deinit{
        Utils.getInstance().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utils.getInstance().addObserver(self)

        createButtonsInfo()
        menuCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// Poser les informations de chaque menu
    func createButtonsInfo(){
        menu.append(["name":"Envoyer une demande d'avis",
                     "id":"1","notif":"0"])
        menu.append(["name":"Avis en attente",
                     "id":"2","notif":"8"])
        menu.append(["name":"Demandes d'avis envoyées",
                     "id":"3","notif":"12"])

    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }

    override func reloadFromNotification(){
        menuCollectionView.reloadData()
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

// MARK: - UICollectionViewDataSource
extension AdviceViewController : UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menu.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        var identifier = "adviceMenuItem"
        
        var notif = 0
        
        if(indexPath.row == 1){
            notif = Utils.adviceWaitingBills + Utils.adviceWaitingMediation
            
            if notif != 0{
                identifier = "adviceMenuItemWithNotif"
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AdviceMenuCollectionViewCell
        let data = menu[indexPath.item]
        
        cell.label.text = data["name"]!
        
        cell.notification.text = "\(notif)"
        
//        cell.layer.borderWidth = 0.5
//        cell.layer.borderColor = UIColor(red: 103, green: 181, blue: 45, alpha: 1).cgColor
        //cell.layer.cornerRadius = 5
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AdviceViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picWidth = (self.view.frame.size.width - 40)
        return CGSize(width: picWidth, height: 55)
    }
}

// MARK: - UICollectionViewDelegate
extension AdviceViewController : UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.reloadData()
        if(indexPath.row == 0){
            performSegue(withIdentifier: "toAdviceRequest", sender: nil)
        }
        else if(indexPath.row == 1){
            performSegue(withIdentifier: "toAdviceWaiting", sender: nil)
        }
        else if(indexPath.row == 2){
            performSegue(withIdentifier: "toAdviceSent", sender: nil)
        }
    }

}

