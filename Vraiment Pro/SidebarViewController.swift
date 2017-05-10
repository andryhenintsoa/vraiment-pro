//
//  SidebarViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class SidebarViewController: MainViewController {
    @IBOutlet weak var contentSidebarView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var dataSidebar: [String] = ["Mes paramètres","Mentions légales","www.vraimentpro.com","Déconnexion"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        
        var nameToDisplay = ""
        
        let firstName = userDefaults.string(forKey: prefKey.userFirstName.rawValue)
        let surName = userDefaults.string(forKey: prefKey.userSurName.rawValue)
        
        if firstName != nil{
            nameToDisplay += firstName!
        }
        if surName != nil{
            if nameToDisplay != ""{
                nameToDisplay += " "
            }
            nameToDisplay += surName!
        }
        
        let userBusiness = userDefaults.string(forKey: prefKey.userBusiness.rawValue)
        if userBusiness != nil{
            nameToDisplay = userBusiness!
        }
        userNameLabel.text = nameToDisplay
        
        self.contentSidebarView.delegate = self
        self.contentSidebarView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeSideBar(_ sender: AnyObject?) {
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.frame.origin.x = self.view.bounds.width
        }, completion: {(_) in
            let presentingController = self.presentingViewController as! MainViewController
            presentingController.displaySidebar(self.view.frame.width, close: true)
        })
    }
    
    override func reloadMyView(_ wsData:Any? = nil, param:[String:Any]=[:]) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let dataKey = param["dataKey"] as? String{
            
            
            if dataKey == "signOutPhoneForNotification"{
                if let data = wsData as? [String:Any]{
                    
//                    if let status = data["status"] as? Bool{
//                        if !status{
//                            normalConnection = true
//                            return
//                        }
                    
                        let userDefaults: UserDefaults = UserDefaults.standard
                        userDefaults.set(true, forKey: prefKey.phoneRegistered.rawValue)
                        
                        Utils.phoneRegistered = true
                        
                        performSegue(withIdentifier: "logOut", sender: nil)
                        
                        normalConnection = true
//                    }
//                    
//                    else{
//                        //alertUser(title: "Erreur données", message: nil)
//                    }
                    
                }
            }
            
        }
        
        if(!normalConnection){
        }
    }
    
}

// MARK: - UITableViewDataSource
extension SidebarViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSidebar.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentSidebarView.dequeueReusableCell(withIdentifier: "sidebarCell", for: indexPath)
        let data = dataSidebar[indexPath.row]
        cell.textLabel?.text = data
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SidebarViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        switch indexPath.row{
        case 0 :
            performSegue(withIdentifier: "toChangeParameters", sender: nil)
            break
        case 1:
            UIApplication.shared.openURL(URL(string: "https://vraimentpro.vobulator.com/#/mention-legale")!)
            break
        case 2:
            UIApplication.shared.openURL(URL(string: "https://vraimentpro.vobulator.com/#/")!)
            break
        case 3:
            Webservice.signOutPhoneForNotification(self)
//            performSegue(withIdentifier: "logOut", sender: nil)
            break
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
