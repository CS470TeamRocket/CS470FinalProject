//
//  DropBomb.swift
//  Sun Switch
//
//  Created by student on 12/4/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class DropBombBonus: BonusModel {
    override init() {
        super.init()
        image = "Person2.png" //Placeholder
        name = "DropBomb"
        desc = "Bomb Stuff"
        cost = 100
    }
    
    override func doBonus(row: Int, col: Int) {
        super.doBonus(row: row, col: col)
        UserDataHolder.shared.currentGameModel?.bomb(idx: BoardIndex(row: row, col: col), size: 1)
    }
    
}
