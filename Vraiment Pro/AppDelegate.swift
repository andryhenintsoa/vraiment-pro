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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        let notificationTypes:UIUserNotificationType = [UIUserNotificationType.sound,
                                                        UIUserNotificationType.badge,
                                                        UIUserNotificationType.alert]
             
        
        let notificationSettings = UIUserNotificationSettings(types: notificationTypes,
                                       categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
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
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        //Utils.messagesNumber = 5
        getDataNotifications()
    }
    
    func getDataNotifications() {
        
        let req = Webservice.URL_API + "avis-message-non-lu" + Webservice.header()
        
        let urlRequest: URLRequest = URLRequest(url: URL(string: req)!)
        
        let session =  URLSession(configuration: .default) //URLSession.shared
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) -> Void in
            
            if let httpResponse = response as? HTTPURLResponse{
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200 || statusCode == 401) {
                    do{
                        let myData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments)
                        DispatchQueue.main.async(execute: { () -> Void in
                            if let data = myData as? [String:Any]{
                                if let status = data["status"] as? Bool{
                                    if let notifData = data["data"] as? [String:Int], status{
                                        Utils.messagesNumber = notifData["messages"]!
                                    }
                                }
                            }
                        })
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
            
        }
        
        task.resume()
    }

//    // MARK: - Core Data stack
//
//    lazy var persistentContainer: NSPersistentContainer = {
//        /*
//         The persistent container for the application. This implementation
//         creates and returns a container, having loaded the store for the
//         application to it. This property is optional since there are legitimate
//         error conditions that could cause the creation of the store to fail.
//        */
//        let container = NSPersistentContainer(name: "Vraiment_Pro")
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                 
//                /*
//                 Typical reasons for an error here include:
//                 * The parent directory does not exist, cannot be created, or disallows writing.
//                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                 * The device is out of space.
//                 * The store could not be migrated to the current model version.
//                 Check the error message to determine what the actual problem was.
//                 */
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    func saveContext () {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }

}

