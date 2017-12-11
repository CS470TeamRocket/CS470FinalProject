//
//  TimeStop.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class TimeStopAbility: AbilityModel {
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "TimeWarp"
        desc = "Time is at your beck and call! Stop it in its tracks using the trace flow backimeter"
        cost = 1000
        level = 1
        warmUpTime = 10
        abilityDuration = 8
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            UserDataHolder.shared.currentGameModel?.stopTime(delay: Int(abilityDuration), hard: false)
            return true
        }
        return false
    }
}
