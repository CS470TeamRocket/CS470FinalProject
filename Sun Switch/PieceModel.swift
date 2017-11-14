//
//  PieceModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
enum pieceType {
    case Planet
    case Moon
    case Star
}

class PieceModel : NSObject {
    private let appearanceLevel : Int = 1 //The first level at which the piece may appear.
    //private var row: Int //Index for row
    //private var column: Int //Index for column
    private var myType : pieceType = pieceType.Planet
    
    required init(type: pieceType /*rowNum: Int, colNum: Int*/) {
        //row = rowNum
       // column = colNum
        myType = type
        super.init()
    }
    func getTextIcon() ->String {
        switch(myType) {
        case pieceType.Planet:
            return "P"
        case pieceType.Moon:
            return "M"
        case pieceType.Star:
            return "S"
        }
    }
    func getType() ->pieceType {
        return myType
    }
    
}
