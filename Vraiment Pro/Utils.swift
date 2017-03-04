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
    case userPostalCode = "userPostalCode"
    case userMail = "userMail"
    case userAccount = "userAccount"
    case userPhone = "userPhone"
    case userCivility = "userCivility"
    case userBusiness = "userBusiness"
    case countWaitingBills = "countWaitingBills"
    case countWaitingMediation = "countWaitingMediation"
    case countMessages = "countMessages"
}

enum docsCategory{
    case documents
    case qualifications
}

class Utils{
    static var userId:Int = 0
    static var userKey:String = ""
    
//    static var adviceWaitingBillsCount:Int = 0
//    static var adviceWaitingMediationCount:Int = 0
//    static var messagesNumberCount:Int = 0
    
    static var adviceWaitingBills:Int {
        get {
            var count = 0
            let key = prefKey.countWaitingBills.rawValue
            let userDefaults: UserDefaults = UserDefaults.standard
            if userDefaults.value(forKey: key) != nil{
                count = userDefaults.integer(forKey: key)
            }
            return count
        }
        set {
            let userDefaults: UserDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: prefKey.countWaitingBills.rawValue)
            userDefaults.synchronize()
        }
    }
    static var adviceWaitingMediation:Int {
        get {
            var count = 0
            let key = prefKey.countWaitingMediation.rawValue
            let userDefaults: UserDefaults = UserDefaults.standard
            if userDefaults.value(forKey: key) != nil{
                count = userDefaults.integer(forKey: key)
            }
            return count
        }
        set {
            let userDefaults: UserDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: prefKey.countWaitingMediation.rawValue)
            userDefaults.synchronize()
        }
    }
    static var messagesNumber:Int {
        get {
            var count = 0
            let key = prefKey.countMessages.rawValue
            let userDefaults: UserDefaults = UserDefaults.standard
            if userDefaults.value(forKey: key) != nil{
                count = userDefaults.integer(forKey: key)
            }
            return count
        }
        set {
            let key = prefKey.countMessages.rawValue
            let userDefaults: UserDefaults = UserDefaults.standard
            
            //For test - Use setMessagesNumber(_) function instead
            var previousValue = 0
            if userDefaults.value(forKey: key) != nil{
                previousValue = userDefaults.integer(forKey: key)
            }
            if previousValue < newValue{
                let scheduledAlert: UILocalNotification = UILocalNotification()
                UIApplication.shared.cancelAllLocalNotifications()
                scheduledAlert.fireDate=Date(timeIntervalSinceNow: 5)
                scheduledAlert.timeZone = NSTimeZone.default
                scheduledAlert.alertBody="Vous avez reçu\n une demande de contact"
                UIApplication.shared.scheduleLocalNotification(scheduledAlert)
            }
            
            UIApplication.shared.applicationIconBadgeNumber = newValue
            
            userDefaults.set(newValue, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    var listObservers:[MainViewController]! = []
    private static var instance:Utils?
    
    class func setMessagesNumber(_ newValue:Int){
        var previousValue = 0
        let key = prefKey.countMessages.rawValue
        let userDefaults: UserDefaults = UserDefaults.standard
        if userDefaults.value(forKey: key) != nil{
            previousValue = userDefaults.integer(forKey: key)
        }
        if previousValue < newValue{
            let scheduledAlert: UILocalNotification = UILocalNotification()
            UIApplication.shared.cancelAllLocalNotifications()
            scheduledAlert.applicationIconBadgeNumber=newValue
            scheduledAlert.fireDate=Date(timeIntervalSinceNow: 15)
            scheduledAlert.timeZone = NSTimeZone.default
            scheduledAlert.alertBody="Vous avez reçu une demande de contact"
            UIApplication.shared.scheduleLocalNotification(scheduledAlert)
        }
        messagesNumber = newValue
    }
    
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
    
    static func getListDocsType(_ type:docsCategory) -> [String] {
        
        var list:[String] = []
        
        if type == .documents{
            list = [
                "K-BIS (non-publié)",
                "Assurance RCPRO",
                "Assurance Décennale"]
        }
        else if type == .qualifications{
            list = [
                "ADC Fluides",
                "Artisan",
                "Cequami Maison rénovée",
                "Cequami Maison rénovée HQE",
                "Certibat",
                "Chauffage + RGE",
                "Eco Artisan RGE",
                "Handibat",
                "Les PROS de l’accessibilité",
                "Les PROS de la performance énergétique RGE",
                "Maître Artisan",
                "Professionnel du gaz (PG)",
                "Professionnel maintenance Gaz (PMG)",
                "Quali’Eau",
                "Qualibat",
                "Qualibat RGE",
                "Qualibois RGE",
                "QualiClima",
                "Qualifelec",
                "Qualifelec RGE",
                "Qualifioul",
                "Qualiforage RGE",
                "QualiFroid",
                "Qualipac RGE",
                "Qualipaysage",
                "Qualipropre",
                "QualiPV RGE",
                "Qualisav",
                "Qualisol RGE"]
        }
        
//        let list:[String] = [
//            "DOCUMENTS",
//            "K-Bis",
//            "ASSURANCE RCPRO",
//            "ASSURANCE DÉCENNALE",
//            "QUALIFICATIONS / CERTIFICATIONS",
//            "ADC Fluides",
//            "Artisan",
//            "Cequami Maison rénovée",
//            "Cequami Maison rénovée HQE",
//            "Certibat",
//            "Chauffage + RGE",
//            "Eco Artisan RGE",
//            "Handibat",
//            "Les PROS de l’accessibilité",
//            "Les PROS de la performance énergétique RGE",
//            "Maître Artisan",
//            "Professionnel du gaz (PG)",
//            "Professionnel maintenance Gaz (PMG)",
//            "Quali’Eau",
//            "Qualibat",
//            "Qualibat RGE",
//            "Qualibois RGE",
//            "QualiClima",
//            "Qualifelec",
//            "Qualifelec RGE",
//            "Qualifioul",
//            "Qualiforage RGE",
//            "QualiFroid",
//            "Qualipac RGE",
//            "Qualipaysage",
//            "Qualipropre",
//            "QualiPV RGE",
//            "Qualisav",
//            "Qualisol RGE",
//            ]
        return list
    }
    
    
}
