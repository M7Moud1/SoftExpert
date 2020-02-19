//
//  AppDelegate.swift
//  SoftExpert
//
//  Created by Mahmoud helmy on 2/18/20.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SoftExpert")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch let error as NSError {
                    print("Ops there was an error \(error.localizedDescription)")
                    abort()
                }
            }
        }
        
    }
    
     lazy var applicationDocumentsDirectory: NSURL = {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return urls[urls.count-1] as NSURL
        }()
        lazy var managedObjectModel: NSManagedObjectModel = {
            // 1
            let modelURL = Bundle.main.url(forResource: "SoftExprt", withExtension: "momd")!
            return NSManagedObjectModel(contentsOf: modelURL)!
        }()
        lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            let url = self.applicationDocumentsDirectory.appendingPathComponent("SoftExprt.sqlite")
            do {
                // If your looking for any kind of migration then here is the time to pass it to the options
                try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
            } catch let  error as NSError {
                print("Ops there was an error \(error.localizedDescription)")
                abort()
            }
            return coordinator
        }()

        lazy var managedObjectContext: NSManagedObjectContext = {
            //    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the
            //    application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to
            //    fail.
            let coordinator = self.persistentStoreCoordinator
            var context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            return context
        }()
}

