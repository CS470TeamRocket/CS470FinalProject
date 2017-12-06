//
//  TimeStop.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class TimeStopAbility: AbilityModel {
    override init() {
        super.init()
        image = "Person2.png" //Placeholder
        name = "TimeWarp"
        desc = "Time is at your beck and call! Stop it in its tracks using the trace flow backimeter"
        cost = 1000
        level = 1
    }
    
    override func doAbility() {
        super.doAbility()
        UserDataHolder.shared.currentGameModel?.stopTime(delay: 8, hard: false)
    }
    
}
