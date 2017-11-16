//
//  GameModel.swift
//  Switch Personal
//
//  Created by Maurice Baldain on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import UIKit
import SpriteKit

class GameModel: NSObject {
    var gameBoard: BoardModel!
    
    func startGame(frame: CGRect) {
        gameBoard = BoardModel()
        gameBoard.generatePieces(difficulty: 4, frame: frame)
    }
}
