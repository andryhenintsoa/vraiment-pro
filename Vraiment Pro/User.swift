//
//  Partner.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 21/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

class User{
    var id : Int = 0
    var firstName : String = ""
    var surName : String = ""
    var mail : String = ""
    var phoneHome : String = ""
    var phoneMobile : String = ""
    var state : String = ""
    
    init(data: [String:Any]) {
        self.setId(data["id"] as! Int)
        self.setSurName(data["nom"] as! String)
        self.setFirstName(data["prenom"] as! String)
        self.setMail(data["email"] as! String)
        self.setPhoneMobile(data["tel_mobile"] as! String)
        if let tel = data["tel_fixe"] as? String{
            self.setPhoneHome(tel)
        }
    }
    
    func setId(_ id : Int) {
        self.id = id
    }
    
    func setFirstName(_ firstName : String) {
        self.firstName = firstName
    }
    
    func setSurName(_ surName : String) {
        self.surName = surName
    }
    
    func setPhoneHome(_ mail : String) {
        self.mail = mail
    }
    
    func setPhoneMobile(_ phoneMobile : String) {
        self.phoneMobile = phoneMobile
    }
    
    func setMail(_ mail : String) {
        self.mail = mail
    }
}
