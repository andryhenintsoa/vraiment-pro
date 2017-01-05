//
//  MessagesViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 06/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

enum MessagesType:Int {
    case client = 0
    case vp = 1
}

class MessagesViewController: MainViewController {
    @IBOutlet weak var messagesTableView: UITableView!
    
    @IBOutlet weak var messagesClientButton: UIButton!
    @IBOutlet weak var messagesVPButton: UIButton!
    
    @IBOutlet weak var notificationMessagesClient: UILabel!
    @IBOutlet weak var notificationMessagesClientContainer: UIView!
    
    @IBOutlet weak var notificationMessagesVP: UILabel!
    @IBOutlet weak var notificationMessagesVPContainer: UIView!
    
    var messages : [Message] = []
    var messagesInfo : [MessageInfo] = []
    
    var notificationMessagesClientNumber = 0
    var notificationMessagesVPNumber = 0
    
    var selectedMessagesType:MessagesType = .client

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesClientButton.setTitle("Contacts clients", for: .normal)
        messagesVPButton.setTitle("Infos VraimentPro", for: .normal)
        
        reloadNotifications()
        
        messagesTableView.delegate = self
        
        createMessages()
        Webservice.messages(self)
    }
    
    override func viewWillAppear(_ animated:Bool){
        super.viewWillAppear(animated)
        
//        let messagesCount = CGFloat(messages.count)
//        
//        if messagesCount <= 4{
//            let headerHeight = (messagesTableView.frame.size.height - ( messagesTableView.rowHeight * messagesCount )) / 2
//            
//            messagesTableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
//        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// Poser les informations de chaque menu
    func createMessages(){
        messagesInfo.append(MessageInfo(data:["id_msg":69,"etat":"1","msg_titre":"Assurance","msg_contenu":"Votre assurance RCPRO arrive à écheance.","created_at":"15/12/2016","type":"1"]))
        messagesInfo.append(MessageInfo(data:["id_msg":69,"etat":"1","msg_titre":"Qualification","msg_contenu":"Hdiurehf najerkfnkjfb fdvb zekrhjvbzekrhfb aiurfh azekjfs kdqf","created_at":"24/12/2016","type":"1"]))
        messagesInfo.append(MessageInfo(data:["id_msg":69,"etat":"0","msg_titre":"Info","msg_contenu":"Hdiurehf najerkfnkjfb fdvb zekrhjvbzekrhfb aiurfh azekjfs kdqfHdiurehf najerkfnkjfb fdvb zekrhjvbzekrhfb aiurfh azekjfs kdqfHdiurehf najerkfnkjfb fdvb zekrhjvbzekrhfb aiurfh azekjfs kdqfHdiurehf najerkfnkjfb fdvb zekrhjvbzekrhfb aiurfh azekjfs kdqfHdiurehf najerkfnkjfb fdvb zekrhjvbzekrhfb aiurfh azekjfs kdqf","created_at":"15/12/2016","type":"1"]))
        
        for messageTemp in messagesInfo{
            if messageTemp.state == "0"{
                notificationMessagesVPNumber += 1
            }
        }
        
        print(notificationMessagesVPNumber)
        
        reloadNotifications()
        
        messagesTableView.reloadData()
        
    }

    func reloadNotifications(){
        setNumberOfNotification(notificationMessagesVPNumber, messageType: .vp)
        setNumberOfNotification(notificationMessagesClientNumber, messageType: .client)
    }
    
    func setNumberOfNotification(_ number:Int, messageType:MessagesType){
        if messageType == .client{
            if number == 0 {
                notificationMessagesClientContainer.alpha = 0
                return
            }
            notificationMessagesClientContainer.alpha = 1
            notificationMessagesClient.text = "\(number)"
        }
        else{
            if number == 0 {
                notificationMessagesVPContainer.alpha = 0
                return
            }
            notificationMessagesVPContainer.alpha = 1
            notificationMessagesVP.text = "\(number)"
        }
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }
    
    @IBAction func chooseMessageType(_ sender: UIButton) {
        if(sender == messagesClientButton){
            selectedMessagesType = .client
            setActive(sender, otherButton: messagesVPButton)
            setNotificationTextToGreen(.client)
        }
        else if(sender == messagesVPButton){
            selectedMessagesType = .vp
            setActive(sender, otherButton: messagesClientButton)
            setNotificationTextToGreen(.vp)
        }
        messagesTableView.reloadData()
    }
    
    func chooseMessageType(index: Int) {
        if(index == MessagesType.client.rawValue){
            selectedMessagesType = .client
            setActive(messagesClientButton, otherButton: messagesVPButton)
            setNotificationTextToGreen(.client)
        }
        else if(index == MessagesType.vp.rawValue){
            selectedMessagesType = .vp
            setActive(messagesVPButton, otherButton: messagesClientButton)
            setNotificationTextToGreen(.vp)
        }
        messagesTableView.reloadData()
    }
    
    func setActive(_ button: UIButton, otherButton: UIButton? = nil){
        button.backgroundColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
        button.setTitleColor(UIColor.white, for: .normal)
        
        otherButton?.backgroundColor = UIColor.white
        otherButton?.setTitleColor(UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1), for: .normal)
    }
    
    func setNotificationTextToGreen(_ messageType:MessagesType){
        if messageType == .client{
            
            notificationMessagesClient.textColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
            notificationMessagesClient.backgroundColor = UIColor.white
            
            notificationMessagesVP.textColor = UIColor.white
            notificationMessagesVP.backgroundColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
        }
        
        else{
            notificationMessagesVP.textColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
            notificationMessagesVP.backgroundColor = UIColor.white
            
            notificationMessagesClient.textColor = UIColor.white
            notificationMessagesClient.backgroundColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1)
        }
        
    }
    
