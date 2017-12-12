//
//  PointBoostAbility.swift
//  SSP
//
//  Created by student on 11/27/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class PointBoostAbility: AbilityModel{
    //This ability boosts the amount of points the player gets by normal means
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Point Rally!"
        cost = 1000
        level = 1
        warmUpTime = 10 //after it is used, you must wait 10 seconds before using it again
        abilityDuration = 8 //pointboost lasts for 8 seconds
        desc = "Let our efforts be multiplied! QDoubles your points earned for \(abilityDuration) seconds!"
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            UserDataHolder.shared.currentGameModel?.pointBoost(duration: abilityDuration, pointValue: 100)
            return true
        }
        return false
    }
    
    
}
