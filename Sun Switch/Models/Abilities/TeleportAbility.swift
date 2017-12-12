//
//  TeleportAbility.swift
//  SSP
//
//  Created by student on 11/27/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class TeleportAbility: AbilityModel {
    //This ability swaps the location of two pieces if the player clicks on the ability icon, and then the two peices
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Teleport"
        desc = "The journey continues... Swap two pieces anywhere on the board, regardless of whether a match is produced."
        cost = 1000
        level = 1
        warmUpTime = 8
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
