//
//  BoardModel.swift
//  Switch Personal
//
//  Created by Maurice Baldain on 11/15/17.
//  Copyright © 2017 CodeMunkeys. All rights reserved.
//

import  UIKit
import SpriteKit

class BoardModel: NSObject {
    var board = [[PieceModel]]()
    var tempRow = [PieceModel]()
    let sprite = SKSpriteNode(imageNamed: "icons8-planet")
    let images = ["icons8-moon-phase", "icons8-planet", "icons8-sci-fi", "icons8-satellite-signal"]
    let rows = 9
    let columns = 7
    
    func generatePieces(difficulty: Int, frame: CGRect) {
        for r in 0..<rows {
            let row = generateRow(difficulty: difficulty, frame: frame, r: r)
            board.append(row)
        }
    }
    
    func generateRow(difficulty: Int, frame: CGRect, r: Int) -> [PieceModel] {
        ///var row: [PieceModel] = []
        for c in 0..<columns {
            let piece = generatePiece(r: r, c: c)
            tempRow.append(piece)
        }
        let temp = tempRow
        tempRow = []
        return temp
    }
    
    func generatePiece(r: Int, c: Int) -> PieceModel {
        let x = (c - columns/2) * Int(sprite.size.width + 4)
        let y = (r - rows/2) * Int(sprite.size.width + 10)
        let imgIdx = getImgIdx(r: r, c: c)
        let piece = PieceModel(row: r, column: c, imgIdx: imgIdx, originalCenter: CGPoint(x: x, y: y), sprite: SKSpriteNode(imageNamed: images[imgIdx]))
        return piece
    }
    
    func getImgIdx(r: Int, c: Int) -> Int {
        var z = Int(arc4random()) % 4
        if c > 1, r > 1 {
            while ((tempRow[c-1].imgIdx == z && tempRow[c-2].imgIdx == z) || (board[r-1][c].imgIdx == z && board[r-2][c].imgIdx == z)){
                z = Int(arc4random()) % 4
            }
        }
        else if c > 1 {
            while (tempRow[c-1].imgIdx == z && tempRow[c-2].imgIdx == z) {
                z = Int(arc4random()) % 4
            }
        }
        else if r > 1 {
            while (board[r-1][c].imgIdx == z && board[r-2][c].imgIdx == z) {
                z = Int(arc4random()) % 4
            }
        }
        return z
    }
    
    
    
}
