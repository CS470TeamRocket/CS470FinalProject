//
//  TimeStop.swift
//  Switch
//
//  Created by student on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class TimeStopAbility: AbilityModel {
    init() {
        super.init()
        image = "placeHolder"
        name = "TimeWarp"
        desc = "Time is at your beck and call! Stop it in its tracks using the trace flow backimeter"
        level = 1
    }
    
    func doAbility() {
        super.doAbility()
    }
    
    func serialize() -> String {
        a = super.serialize()
        //add that this is a TimeStopAbility, and any other information
        return a
    }
}
