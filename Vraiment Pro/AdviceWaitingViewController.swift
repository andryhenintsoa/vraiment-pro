//
//  AdviceWaitingViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 09/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceWaitingViewController: MainViewController {
    
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
        menu.append(["name":"Avis en attente de facture",
                     "id":"1","notif":"0"])
        menu.append(["name":"Avis en attente de médiation",
                     "id":"2","notif":"5"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
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
extension AdviceWaitingViewController : UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return menu.count
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        var identifier = "adviceMenuItem"
        
        var notif = 0
        
        if(indexPath.row == 0){
            notif = Utils.adviceWaitingBills
        }
        else if(indexPath.row == 1){
            notif = Utils.adviceWaitingMediation
        }
        
        if notif != 0{
            identifier = "adviceMenuItemWithNotif"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AdviceMenuCollectionViewCell
        
        let data = menu[indexPath.item]
        
        cell.label.text = data["name"]!
        
        cell.notification.text = "\(notif)"
        
//        cell.layer.borderWidth = 5
//        cell.layer.borderColor = UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1).cgColor
        //cell.layer.cornerRadius = 5
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AdviceWaitingViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let picWidth = (self.view.frame.size.width - 40)
        return CGSize(width: picWidth, height: 55)
    }
}

// MARK: - UICollectionViewDelegate
extension AdviceWaitingViewController : UICollectionViewDelegate{
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.reloadData()
        if(indexPath.row == 0){
            performSegue(withIdentifier: "toAdviceWaitingBill", sender: nil)
        }
        else if(indexPath.row == 1){
            performSegue(withIdentifier: "toAdviceWaitingMediation", sender: nil)
        }
    }
    
}
