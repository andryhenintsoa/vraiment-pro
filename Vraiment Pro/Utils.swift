//
//  Utils.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 20/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

enum prefKey:String {
    case userId = "userId"
    case userKey = "userKey"
    case userFirstName = "userFirstName"
    case userSurName = "userSurName"
    case userAddress = "userAdress"
    case userCity = "userCity"
    case userMail = "userMail"
    case userAccount = "userAccount"
    case userPhone = "userPhone"
    case userCivility = "userCivility"
}

class Utils{
    static var userId:Int = 0
    static var userKey:String = ""
}
