//
//  AppDelegate.swift
//  Switch
//
//  Created by Maurice Baldain on 11/6/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        generateDummyUserData()
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

