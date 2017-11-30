//
//  TeleportAbility.swift
//  SSP
//
//  Created by student on 11/27/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import Foundation

class TeleportAbility: AbilityModel {
    override init() {
        super.init()
        image = "Person2.png" //Placeholder
        name = "Teleport"
        desc = "Who's worrying about commute times when you can teleport your workplace to you?"
        cost = 100
        level = 1
    }
    
    override func doAbility() {
        super.doAbility()
    }
    
}
