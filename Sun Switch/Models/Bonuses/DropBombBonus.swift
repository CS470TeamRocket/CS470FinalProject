//
//  DropBomb.swift
//  Sun Switch
//
//  Created by student on 12/4/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class DropBombBonus: BonusModel {
    //This is the bomb bonus, which should clear a 3x3 area around it when the player clicks on it.
    override init() {
        super.init()
        image = #imageLiteral(resourceName: "bomb")
        //image = "Person2.png" //Placeholder
        name = "DropBomb"
        desc = "Blow things up!"
        cost = 2000
        bonusId = 2
        symbol = "*"
        type = pieceType.Bomb
    }
    
    override func doBonus(row: Int, col: Int) {
        super.doBonus(row: row, col: col)
        UserDataHolder.shared.currentGameModel?.bomb(idx: BoardIndex(row: row, col: col), size: 1) //Radius of 1 means the area is 3x3
    }
    
}
