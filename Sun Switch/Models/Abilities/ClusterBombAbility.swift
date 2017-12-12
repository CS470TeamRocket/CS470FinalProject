//
//  ClusterBombAbility.swift
//  Sun Switch
//
//  Created by student on 12/10/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class ClusterBombAbility: AbilityModel {
    //This ability clears multiple locations on the board
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Missile Barrage"
        cost = 1000
        level = 1
        warmUpTime = 15
        abilityDuration = 0
        desc = "Fire the guns. Fire ALL the guns! Destroys a number of random pieces."
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            if let gameModel = UserDataHolder.shared.currentGameModel {
                gameModel.clusterBomb(10)
                return true
            }
        }
        return false
    }
}

