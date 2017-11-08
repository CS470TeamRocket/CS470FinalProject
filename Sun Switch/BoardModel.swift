//
//  BoardModel.swift
//  Sun Switch
//
//  Created by Maurice Baldain on 11/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation

class BoardModel: NSObject {
	private let rows: Int = 5 // Number of starting Rows. The number of columns is determined in the RowModel
	private var currentRows : Int = 5 // Current number of rows. This cannot exceed rows
    private var columns : Int = 8
	private var board : [RowModel] = [RowModel]()
	private var diff : Int
	private var validPieces : [PieceModel] = [PieceModel]()	//The roster of available pieces. This is based
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
        return type(of: validPieces[index].self).init(rowNum: 1, colNum: 1)
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
    
}
