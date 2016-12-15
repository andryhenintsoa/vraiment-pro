//
//  SidebarViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class SidebarViewController: UIViewController {
    @IBOutlet weak var contentSidebarView: UITableView!
    
    var dataSidebar: [String] = ["Mes paramètres","Mentions légales","www.vraimentpro.com","Déconnexion"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            }, completion: nil)
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
        if(indexPath.row == 0){
            performSegue(withIdentifier: "toChangeParameters", sender: nil)
        }
        else if(indexPath.row == 1){
            UIApplication.shared.openURL(URL(string: "http://www.stackoverflow.com")!)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
