//
//  Webservice.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 19/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import Foundation

class Webservice{
    
// URL for test
//    static var URL_API:String = "http://41.188.46.56:6922/vp-ws/mobile/";
//    static var URL_API_WEB:String = "http://41.188.46.56:6922/vp-ws/api/";

// URL for deployement
    static var URL_API:String = "https://vraimentpro.vobulator.com/ws/index.php/mobile/";
    static var URL_API_WEB:String = "https://vraimentpro.vobulator.com/ws/index.php/api/";
    
// MARK : Upload image with POST
    
    class func imageUpload(_ url: String, controller: MainViewController, imageToSend : UIImage) {
        
        print("Loading WS")
        print("url: \(url)")
        
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let requestURL = URL(string: encoded){
            imageUpload(requestURL, controller: controller, imageToSend:imageToSend)
        }
        
        
        
    }
    
    class func imageUpload(_ url: URL, controller: MainViewController, imageToSend : UIImage){
        
        controller.spinnerLoad()
        
        var request = URLRequest(url:url);
        request.httpMethod = "POST";
        
        let param = [
            "firstName"  : "Sergey",
            "lastName"    : "Kargopolov",
            "userId"    : "9"
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(imageToSend, 1)
        
        if(imageData==nil)  {
            controller.alertUser(title:"Erreur", message:"Une erreur s'est produite dans le traitement de l'image")
            return
        }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "fichier", imageDataKey: imageData! as Data, boundary: boundary) as Data
        
