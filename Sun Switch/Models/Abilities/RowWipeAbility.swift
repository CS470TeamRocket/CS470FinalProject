//
//  RowWipeAbility.swift
//  Sun Switch
//
//  Created by student on 12/10/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class RowWipeAbility: AbilityModel {
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Coronal Mass Ejection"
        cost = 1000
        level = 1
        warmUpTime = 10
        abilityDuration = 0
        desc = "Harness the unquenchable power of the sun. Removes all pieces from the bottommost 3 rows."
    }
    
    override func doAbility() -> (Bool){
        if (super.doAbility()) {
            if let gameModel = UserDataHolder.shared.currentGameModel {
                gameModel.clearBottomRow(3)
                return true
            }
        }
        return false
    }
    
}
