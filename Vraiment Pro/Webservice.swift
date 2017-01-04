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
    class func imageUpload(_ url: String, controller: MainViewController, imageToSend : UIImage){

        print("Uploading WS")
        print("url: \(url)")
        
        let requestURL: URL = URL(string: url)!
        //let requestURL = URL(string: "http://www.swiftdeveloperblog.com/http-post-example-script/")!;
        //let myUrl = NSURL(string: "http://www.boredwear.com/utils/postImage.php");
        
        var request = URLRequest(url:requestURL);
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
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                
                print(myData)
                
                DispatchQueue.main.async(execute: {
                    controller.reloadMyView(myData)
                })
                
            }
            catch{
                print(error)
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

    class func load(_ url: String, controller: MainViewController) {
        print("Loading WS")
        print("url: \(url)")
        
        let requestURL: URL = URL(string: url)!
        
        load(requestURL, controller: controller)
    }
    
    class func load(_ url: URL, controller: MainViewController) {
        
        let urlRequest: URLRequest = URLRequest(url: url)
        
        let session =  URLSession(configuration: .default) //URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
//            controller.spinnerLoad(false)
            
            var normalConnection = false
            
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    print("Download JSON Done")
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        
                        normalConnection = true
                        DispatchQueue.main.async(execute: { () -> Void in
                            controller.reloadMyView(myData)
                        })
                        
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
                else if(statusCode == 401) {
                    print("Download JSON Done with status code 401")
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        
                        normalConnection = true
                        controller.reloadMyView(myData)
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
    
    class func partners(_ controller: MainViewController){
        let req = URL_API + "mes-partenaires" + header()
        load(req, controller: controller)
    }
   
    class func messages(_ controller: MainViewController){
        let req = URL_API_WEB + "mes-messages" + header()
        load(req, controller: controller)
    }
    
    class func adviceSent(_ controller: MainViewController){
        let req = URL_API + "liste-avis-user" + header()
        load(req, controller: controller)
    }
    
    class func adviceWaitingBill(_ controller: MainViewController){
        let req = URL_API + "avis-attente-facture" + header()
        load(req, controller: controller)
    }
    
    class func adviceWaitingMediation(_ controller: MainViewController){
        let req = URL_API + "avis-attente-moderation" + header()
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
            load(req, controller: controller)
        }
        else{
            if data["sendingType"] == SendingType.mail.rawValue{
                req = URL_API + "demande-avis-avec-facture-mail" + header() + "&to=\(data["mail"]!)&nom_de=\(data["name"]!)&mois=\(data["prestationMonth"]!)&annee=\(data["prestationYear"]!)&pretention=\(data["prestation"]!)"
                
                imageUpload(req, controller: controller, imageToSend: imageToSend!)
            }
            else if data["sendingType"] == SendingType.sms.rawValue{
                req = URL_API + "demande-avis-avec-facture-sms" + header() + "&num=\(data["phone"]!)&nom_de=\(data["name"]!)&mois=\(data["prestationMonth"]!)&annee=\(data["prestationYear"]!)&pretention=\(data["prestation"]!)"
                imageUpload(req, controller: controller, imageToSend: imageToSend!)
            }
        }
    }
    
    class func adviceMediationAnswer(_ controller: MainViewController, data:[String:Any]){
        let req = URL_API + "avis-repondre-moderation" + header() + "&client_id=\(data["client_id"]!)&avis_id=\(data["avis_id"]!)&contenu=\(data["answerText"]!)"
        
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
    
    
    
}

extension NSMutableData {
    
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
