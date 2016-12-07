//
//  AdviceViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdviceViewController: UIViewController {
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menu : [Dictionary<String,String>] = []

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
        menu.append(["name":"Envoyer une demande d'avis",
                     "id":"1"])
        menu.append(["name":"Avis en attente",
                     "id":"2"])
        menu.append(["name":"Demandes d'avis envoyées",
                     "id":"3"])
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adviceMenuItem", for: indexPath) as! AdviceMenuCollectionViewCell
        let data = menu[indexPath.item]
        
        cell.label.text = data["name"]!
        
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red: 103, green: 181, blue: 45, alpha: 1).cgColor
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
    
}

