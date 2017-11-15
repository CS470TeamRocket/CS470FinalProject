//
//  BoardModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
enum direction {
	case .left
	case .right
	case .up
	case .down
}

typealias BoardIndex = (row: Int, col: Int)
typealias Move = (Int, Int, direction)

class BoardModel: NSObject {
	private let rows: Int = 8 // Number of starting Rows. The number of columns is determined in the RowModel
	private var currentRows : Int = 8 // Current number of rows. This cannot exceed rows
    private var columns : Int = 8
	private var board : [RowModel] = [RowModel]()
	private var diff : Int
	private var validPieces : [pieceType] = [pieceType]()	//The roster of available pieces. This is based
												//on the current level.
	init(difficulty: Int) {
		diff = (difficulty <= 0 ) ? 1 : difficulty
		super.init()
		generatePieces(startLevel: diff)
		generateBoard(startLevel: diff)
	}
	
	func generatePieces(startLevel: Int) {
		//This uses the difficulty level to select a number of piece types to add to the
		//roster of available pieces. This will be pretty hard-coded, unfortunately.
        validPieces.append(pieceType.Planet)
        validPieces.append(pieceType.Moon)
        validPieces.append(pieceType.Star)
	}
	func generateBoard(startLevel: Int) {
		//Later: Differentiate build based on starting levels
		//This is used to create a new board, based on starting level.
		
		for i in 0 ..< rows {
            let isLast = (i == rows - 1 ) ? true : false
            board.append(createRow(count: i, isLast: isLast))
		}
		
	}
	
	func newPiece() -> PieceModel{
		//This should hopefully create a new piece based off the type chosen at random.
		
		let index = Int(arc4random_uniform(UInt32(validPieces.count)))
        return PieceModel(type: validPieces[index])
	}
	
	func advanceLevel() {
		//Advance board level.
		//As the level progresses, this will unlock new available pieces, including potential 
		//negative pieces (unbreakable blocks, etc)
		
		diff += 1
		
	}
	
	func restoreRow() {
        board.last!.setLast(val: false)
        let row = createRow(count: currentRows + 1, isLast: true)
		board.append(row)
		currentRows += 1
		//Any other cleanup we might need.
	}
	
    func createRow(count: Int, isLast: Bool) -> RowModel{
        let row = RowModel(row: count, col: columns, last: isLast)
        for _ in 0 ..< columns {
            row.addPiece(piece: newPiece())
        }
		return row
    }
    func missingRows() -> Int {
        if(currentRows < rows) {
            return rows - currentRows
        }
        return 0
    }
    
    func printBoard() {
        for i in 0 ..< rows {
            board[i].printRow()
        }
    }
    func rotateRow(row: Int, dir: direction )-> Bool{
		if(row < rows) {
			board[row].rotate(dir)
			return true
		}
		else {
			return false
		}
	}
	
	func checkAll() {
		let matched = [BoardIndex]()
		for i in 0 ..< rows {
			for j in 0 ..< columns {
				if(checkMatch((i, j))) {
					matched.append((i,j))
				}
			}
		}
	}
	
	func getPiece(index: BoardIndex) {
		return board[index.row].getPiece(index.col)
	}
	
	func checkMatch(index: BoardIndex)->Bool {
		return scanVert(index) >= 3 || scanHoriz(index) >= 3
	}
	
	func scanVert(index: BoardIndex) -> Int {
		let row = index.row 
		let col = index.col
		var matchSize = 1
		var piece = getPiece(index)
		var matched = true
		var i = 1
		//Check above
		while(row-i >= 0 && matched) {
			if(piece.isMatching(getPiece((row-i, col)))) {
				matchSize += 1
			} else {
				matched = false
			}
			i += 1
		}
		
		//Check below 
		i = 1
		matched = true
		while(row+i < rows && matched) {
			if(piece.isMatching(getPiece((row+i, col)))) {
				matchSize +=1
			} else {
				matched = false
			}
			i += 1
		}
			
		return (matchSize >= 3) ? matchSize : 0
	}
	
	func scanHoriz(index: BoardIndex) -> Int {
		let row = index.row 
		let col = index.col
		var matchSize = 1
		var piece = getPiece(index)
		var matched = true
		var i = 1
		//Check left
		while(col-i >= 0 && matched) {
			if(piece.isMatching(getPiece((row, col-i)))) {
				matchSize += 1
			} else {
				matched = false
			}
			i += 1
		}
		
		//Check below 
		i = 1
		matched = true
		while(col+i < columns && matched) {
			if(piece.isMatching(getPiece((row, col+i)))) {
				matchSize +=1
			} else {
				matched = false
			}
			i += 1
		}
			
		return (matchSize >= 3) ? matchSize : 0
	}
	
}	
