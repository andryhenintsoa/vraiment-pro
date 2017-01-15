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

enum docsCategory{
    case documents
    case qualifications
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
    
    static func getListDocsType(_ type:docsCategory) -> [String] {
        
        var list:[String] = []
        
        if type == .documents{
            list = [
                "K-BIS(non-publié)",
                "Assurance RCPRO",
                "Assurance Decennale"]
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
