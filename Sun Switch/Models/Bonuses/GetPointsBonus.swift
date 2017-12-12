//
//  GetPoints.swift
//  Sun Switch
//
//  Created by student on 12/4/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class GetPointsBonus: BonusModel {
    override init() {
        super.init()
        image = #imageLiteral(resourceName: "money") 
        //image = "Person2.png" //Placeholder
        name = "Money Bags"
        desc = "Don't you sometimes just want some cold, hard, space cash?"
        cost = 1000
        bonusId = 1
        symbol = "$" //Symbol within the game model
        type = pieceType.Money
    }
    
    override func doBonus(row: Int, col: Int) {
        super.doBonus(row: row, col: col)
        UserDataHolder.shared.currentGameModel?.bomb(idx: BoardIndex(row: row, col: col), size: 0)
        UserDataHolder.shared.currentGameModel?.updateScore(500)
    }
    
}
