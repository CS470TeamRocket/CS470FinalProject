//
//  AppDelegate.swift
//  Switch
//
//  Created by Maurice Baldain on 11/6/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        generateDummyUserData()
        fillUserDefaultsIfFirstLaunch()
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
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "SunSwitch")
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
    }

    func fillUserDefaultsIfFirstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: UserDataHolder.shared.LAUNCHED_BEFORE_KEY)
        if launchedBefore {
            print("Not First Launch")

            //resetUserDefaults()

        }
        else {
            print("First Launch")
            UserDefaults.standard.set(true, forKey: UserDataHolder.shared.LAUNCHED_BEFORE_KEY)

            //Anything that needs to be set one the first launch should be set here:
            //Set the best score and time to zero
            resetUserDefaults()
         }
        }
    
    func resetUserDefaults() {
        UserDefaults.standard.set(Int(0),forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        UserDefaults.standard.set(Int(0),forKey: UserDataHolder.shared.BEST_TIME_KEY)
    }
    
    func generateDummyUserData () { //Here to fill the user data with something. to be replaced later, probably with some core data stuff which I don't currently understand
        var abilities: [AbilityModel] = []
        var characters: [CharacterModel] = []
        
        for i in 1...10 { //generating some characters
            switch i%3{
                
            case 0:
                characters.append(CharacterModel(img: "Person1.jpg", name: "person \(i)", ability: TimeStopAbility(),desc: "this is person \(i)'s description"))
            case 1:
                characters.append(CharacterModel(img: "Person2.png", name: "person \(i)", ability:
                    PointBoostAbility(),desc: "this is person \(i)'s description"))
            case 2:
                characters.append(CharacterModel(img: "Person3.jpeg", name: "person \(i)", ability: DropBombAbility(),desc: "this is person \(i)'s description. It is much longer than the others so we can test scrolling. this is person \(i)'s description. It is much longer than the others so we can test scrolling. this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling."))
            default:
                characters.append(CharacterModel(img: "Person1.jpg", name: "person \(i)", ability: TimeStopAbility(),desc: "this is person \(i)'s description"))
                
            }
        }
        //throwing some dummy abilities in there
        abilities.append(TimeStopAbility())
        abilities.append(PointBoostAbility())
        abilities.append(TeleportAbility())
        abilities.append(DropBombAbility())
        UserDataHolder.shared.setAbilities(abilities: abilities)
        UserDataHolder.shared.setCharacters(characters: characters)
    }

}
