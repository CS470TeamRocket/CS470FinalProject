//
//  HomeViewController.swift
//  Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var SUN: UIImageView!
    @IBOutlet weak var SWITCH: UIImageView!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var play: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        SUN.loadGif(name: "s1")
        SWITCH.loadGif(name: "s2")
        generateDummyUserData()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                characters.append(CharacterModel(img: "Person3.jpeg", name: "person \(i)", ability: TeleportAbility(),desc: "this is person \(i)'s description. It is much longer than the others so we can test scrolling. this is person \(i)'s description. It is much longer than the others so we can test scrolling. this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling.this is person \(i)'s description. It is much longer than the others so we can test scrolling."))
            default:
                characters.append(CharacterModel(img: "Person1.jpg", name: "person \(i)", ability: TimeStopAbility(),desc: "this is person \(i)'s description"))
                
            }
        }
        //throwing some dummy abilities in there
        abilities.append(TimeStopAbility())
        abilities.append(PointBoostAbility())
        abilities.append(TeleportAbility())
        UserDataHolder.shared.setAbilities(abilities: abilities)
        UserDataHolder.shared.setCharacters(characters: characters)
    }
    
}


