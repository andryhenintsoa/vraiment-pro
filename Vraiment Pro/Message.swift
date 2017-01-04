//
//  Message.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 21/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

class Message{
    var id : Int = 0
    var content : String = ""
    var dateCreation : String = ""
    var clientName : String = ""
    var clientMail : String = ""
    var clientNum : String = ""
    var state : String = ""
    
    init(data: [String:Any]) {
        self.setId(data["id_msg"] as! Int)
        if let contenu = data["msg_contenu"] as? String{
            self.setContent(contenu)
        }
        self.setDateCreation(data["created_at"] as! String)
        
        self.setClientName(data["client_nom"])
        self.setClientMail(data["client_email"])
        self.setClientNum(data["client_num"])
        
        self.setState("\(data["etat"]!)")
    }
    
    //    init(firData: FIRDataSnapshot) {
    //        let data = firData.value as! NSDictionary
    //
    //        init(data: data)
    //    }
    
    func setId(_ id : Int) {
        self.id = id
    }
    
    func setContent(_ content : String) {
        self.content = content
    }
    
    func setDateCreation(_ dateCreation : String) {
        self.dateCreation = dateCreation
    }
    
    func setClientName(_ clientName : Any?) {
        //self.clientName = (clientName == nil) ? "" : clientName! as! String
        if let data = clientName as? String{
            self.clientName = data
        }
    }
    
    func setClientMail(_ clientMail : Any?) {
//        self.clientMail = (clientMail == nil) ? "" : clientMail! as! String
        if let data = clientMail as? String{
            self.clientMail = data
        }
    }
    
    func setClientNum(_ clientNum : Any?) {
//        self.clientNum = (clientNum == nil) ? "" : clientNum! as! String
        if let data = clientNum as? String{
            self.clientNum = data
        }
    }
    
    func setState(_ state : String) {
        self.state = state
    }
}
