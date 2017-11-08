//
//  BoardView.swift
//  Sun Switch
//
//  Created by student on 11/8/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit

class BoardView: UIView {
    var boardModel: BoardModel
    var rowViews: [RowView]
    init(boardModel: BoardModel) {
        self.boardModel = boardModel
    }
    
    func MoveRow(magnitude: int, row: int){
        
    }
    
    func SwapTiles(rowA: int, colA: int, rowB: int, colB: int){
        
    }
    
    func MapCoordinate(focus: CGPoint, InputPoint: CGPoint){
        
        
    }
    
}
