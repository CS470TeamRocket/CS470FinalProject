//
//  DropBombAbility.swift
//  Sun Switch
//
//  Created by student on 12/2/17.
//  Copyright © 2017 student. All rights reserved.
//
import Foundation

class DropBombAbility: AbilityModel {
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "DropBomb"
        desc = "Bomb Stuff"
        cost = 1000
        level = 1
    }
    
    override func doAbility() {
        super.doAbility()
        UserDataHolder.shared.currentGameModel?.setBomb()
    }
    
}


