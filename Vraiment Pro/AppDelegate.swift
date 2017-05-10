//
//  AppDelegate.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 04/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timerAutoLoad:Timer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        registerForPushNotifications(application)
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 86/255.0, green: 90/255.0, blue: 91/255.0, alpha: 1)], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1)], for:.selected)
        
        //setTitleTextAttributes([NSForegroundColorAttributeName: UIColor(red: 86/255.0, green: 90/255.0, blue: 91/255.0, alpha: 1)], for: UIControlState.normal)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
//        self.saveContext()
    }
    
// MARK: - Background fetching
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Fetching data")
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        //Utils.messagesNumber = 5
        getData()
    }
    
    func getData() {
        
        timerAutoLoad = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(self.getDataNotifications), userInfo: nil, repeats: true)
        
    }
    
    func getDataNotifications() {
        print("Fetching data : \(Date())")
        print("Fetching data : in searching data")
        
        if(Utils.userKey == "" && Utils.userId == 0){
            timerAutoLoad?.invalidate()
            return
        }
        
        let req = Utils.wsDomain + Webservice.URL_API + "avis-message-non-lu" + Webservice.header()
        
        let data = NSData(contentsOf: URL(string: req)!)
        
        if let data = data as? Data{
            do{
                let myData = try JSONSerialization.jsonObject(with: data, options:.allowFragments)
                if let data = myData as? [String:Any]{
                    if let status = data["status"] as? Bool{
                        if let notifData = data["data"] as? [String:Int], status{
                            print("Fetching data : in changing data")
                            Utils.messagesNumber = notifData["messages"]!
                        }
                    }
                }
            }catch {
                print("Error with Json: \(error)")
            }
        }
        
        
    }
    
    func registerForPushNotifications(_ application: UIApplication) {
        let notificationTypes:UIUserNotificationType = [UIUserNotificationType.sound,
                                                        UIUserNotificationType.badge,
                                                        UIUserNotificationType.alert]
        
        
        let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        
        
    }

    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        var deviceTokenString = ""
        for i in 0..<deviceToken.count {
            deviceTokenString = deviceTokenString + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("deviceTokenString : " + deviceTokenString)
        Utils.deviceToken = deviceTokenString
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        print("Failed to register:", error)
    }
    
//    private func custom(_ toSend:String){
//        
//        if(Utils.userKey == "" && Utils.userId == 0){
//            return
//        }
//        
//        let req = Utils.wsDomain + Webservice.URL_API + "avis-envoie-demande-sms" + Webservice.header() + "&num=261336421487&nom_de=Test&mois=01&annee=2017&pretention=\(toSend)"
//        
//        print("req : \(req)")
//        if let encoded = req.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
//            let url = URL(string: encoded){
//            
//            let urlRequest: URLRequest = URLRequest(url: url)
//            
//            let session =  URLSession(configuration: .default)
//            
//            let task = session.dataTask(with: urlRequest) {
//                (data, response, error) -> Void in
//                
//                if let httpResponse = response as? HTTPURLResponse{
//                    let statusCode = httpResponse.statusCode
//                    
//                    if (statusCode == 200) {
//                        print("ok")
//                    }
//                    else if(statusCode == 401) {
//                        print("ok 401")
//                    }
//                    else{
//                        print("Status code = \(statusCode)")
//                    }
//                }
//            }
//            
//            task.resume()
//            
//        }
//    }
    
}

