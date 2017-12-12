//
//  ColumnWipeAbility.swift
//  Sun Switch
//
//  Created by student on 12/11/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class ColumnWipeAbility: AbilityModel {
    //This ability clears a column where the player clicks
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Beam Katana"
        cost = 1000
        level = 1
        warmUpTime = 10
        abilityDuration = 0
        desc = "Witness the dancing of my blade! Deletes the entire center column."
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            if let gameModel = UserDataHolder.shared.currentGameModel {
                gameModel.clearCenterColumn(1)
                return true
            }
        }
        return false
    }
    
}

