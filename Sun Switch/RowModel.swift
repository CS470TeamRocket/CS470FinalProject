//
//  RowModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class RowModel :NSObject {
    private var pieces : [PieceModel] = [PieceModel]()
    private var index : Int = 0
    private var isLast : Bool = false
    private let columns : Int
    init(row: Int, col: Int, last: Bool) {
        index = row
        columns = col
        isLast = last
    }

    func setLast(val : Bool) {
        isLast = val
    }
    
    func addPiece(piece: PieceModel) {
        pieces.append(piece)
    }
	
	func getPiece(col: Int) ->PieceModel {
		return pieces[col]
	}
    
    func printRow() {
        var output : String = "[ "
        for i in 0 ..< columns {
            output += "\(pieces[i].getTextIcon()) "
        }
        output += "]"
        print(output)
    }
	
	func rotate(dir: direction){
		if(dir == direction.left) {
			pieces.append(pieces.removeFirst())
		}
		else {
			pieces.insert(pieces.removeLast(), at: 0)
		}
	}

    func changePiece(col: Int, other: PieceModel) {
        pieces[col].swap(new: other)
    }
}
