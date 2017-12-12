//
//  GetPoints.swift
//  Sun Switch
//
//  Created by student on 12/4/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class GetPointsBonus: BonusModel {
    //This is the money bag bonus, which awards players points and disappears when the player clicks on it.
    override init() {
        super.init()
        image = #imageLiteral(resourceName: "money")
        name = "Money Bags"
        desc = "Don't you sometimes just want some cold, hard, space cash?"
        cost = 1000
        bonusId = 1
        symbol = "$" //Symbol within the game model
        type = pieceType.Money
    }
    
    override func doBonus(row: Int, col: Int) {
        super.doBonus(row: row, col: col)
        UserDataHolder.shared.currentGameModel?.bomb(idx: BoardIndex(row: row, col: col), size: 0)//radius of 0 means only the money bag is destroyed
        UserDataHolder.shared.currentGameModel?.updateScore(500)//addes 500 to the player's score.
    }
    
}
