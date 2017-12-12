//
//  DropBombAbility.swift
//  Sun Switch
//
//  Created by student on 12/2/17.
//  Copyright © 2017 student. All rights reserved.
//
import Foundation

class DropBombAbility: AbilityModel {
    //This ability generates an explosion at the point that the player clicks on after activating it
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Positron Warhead"
        cost = 1000
        level = 1
        warmUpTime = 10
        abilityDuration = 0
        desc = "Such sweet chaos! Select a target piece and annihilate all pieces within a 1 square radius."
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            UserDataHolder.shared.currentGameModel?.setBomb()
            return true
        }
        return false
    }
    
}