        let session =  URLSession(configuration: .default) //URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                controller.spinnerLoad(false)
            })
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            do {
                let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                print("Download JSON Done")
                
                print(myData)
                
                DispatchQueue.main.async(execute: {
                    controller.reloadMyView(myData)
                })
                
            }
            catch{
                
                print(error)
                
                controller.reloadMyViewWithError()
            }

        }
        
        task.resume()
    }
    
    
    private class func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> NSData {
        let body = NSMutableData();
        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
        let filename = "user-profile.jpg"
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    private class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
// MARK : Method GET

    class func load(_ url: String, controller: MainViewController, withLoader:Bool = true, param:[String:Any] = [:]) {
        
        print("Loading WS")
        print("url: \(url)")
        
        if let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let requestURL = URL(string: encoded){
            print(requestURL)
            
            load(requestURL, controller: controller, withLoader:withLoader, param:param)
        }
        
        
    }
    
    class func load(_ url: URL, controller: MainViewController, withLoader:Bool = true, param:[String:Any] = [:]) {
        if(withLoader){
            controller.spinnerLoad()
        }
        
        let urlRequest: URLRequest = URLRequest(url: url)
        
        let session =  URLSession(configuration: .default) //URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            if(withLoader){
                DispatchQueue.main.async(execute: { () -> Void in
                    controller.spinnerLoad(false)
                })
            }
            
            var normalConnection = false
            
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    print("Download JSON Done")
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        
                        normalConnection = true
                        DispatchQueue.main.async(execute: { () -> Void in
                            controller.reloadMyView(myData, param:param)
                        })
                        
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
                else if(statusCode == 401) {
                    print("Download JSON Done with status code 401 on the url : \(url)")
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        
                        normalConnection = true
                        controller.reloadMyView(myData, param:param)
                        return
                        
                        
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
                else{
                    print("Status code = \(statusCode)")
                }
            }
            
            if(!normalConnection){
                controller.reloadMyViewWithError()
                return
            }
            
        }
        
        task.resume()
    }
    
    private class func header() -> String{
        return "?key=\(Utils.userKey)&user_id=\(Utils.userId)"
    }
    
    class func authentification(_ controller: MainViewController, email:String, mdp:String){
        let req = URL_API + "connexion?email=\(email)&mdp=\(mdp)"
        load(req, controller: controller)
    }
    
    class func numberNotifications(_ controller: MainViewController){
        let req = URL_API + "avis-message-non-lu" + header()
        load(req, controller: controller, withLoader: false)
    }
    
    class func partners(_ controller: MainViewController){
        let req = URL_API + "mes-partenaires" + header()
        load(req, controller: controller)
    }
   
    class func messages(_ controller: MainViewController){
        let req = URL_API + "mes-messages" + header()
        load(req, controller: controller, withLoader:true, param:["dataKey":"getData"])
    }
    
    class func messageRead(_ controller: MainViewController, data:[String:Any]){
        let req = URL_API_WEB + "lu-ou-non" + "?message_id=\(data["id_msg"]!)"
        load(req, controller: controller)
    }
    
    class func getPreviousPwd(_ controller: MainViewController, data:[String:String]){
        let req = URL_API_WEB + "comparer-mot-de-passe" + header() + "&ancien_mdp=\(data["pwd"]!)"
        load(req, controller: controller, withLoader:false, param:["dataKey":"oldPwd"])
    }
    
    class func changePwd(_ controller: MainViewController, data:[String:String]){
        let req = URL_API_WEB + "modifier-mot-de-passe" + header() + "&nouveau_mdp=\(data["pwd"]!)"
        load(req, controller: controller, withLoader:false, param:["dataKey":"newPwd"])
    }
    
    class func adviceSent(_ controller: MainViewController){
        let req = URL_API + "liste-avis-user" + header()
        load(req, controller: controller)
    }
    
    class func adviceWaitingBill(_ controller: MainViewController){
        let req = URL_API + "avis-attente-facture" + header()
        load(req, controller: controller)
    }
    
    class func adviceSendBills(_ controller: MainViewController, data:[String:Any], imageToSend:UIImage? = nil){
        
        let req = URL_API + "avis-send-attente-facture" + header() + "&avis_id=\(data["avis_id"]!)"
        
        imageUpload(req, controller: controller, imageToSend: imageToSend!)
        
    }
    
    class func adviceWaitingMediation(_ controller: MainViewController){
        let req = URL_API + "avis-attente-moderation" + header()
        load(req, controller: controller)
    }
    
    class func adviceWaitingMediationNotAnswer(_ controller: MainViewController, data:[String:Any]){
        let req = URL_API + "avis-ne-pas-repondre-moderation" + header() + "&avis_id=\(data["avis_id"]!)"
        load(req, controller: controller)
    }
    
    class func adviceSendAdviceByMail(_ controller: MainViewController, data:[String:String]){
        let req = URL_API + "avis-envoie-demande-mail" + header() + "&to=\(data["mail"]!)&nom_de=\(data["name"])&mois=\(data["prestationMonth"])&annee=\(data["prestationYear"])&pretention=\(data["prestationYear"])"
        load(req, controller: controller)
    }
    
    class func adviceSendAdvice(_ controller: MainViewController, data:[String:String], imageToSend:UIImage? = nil){
        
        var req = ""
        
        if data["withFile"] == "no"{
            
            if data["sendingType"]! == SendingType.mail.rawValue{
                req = URL_API + "avis-envoie-demande-mail" + header() + "&to=\(data["mail"]!)&nom_de=\(data["name"]!)&mois=\(data["prestationMonth"]!)&annee=\(data["prestationYear"]!)&pretention=\(data["prestation"]!)"
            }
            else if data["sendingType"]! == SendingType.sms.rawValue{
                
//                let phoneTemp = Int(data["phone"] as! String)
//                let phoneSend = "33\(phoneTemp)"
                
                let phoneSend = data["phone"]! as String
                
                
                req = URL_API + "avis-envoie-demande-sms" + header() + "&num=\(phoneSend)&nom_de=\(data["name"]!)&mois=\(data["prestationMonth"]!)&annee=\(data["prestationYear"]!)&pretention=\(data["prestation"]!)"
            }
            print("req : \(req)")
            if let encoded = req.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                print(url)
                
                load(url, controller: controller)
            }
            
        }
        else{
            if data["sendingType"] == SendingType.mail.rawValue{
                req = URL_API + "demande-avis-avec-facture-mail" + header() + "&to=\(data["mail"]!)&nom_de=\(data["name"]!)&mois=\(data["prestationMonth"]!)&annee=\(data["prestationYear"]!)&pretention=\(data["prestation"]!)"
                
                //imageUpload(req, controller: controller, imageToSend: imageToSend!)
            }
            else if data["sendingType"] == SendingType.sms.rawValue{
                req = URL_API + "demande-avis-avec-facture-sms" + header() + "&num=\(data["phone"]!)&nom_de=\(data["name"]!)&mois=\(data["prestationMonth"]!)&annee=\(data["prestationYear"]!)&pretention=\(data["prestation"]!)"
                //imageUpload(req, controller: controller, imageToSend: imageToSend!)
            }
            
            if let encoded = req.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
                let url = URL(string: encoded){
                print(url)
                
                imageUpload(url, controller: controller, imageToSend: imageToSend!)
            }
        }
    }
    
    class func adviceMediationAnswer(_ controller: MainViewController, data:[String:Any]){
        let req = URL_API + "avis-repondre-moderation" + header() + "&client_id=\(data["client_id"]!)&avis_id=\(data["avis_id"]!)&contenu=\(data["answerText"]!)"
        
//        let req = URL_API + "avis-repondre-moderation" + header() + "&avis_id=\(data["avis_id"]!)&contenu=\(data["answerText"]!)"
        
        if let encoded = req.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded){
            print(url)
            
            load(url, controller: controller)
        }
        else{
            controller.alertUser(title: "Erreur", message: "Il y a une erreur dans l'envoi de ce message")
        }
        
        
    }
    
    class func sendProfile(_ controller: MainViewController, data:[String:Any]){
        
        var req = ""
        
        if data["sendingProfile"] as! String == SendingProfileType.selfProfile.rawValue{
            if data["sendingType"] as! String == SendingType.mail.rawValue{
                req = URL_API + "envoyer-mon-profil-mail" + header() + "&to=\(data["mail"]!)"
            }
            else if data["sendingType"] as! String == SendingType.sms.rawValue{
                
//                let phoneTemp = Int(data["phone"] as! String)
//                let phoneSend = "33\(phoneTemp)"
                
                let phoneSend = data["phone"] as! String
                
                req = URL_API + "envoyer-mon-profil-sms" + header() + "&num=\(phoneSend)"
            }
            load(req, controller: controller)
            
        
        }
        else if data["sendingProfile"] as! String == SendingProfileType.partnersProfile.rawValue{
            
            let users = data["profile"] as! [[String:Any]]
            
            if data["sendingType"] as! String == SendingType.mail.rawValue{
                
                for user in users{
                    req = URL_API + "envoyer-profil-partenaire-mail" + header() + "&to=\(data["mail"]!)&partenaire_id=\(user["id"]!)"
                    load(req, controller: controller)
                }
            }
            else if data["sendingType"] as! String == SendingType.sms.rawValue{
                
                //                let phoneTemp = Int(data["phone"] as! String)
                //                let phoneSend = "33\(phoneTemp)"
                
                let phoneSend = data["phone"] as! String
                
                for user in users{
                    req = URL_API + "envoyer-profil-partenaire-sms" + header() + "&num=\(phoneSend)&partenaire_id=\(user["id"]!)"
                    load(req, controller: controller)
                }
            }
        }
        
        
    }
    
    class func docsSendPic(_ controller: MainViewController, data:[String:String], imageToSend:UIImage? = nil){
        
        let req = URL_API + "photo-sur-mon-profil" + header()
        
        imageUpload(req, controller: controller, imageToSend: imageToSend!)
        
    }
    
    class func docsSendDoc(_ controller: MainViewController, data:[String:String], imageToSend:UIImage? = nil){
        
        //imageUpload(req, controller: controller, imageToSend: imageToSend!)
        
        let req = URL_API + "send-document-backoffice" + header() + "&nature_doc=\(data["type"]!)"
        
        if let encoded = req.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded){
            print(url)
            
            imageUpload(url, controller: controller, imageToSend: imageToSend!)
        }
        else{
            controller.alertUser(title: "Erreur", message: "Il y a une erreur dans l'envoi de ce fichier")
        }
        
    }
    
    
    
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
