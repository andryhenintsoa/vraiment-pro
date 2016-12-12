//
//  MessagesViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController {
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messages : [Dictionary<String,String>] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        
        createMessages()
        messagesTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// Poser les informations de chaque menu
    func createMessages(){
        messages.append(["name":"Publier une photo","statut":"0",
                     "id":"1"])
        messages.append(["name":"Publier Avant / Après, roufr aar g zrg zeronfv. Odpvke g ngjnz tng fd,fgn zjtg jzht aevb dbdf hab gare. ahebjbhrf qbr fnq b rfha zr","statut":"0",
                     "id":"2"])
        messages.append(["name":"Publier un document","statut":"1",
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

extension MessagesViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesItem", for: indexPath) as! MessagesTableViewCell
        let data = messages[indexPath.item]
        
        cell.contentLabel.text = data["name"]!
        cell.contentLabel.sizeToFit()
        
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.borderColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1).cgColor
        
        return cell
    }
}
