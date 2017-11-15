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
    case Empty //Empty case must ALWAYS be last.
}

class PieceModel : NSObject {
    private let appearanceLevel : Int = 1 //The first level at which the piece may appear.
    //private var row: Int //Index for row
    //private var column: Int //Index for column
    private var myType : pieceType = pieceType.Empty
    required init(valid: [pieceType] /*rowNum: Int, colNum: Int*/) {
        //row = rowNum
       // column = colNum
        super.init()
        genType(valid: valid)
    }
    func getTextIcon() ->String {
        switch(myType) {
        case pieceType.Planet:
            return "P"
        case pieceType.Moon:
            return "M"
        case pieceType.Star:
            return "S"
        case pieceType.Empty:
            return " "
        }
    }
    func getType() ->pieceType {
        return myType
    }
	
    func clear() {
        myType = pieceType.Empty
    }
    
    func swap(new: PieceModel) {
        let val = myType
        myType = new.myType
        new.myType = val
    }
    
	func isMatching(other: PieceModel) ->Bool {
        if(myType == pieceType.Empty || other.getType() == pieceType.Empty) {
            return false
        }
		return myType == other.getType()
	}
    
    func genType(valid: [pieceType]) {
        let index = Int(arc4random_uniform(UInt32(valid.count)))
        myType = valid[index]
    }
    
}
