//
//  RowRestoreAbility.swift
//  Sun Switch
//
//  Created by student on 12/11/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import UIKit

class RowRestoreAbility: AbilityModel {
    override init(id: Int) {
        super.init(id: id)
        image = "Person2.png" //Placeholder
        name = "Resurrection"
        cost = 1000
        level = 1
        warmUpTime = 30
        abilityDuration = 0
        desc = "Your fate can be seen. Your fate can be defied. Restore 1 missing row."
    }
    
    override func doAbility() -> (Bool){
        if(abilityReady){
            if let gameModel = UserDataHolder.shared.currentGameModel {
                if(gameModel.board.missingRows() > 0) {
                    gameModel.restoreRow()
                    _ = super.doAbility()
                }
                return true
            }
        }
        return false
    }
}