// MARK: - Get result of WS
    override func reloadMyView(_ wsData:Any? = nil) {
        //spinnerLoad(false)
        
        var normalConnection = false
        
        if let data = wsData as? [String:Any]{
            
            let listMessages = data["data"] as! [[String:Any]]
            
            var messageTemp:Message?
            for itemMessages in listMessages {
                messageTemp = Message(data: itemMessages)
                messages.append(messageTemp!)
                if messageTemp?.state == "0"{
                    notificationMessagesClientNumber += 1
                }
            }
            
            reloadNotifications()
            
            let messagesCount = CGFloat(messages.count)
            
            if messagesCount <= 4{
                let headerHeight = (messagesTableView.frame.size.height - ( messagesTableView.rowHeight * messagesCount )) / 2
                
                messagesTableView.contentInset = UIEdgeInsetsMake(headerHeight, 0, -headerHeight, 0)
            }
            
            messagesTableView.reloadData()
            
            normalConnection = true
        }
        
        if(!normalConnection){
            alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMessageClientDetail" {
            let destination = segue.destination as? MessagesClientDetailViewController
            
            let data = messages[(messagesTableView.indexPathForSelectedRow?.row)!]
            print(data)
            destination?.message = data
            
            if data.state == "0"{
                data.state = "1"
                notificationMessagesClientNumber -= 1
                reloadNotifications()
            }
            
            destination?.notificationMessagesClientNumber = notificationMessagesClientNumber
            destination?.notificationMessagesVPNumber = notificationMessagesVPNumber
            
        }
        
        else if segue.identifier == "toMessageInfoDetail" {
            let destination = segue.destination as? MessagesVPDetailViewController
            
            let data = messagesInfo[(messagesTableView.indexPathForSelectedRow?.row)!]
            print(data)
            destination?.message = data
            
            if data.state == "0"{
                data.state = "1"
                notificationMessagesVPNumber -= 1
                reloadNotifications()
            }
            
            destination?.notificationMessagesClientNumber = notificationMessagesClientNumber
            destination?.notificationMessagesVPNumber = notificationMessagesVPNumber
            
        }
    }

}

extension MessagesViewController : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if selectedMessagesType == .client{
            return messages.count
        }
        else{
            return messagesInfo.count
        }
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if selectedMessagesType == .client{
            let data = messages[indexPath.item]
            let state = data.state
            var cellIdentifier = ""
            print(state)
            
            if(state == "1"){
                cellIdentifier = "messagesItem"
            }
            else{
                cellIdentifier = "messagesNotReadItem"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessagesTableViewCell
            
            cell.nameLabel.text = data.clientName
            
            cell.contentLabel.text = data.content
            cell.contentLabel.sizeToFit()
            
            cell.dateLabel.text = data.dateCreation
            
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1).cgColor
            
            return cell
        }
        else{
            let data = messagesInfo[indexPath.item]
            let state = data.state
            var cellIdentifier = ""
            
            if(state == "1"){
                cellIdentifier = "messagesInfoItem"
            }
            else{
                cellIdentifier = "messagesInfoNotReadItem"
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessagesTableViewCell
            
            cell.nameLabel.text = data.title
            
            cell.contentLabel.text = data.content
            cell.contentLabel.sizeToFit()
            
            cell.dateLabel.text = data.dateCreation
            
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor(red: 103/255.0, green: 181/255.0, blue: 45/255.0, alpha: 1).cgColor
            
            return cell
        }
        
        
    }
}

extension MessagesViewController : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        tableView.reloadRows(at:[indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
