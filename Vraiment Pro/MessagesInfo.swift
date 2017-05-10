//
//  MessagesInfo.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 29/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

//
//  Message.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 21/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

class MessageInfo{
    var id : Int = 0
    var content : String = ""
    var dateCreation : String = ""
    var title : String = ""
    var state : String = ""
    var type : String = ""
    
    init(data: [String:Any]) {
        self.setId(data["id_msg"] as! Int)
        if let contenu = data["msg_contenu"] as? String{
            self.setContent(contenu)
        }
        
        self.setTitle(data["info_titre"] as! String)
        self.setDateCreation(data["created_at"] as! String)
        
        self.setState("\(data["etat"]!)")
        //self.setType(data["type"] as! String)
    }
    
    func setId(_ id : Int) {
        self.id = id
    }
    
    func setContent(_ content : String) {
        self.content = content
    }
    
    func setTitle(_ title : String) {
        self.title = title
    }
    
    func setDateCreation(_ dateCreation : String) {
        self.dateCreation = dateCreation
    }
    
    func setState(_ state : String) {
        self.state = state
    }
    
    func setType(_ type : String) {
        self.type = type
    }
}
