//
//  PointBoostAbility.swift
//  SSP
//
//  Created by student on 11/27/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class PointBoostAbility: AbilityModel{
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "PointBoost"
        desc = "Boosts Points and stuff"
        cost = 1000
        level = 1
    }
    
    override func doAbility() {
        super.doAbility()
        UserDataHolder.shared.currentGameModel?.pointBoost()
    }
    
    
}
