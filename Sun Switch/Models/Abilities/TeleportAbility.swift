//
//  TeleportAbility.swift
//  SSP
//
//  Created by student on 11/27/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class TeleportAbility: AbilityModel {
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Teleport"
        desc = "Who's worrying about commute times when you can teleport your workplace to you?"
        cost = 1000
        level = 1
        warmUpTime = 10
        abilityDuration = 0
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            UserDataHolder.shared.currentGameModel?.teleport()
            return true
        }
        return false
    }
    
}
