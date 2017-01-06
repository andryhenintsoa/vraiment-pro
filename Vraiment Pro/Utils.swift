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
    
    static var adviceWaitingBills:Int = 0
    static var adviceWaitingMediation:Int = 0
    static var messagesNumber:Int = 0
    
    var listObservers:[MainViewController]! = []
    private static var instance:Utils?
    
    static func getInstance() -> Utils{
        
        if instance == nil{
            instance = Utils()
        }
        return instance!
    }
    
    private init(){
        
    }
    
    func addObserver(_ controller:MainViewController){
        listObservers.append(controller)
    }
    
    func removeObserver(_ controller:MainViewController){
        
        var counter = 0
        
        for observer in listObservers{
            if observer == controller{
                listObservers.remove(at: counter)
                break
            }
            counter += 1
        }
        
    }
    
    func notifyAll(){
        for observer in listObservers{
            observer.reloadFromNotification()
        }
    }
    
    
}
