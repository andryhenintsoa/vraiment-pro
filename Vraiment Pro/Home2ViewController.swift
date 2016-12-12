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
    var adviceNumber:Int = 0
    var messagesNumber:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self

        createButtonsInfo()
        adviceNumber = 38
        messagesNumber = 12
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuItem", for: indexPath) as! MenuCollectionViewCell
        let data = menu[indexPath.item]
        
        if(indexPath.row == 0){
            print("adviceNumber : \(adviceNumber)")
            if adviceNumber != 0{
                print(1)
                cell.notification.text = String(adviceNumber)
                
            }else{
                print(2)
                cell.displayNotification(false)
            }
        }
        else if(indexPath.row == 2){
            print("messagesNumber : \(messagesNumber)")
            if messagesNumber != 0{
                print(1)
                cell.notification.text = String(messagesNumber)
            }else{
                print(2)
                cell.displayNotification(false)
            }
        }
        else{
            print(5)
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
