//
//  AppDelegate.swift
//  Switch
//
//  Created by Maurice Baldain on 11/6/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import CoreData
import  AVFoundation

struct Defaults {
    static let bestScore: Int = 0
    static let bestTime: Int = 0
    static let TotalCurrency: Int = 50000
    static let unlockedChars : [Bool] = [true, true, false, false]
    static let unlockedAbilities: [Bool] = [false, false]
    //let characters : [CharacterModel]
    //let lockedChars : [CharacterModel]
}

struct Characters {

}

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
        //UserDataHolder.save()
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
            print(UserDefaults.standard.array(forKey: UserDataHolder.shared.UNLOCKED))
            UserDataHolder.shared.updateCharacters(characters: UserDataHolder.shared.characters)
            //resetUserDefaults()

        }
        else {
            print("First Launch")
            resetUserDefaults()
            UserDefaults.standard.set(true, forKey: UserDataHolder.shared.LAUNCHED_BEFORE_KEY)
            //Anything that needs to be set one the first launch should be set here:
            //Set the best score and time to zero
         }
        }
    
    func resetUserDefaults() {
        print("RESET")
        resetScore()
        resetTime()
        resetCharacters()
        //UserDefaults.standard.set(Int(0),forKey: UserDataHolder.shared.BEST_SCORE_KEY)
        //UserDefaults.standard.set(Int(0),forKey: UserDataHolder.shared.BEST_TIME_KEY)
        //UserDefaults.standard.set(Int(50000), forKey: UserDataHolder.shared.TOTAL_CURRENCY)
        UserDefaults.standard.set(Int(2), forKey: UserDataHolder.shared.NUM_UNLOCKED_CHARACTERS)
        UserDefaults.standard.set([], forKey: UserDataHolder.shared.CHARACTER_ID)
        UserDefaults.standard.set([], forKey: UserDataHolder.shared.LOCKED_CHARACTERS_ID)
        UserDefaults.standard.set([], forKey: UserDataHolder.shared.UNLOCKED_CHARACTER_ID)
        UserDefaults.standard.set([], forKey: UserDataHolder.shared.ABILITY_ID)
        UserDefaults.standard.set([true, true, false, false], forKey: UserDataHolder.shared.UNLOCKED)
        UserDefaults.standard.synchronize()
        UserDataHolder.shared.updateCharacters(characters: UserDataHolder.shared.characters)
        //UserDataHolder.shared.updateAllSets()
    }
    
    func resetScore() {
        UserDefaults.standard.set(Defaults.bestScore, forKey: UserDataHolder.shared.BEST_SCORE_KEY)
    }
    
    func resetTime() {
        UserDefaults.standard.set(Defaults.bestTime, forKey: UserDataHolder.shared.BEST_TIME_KEY)
    }
    func resetCharacters() {
        UserDefaults.standard.set(Defaults.unlockedChars, forKey: UserDataHolder.shared.UNLOCKED)
    }
    
    
    
    
    func generateDummyUserData () { //Here to fill the user data with something. to be replaced later, probably with some core data stuff which I don't currently understand
        var abilities: [AbilityModel] = []
        var characters: [CharacterModel] = []
        var unlockedChars: [CharacterModel] = []
        var lockedChars: [CharacterModel] = []
        
        for i in 0...3 { //generating some characters
            
            switch i{
                
            case 0:
                let c = CharacterModel(img: "Chrona.png", name: "Chrona, Time Wizard", ability: TimeStopAbility(id: i),desc: "A reclusive and mysterious figure, gifted with unusual powers over the flow of time itself.", unlocked: true, id: i)
                characters.append(c)
                if c.unlocked! { unlockedChars.append(c) }
                else { lockedChars.append(c); abilities.append(c.ability) }
            case 1:
                let c = CharacterModel(img: "Captain Pointman.png", name: "Captain Pointman", ability:
                    PointBoostAbility(id: i),desc: "A hero to the people, rallying the forces of good against the forces of evil.", unlocked: true, id: i)
                characters.append(c)
                if c.unlocked! { unlockedChars.append(c) }
                else { lockedChars.append(c); abilities.append(c.ability) }
                
            case 2:
                let c = CharacterModel(img: "Doc Boom.png", name: "Doc Boom", ability: DropBombAbility(id: i),desc: "A mad scientist, bent on vengeance, the pursuit of higher knowledge, and explosions.", unlocked: true, id: i)
                characters.append(c)
                if c.unlocked! { unlockedChars.append(c) }
                else { lockedChars.append(c); abilities.append(c.ability) }
            case 3:
                let c = CharacterModel(img: "Person2.png", name: "person \(i)", ability:
                    TeleportAbility(id: i),desc: "this is person \(i)'s description", unlocked: false, id: i)
                characters.append(c)
                if c.unlocked! { unlockedChars.append(c) }
                else { lockedChars.append(c); abilities.append(c.ability) }
            default:
                let c = CharacterModel(img: "Person1.jpg", name: "person \(i)", ability: TimeStopAbility(id: i),desc: "this is person \(i)'s description", unlocked: false, id: i)
                    characters.append(c)
                if c.unlocked! { unlockedChars.append(c) }
                else { lockedChars.append(c); abilities.append(c.ability) }
                
            }
        }
        //characters[2].ability = TeleportAbility()
        //throwing some dummy abilities in there
        //abilities.append(TimeStopAbility())
        //abilities.append(PointBoostAbility())
        //abilities.append(TeleportAbility())
        //abilities.append(DropBombAbility())
        UserDataHolder.shared.setAbilities(abilities: abilities)
        UserDataHolder.shared.setCharacters(characters: characters)
        UserDataHolder.shared.setUnlockedCharacters(characters: unlockedChars)
        UserDataHolder.shared.setLockedCharacters(characters: lockedChars)
    }
    
}
